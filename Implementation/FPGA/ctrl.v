module ctrl(
   input             clk,
   input             nRst,
   input       [7:0] data_in,
   input             in,
   input             busy,
   output      [7:0] status, 
   output reg        out,
   output reg        acc,
   output reg        clear,
   output reg  [3:0] sel,
   output            get,
   output reg        send
);
  
   // Opcodes
   parameter      OUT_DATA1   = 3'h0,
                  OUT_DATA2   = 3'h1,
                  OUT_RES     = 3'h2,
                  OUT_RES_ADD = 3'h3,
                  LOAD_RES    = 3'h4,
                  MUL         = 3'h5,
                  MUL_ADD     = 3'h6,
                  NO_OP       = 3'h7;
               


   parameter      ADDRESS        = 5'd0,
                  OPCODE         = 5'd1,
                  DECODE         = 5'd2,
                  DATA1          = 5'd3,
                  DATA2          = 5'd4,
                  DATA3          = 5'd5,
                  DATA4          = 5'd6,
                  RETURN         = 5'd7,  
                  ACC            = 5'd8,
                  ACC_DONE       = 5'd9,
                  STALL          = 5'd10,

                  // Send data back
                  SEND_ACC_1     = 5'd11, 
                  SEND_ACC_2     = 5'd12,
                  SEND_ACC_3     = 5'd13,
                  SEND_ACC_4     = 5'd14,
                  SEND_ACC_5     = 5'd15, 
                  SEND_ACC_6     = 5'd16,
                  SEND_ACC_7     = 5'd17,
                  SEND_ACC_8     = 5'd18,
                  SEND_ACC_9     = 5'd19, 
                  SEND_ACC_10    = 5'd20,
                  SEND_ACC_11    = 5'd21,
                  SEND_ACC_12    = 5'd22,
                  SEND_ACC_13    = 5'd23, 
                  SEND_ACC_14    = 5'd24,
                  SEND_ACC_15    = 5'd25,
                  SEND_ACC_16    = 5'd26;


  
   reg   [7:0]    opcode;
   reg   [4:0]    state;
   reg   [8:0]    count;


   // TODO: NEED A TIMEOUT

   assign get = in;
   
   assign status = 8'h00;

   always @(posedge clk or negedge nRst) begin
      if(!nRst) begin
         state    <= ADDRESS;
         opcode   <= 0;
         send     <= 0;
         count    <= 0;
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
                        OUT_RES:       begin
                                          count <= 0;
                                          send <= 1;
                                          state <= STALL;
                                          clear <= 1;
                                       end
                        OUT_RES_ADD:   begin
                                          count <= 0;
                                          send <= 1;
                                          state <= STALL;
                                       end    
                        default:      begin
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
                              clear <= 0;
                              count <= count + 1'b1;
                              if(count == 16) begin
                                 count <= 0;
                                 state <= ACC;
                                 send <= 0;
                              end
                           end
            ACC:           begin
                              acc <= 1;
                              count <= count + 1'b1;
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
                                 sel <= sel + 1'b1;
                                 state <= state + 1'b1;
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
