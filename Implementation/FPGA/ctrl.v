module ctrl(
   input             clk,
   input             nRst,
   input       [7:0] data_in,
   input             in,
   input             rx,
   input             busy,
   output reg  [7:0] status, 
   output reg  [7:0] data_out,
   output reg        out,
   output reg        acc,
   output reg        clear,
   output reg  [3:0] sel,
   output reg  [2:0] serial,
   output            get,
   output reg        send
);
   
   parameter   LOAD           = 8'd0,
               RX             = 8'd1,
               ACC            = 8'd2,

               // Get Bytes
               BYTE_2         = 8'd2,
               BYTE_3         = 8'd3,
               BYTE_4         = 8'd4,
               BYTE_5         = 8'd5,
               
               // Update Array
               DELAY_1        = 8'd9,
               DELAY_2        = 8'd10,
               
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
   
   reg   [7:0]    state;
   reg   [7:0]    data;


   // TODO: NEED A TIMEOUT

   assign get = (state == LOAD) ? in : 1'b0;

   always @(posedge clk or negedge nRst) begin
      if(!nRst) begin
         status <= 8'hAA;
         state <= LOAD;
         load <= 0;
         serial <= 0;
      end else begin
         clear <= 0;
         case(state)

            // Load the 9 bytes in
            LOAD:    begin
                        out      <= 0;
                        acc      <= 0;
                        if(in) begin
                           serial   <= serial + 1; 
                        end
                     end

            // Data in, get it out of the fast serial line
            RX:   begin
                     ptr <= ptr + 1;
                                          if((load[10:8] == 3'd2) && (ptr > 16)) begin
                        acc <= 1;
                     end
                  end

            ACC:  begin
                     state <= LOAD;
                  end


//            RX_1,
//            RX_2,
//            RX_3,
//            RX_4,
//            RX_5,
//            RX_6,
//            RX_7:  begin
//                        data  <= data << 1;
//                        acc   <= 1;
//                        tx    <= data[7];
//                        state <= state + 1;
//                     end
//            RX_8:  begin
//                        acc   <= 1;
//                        tx    <= data[7];
//                        state <= DELAY_1;
//                        sel <= 0;
//                     end
//            DELAY_1: begin
//                        acc <= 0;
//                        state <= DELAY_2;
//                     end
//            DELAY_2: begin
//                        acc <= 0;
//                        out <= 1;
//                        state <= SEND_ACC_1;
//                     end
//            SEND_ACC_1,
//            SEND_ACC_2,
//            SEND_ACC_3,
//            SEND_ACC_4,
//            SEND_ACC_5,
//            SEND_ACC_6,
//            SEND_ACC_7,
//            SEND_ACC_8,
//            SEND_ACC_9,
//            SEND_ACC_10,
//            SEND_ACC_11,
//            SEND_ACC_12,
//            SEND_ACC_13,
//            SEND_ACC_14,
//            SEND_ACC_15 :    begin
//                              out <= 1;
//                              acc <= 0;
//                              clear <= 0;
//                              if(!busy) begin
//                                 sel <= sel + 1;
//                                 state <= state + 1;
//                              end
//                           end
//            SEND_ACC_16 :  begin
//                              state <= IDLE;   
//                           end
//
         endcase
      end
   end
endmodule
