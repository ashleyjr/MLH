module ctrl(
   input             clk,
   input             nRst,
   input       [7:0] data_in,
   input             in,
   input             rx,
   input             busy,
   output      [7:0] status, 
   output reg  [7:0] data_out,
   output reg        out,
   output reg        acc,
   output reg        clear,
   output reg  [3:0] sel,
   output reg  [2:0] serial,
   output            get,
   output reg        send
);
  
   // Opcodes
   parameter      OUT_DATA1   = 3'h0,
                  OUT_DATA2   = 3'h1,
                  OUT_RES     = 3'h2,
                  LOAD        = 3'h3,
                  LOAD_RES    = 3'h4,
                  MUL         = 3'h5,
                  MUL_ADD     = 3'h6,
                  NO_OP       = 3'h7;


   parameter      ADDRESS     = 8'd0,
                  OPCODE      = 8'd1,
                  DECODE      = 8'd2,
                  DATA1       = 8'd3,
                  DATA2       = 8'd4,
                  DATA3       = 8'd5,
                  DATA4       = 8'd6,
                  RETURN      = 8'd7, 
   
   
   
      
               ACC            =8'd8,
               ACC_DONE       = 8'd9,
               STALL          = 8'd10,

               // Send data back
               SEND_ACC_1     = 8'd11, 
               SEND_ACC_2     = 8'd12,
               SEND_ACC_3     = 8'd13,
               SEND_ACC_4     = 8'd14,
               SEND_ACC_5     = 8'd15, 
               SEND_ACC_6     = 8'd16,
               SEND_ACC_7     = 8'd17,
               SEND_ACC_8     = 8'd18,
               SEND_ACC_9     = 8'd19, 
               SEND_ACC_10    = 8'd20,
               SEND_ACC_11    = 8'd21,
               SEND_ACC_12    = 8'd22,
               SEND_ACC_13    = 8'd23, 
               SEND_ACC_14    = 8'd24,
               SEND_ACC_15    = 8'd25,
               SEND_ACC_16    = 8'd26;



   reg   [47:0]      load;    // Address + Opcode +  32 bits
   reg   [6:0]       ptr;
  
   reg   [7:0]    opcode;
   reg   [7:0]    address;
   reg   [7:0]    state;
   reg   [7:0]    data;
   reg   [7:0]    count;
   reg            start;


   // TODO: NEED A TIMEOUT

   assign get = in;
   
   assign status = state;

   always @(posedge clk or negedge nRst) begin
      if(!nRst) begin
         state <= ADDRESS;
         load <= 0;
         serial <= 0;
         send  <= 0;
         count <= 0;
         start <= 0;
      end else begin
         clear <= 0;
         case(state)
            ADDRESS: begin
                        acc <= 0;
                        count <= 0;
                        send <= 0;
                        sel <= 0;
                        if(in) begin
                           state <= OPCODE;
                           address <= data_in;
                        end
                     end
            OPCODE:  if(in) begin
                        state <= DECODE;
                        opcode <= data_in;
                     end
            DECODE:  case(opcode)
                        // 32 bit data op
                        OUT_DATA1:  state <= DATA1;
                        OUT_DATA2:  state <= DATA1;
                        // No data ops
                        OUT_RES:    begin
                                       count <= 0;
                                       send <= 1;
                                       state <= STALL;
                                    end
                        LOAD,    
                        LOAD_RES,   
                        MUL,        
                        MUL_ADD,
                        NO_OP:      begin
                                       send <= 1;
                                       state <= ADDRESS;
                                    end
                     endcase


            // Load data into serial
            DATA1:   if(in)   state <= DATA2;
            DATA2:   if(in)   state <= DATA3;
            DATA3:   if(in)   state <= DATA4;
            DATA4:   if(in) begin
                        send <= 1;
                        state <= ADDRESS; 
                     end


            // Get data back up host uart
            STALL:           begin
                              count <= count + 1;
                              if(count == 16) begin
                                 count <= 0;
                                 state <= ACC;
                                 send <= 1;
                              end
                           end
            ACC:           begin
                              acc <= 1;
                              count <= count + 1;
                              if(count == 127) begin
                                 acc <= 0;
                                 state <= ACC_DONE;
                                 send <= 0;
                              end
                           end
   
            ACC_DONE:   begin
                           out <= 1;
                           state <= SEND_ACC_1;
                        end
            SEND_ACC_1,
            SEND_ACC_2,
            SEND_ACC_3,
            SEND_ACC_4,
            SEND_ACC_5,
            SEND_ACC_6,
            SEND_ACC_7,
            SEND_ACC_8,
            SEND_ACC_9,
            SEND_ACC_10,
            SEND_ACC_11,
            SEND_ACC_12,
            SEND_ACC_13,
            SEND_ACC_14,
            SEND_ACC_15 :    begin
                              out <= 0;
                              acc <= 0;
                              clear <= 0;
                              if(!busy & !out) begin
                                 out <= 1;
                                 sel <= sel + 1;
                                 state <= state + 1;
                              end
                           end
            SEND_ACC_16 :  begin
                              out <= 0;
                              state <= ADDRESS;   
                           end
            default:    state <= ADDRESS;
         endcase
      end
   end
endmodule
