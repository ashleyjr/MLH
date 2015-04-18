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
   output reg        tx,
   output reg        acc,
   output reg        clear,
   output reg  [3:0] sel
);
   
   parameter   IDLE           = 8'd0,
               SEND_RX_1      = 8'd1, 
               SEND_RX_2      = 8'd2,
               SEND_RX_3      = 8'd3,
               SEND_RX_4      = 8'd4,
               SEND_RX_5      = 8'd5, 
               SEND_RX_6      = 8'd6,
               SEND_RX_7      = 8'd7,
               SEND_RX_8      = 8'd8,
               SEND_ACC_1     = 8'd9, 
               SEND_ACC_2     = 8'd10,
               SEND_ACC_3     = 8'd11,
               SEND_ACC_4     = 8'd12,
               SEND_ACC_5     = 8'd13, 
               SEND_ACC_6     = 8'd14,
               SEND_ACC_7     = 8'd15,
               SEND_ACC_8     = 8'd16,
               SEND_ACC_9     = 8'd17, 
               SEND_ACC_10    = 8'd18,
               SEND_ACC_11    = 8'd19,
               SEND_ACC_12    = 8'd20,
               SEND_ACC_13    = 8'd21, 
               SEND_ACC_14    = 8'd22,
               SEND_ACC_15    = 8'd23,
               SEND_ACC_16    = 8'd24;




   reg   [7:0]    state;
   reg   [7:0]    data;

   always @(posedge clk or negedge nRst) begin
      if(!nRst) begin
         status <= 8'hAA;
         state <= IDLE;
      end else begin
         clear <= 0;
         case(state)
            IDLE:    begin
                        out      <= 0;
                        acc      <= 0;
                        if(in) begin
                           data     <= data_in;
                           state    <= SEND_RX_1;
                        end
                     end
            SEND_RX_1,
            SEND_RX_2,
            SEND_RX_3,
            SEND_RX_4,
            SEND_RX_5,
            SEND_RX_6,
            SEND_RX_7:  begin
                        data  <= data << 1;
                        acc   <= 1;
                        tx    <= data[7];
                        state <= state + 1;
                     end
            SEND_RX_8:  begin
                        acc   <= 1;
                        tx    <= data[7];
                        state <= SEND_ACC_1;
                        sel <= 0;
                        out <= 1;
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
                              out <= 1;
                              acc <= 0;
                              clear <= 0;
                              if(!busy) begin
                                 sel <= sel + 1;
                                 state <= state + 1;
                              end
                           end
            SEND_ACC_16 :  begin
                              state <= IDLE;   
                           end

         endcase
      end
   end
endmodule
