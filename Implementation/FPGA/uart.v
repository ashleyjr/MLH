module uart(
   input          clk,
   input          nRst,
   input          transmit,   // Raise to trasmit
   input    [7:0] data_tx,    // Transmit this
   input          rx,
   output         busy_tx,
   output         busy_rx,
   output         recieved,   // Raised when byte recieved, zero when getting
   output   [7:0] data_rx,    // This is recieved
   output         tx
);

   // Outputs
   reg         busy_tx;
   reg         recieved;
   reg         tx;
   reg         busy_rx;
   reg [7:0]   data_rx;  
   

   // Params
   parameter   BAUD = 9'd5208, 
               BAUD_05 = BAUD / 2;

   parameter   RX_IDLE  = 4'b0000, 
               RX_START = 4'b0001, 
               RX_1     = 4'b0010,
               RX_2     = 4'b0011,
               RX_3     = 4'b0100,
               RX_4     = 4'b0101,
               RX_5     = 4'b0110,
               RX_6     = 4'b0111,
               RX_7     = 4'b1000,
               RX_8     = 4'b1001,
               RX_WAIT  = 4'b1010;

   parameter   TX_IDLE  = 4'b0000, 
               TX_START = 4'b0001, 
               TX_1     = 4'b0010,
               TX_2     = 4'b0011,
               TX_3     = 4'b0100,
               TX_4     = 4'b0101,
               TX_5     = 4'b0110,
               TX_6     = 4'b0111,
               TX_7     = 4'b1000,
               TX_8     = 4'b1001,
               TX_WAIT  = 4'b1010;

   // Internal Regs
   reg [3:0]   state_rx;
   reg [8:0]   count_rx;
   reg [7:0]   shift_rx;

   reg [3:0]   state_tx;
   reg [8:0]   count_tx;
   reg [7:0]   shift_tx;
 

     
   // Serial clock generation - 115200 baud = 50MHz/5208
   always @(posedge clk or negedge nRst) begin
      if(!nRst) begin

         // RX
         count_rx    <= 0;
         shift_rx    <= 0;
         busy_rx     <= 0;
         state_rx    <= RX_IDLE;

         // TX
         count_tx    <= 0;
         shift_tx    <= 0;
         busy_tx     <= 0;
         state_tx    <= TX_IDLE;
         tx          <= 1;

      end else begin

         // RX state machine
         count_rx <= count_rx + 1;
         case(state_rx)
            RX_IDLE:    begin                                     // Wait for incoming
                           count_rx    <= 0;
                           recieved    <= 0;
                           if(!rx) begin
                              state_rx <= RX_START;
                              busy_rx  <= 1; 
                           end
                        end
            RX_START:   if(count_rx == BAUD_05) begin             // Half sample
                           state_rx    <= RX_1;
                           count_rx    <= 0;
                        end
            RX_1, 
            RX_2, 
            RX_3, 
            RX_4, 
            RX_5, 
            RX_6, 
            RX_7:       if(count_rx == BAUD) begin                // Shift in bits
                           shift_rx    <= {rx,shift_rx[7:1]};
                           count_rx    <= 0;
                           state_rx    <= state_rx + 1;
                        end
            RX_8:       if(count_rx == BAUD) begin                // Last bit
                           data_rx     <= {rx,shift_rx[7:1]};
                           count_rx    <= 0;
                           state_rx    <= RX_WAIT;
                           recieved    <= 1;
                        end
            RX_WAIT:    begin
                           recieved    <= 0;
                           if(rx) begin                           // Wait for line to go high
                              busy_rx     <= 0;
                              state_rx    <= RX_IDLE;
                              count_rx    <= 0;
                           end
                        end
            default:    state_rx       <= RX_IDLE;
         endcase



         // TX state machine
         count_tx <= count_tx + 1;
         case(state_tx)
            TX_IDLE:    begin                                     // When told to transmit take line low
                           count_tx    <= 0;
                           if(transmit) begin
                              shift_tx <= data_tx;
                              state_tx <= TX_1;
                              busy_tx  <= 1;
                              tx       <= 0; 
                           end
                        end
            TX_1, 
            TX_2, 
            TX_3, 
            TX_4, 
            TX_5, 
            TX_6, 
            TX_7,
            TX_8:       if(count_tx == BAUD) begin                // Shift out bits
                           tx          <= shift_tx[0];
                           shift_tx    <= shift_tx >> 1;
                           count_tx    <= 0;
                           state_tx    <= state_tx + 1;
                        end
            TX_WAIT:    if(count_tx == BAUD) begin                // Return line high and wait
                           state_tx    <= TX_IDLE;
                           tx          <= 1;
                           busy_tx     <= 0;
                        end
            default:    state_tx       <= TX_IDLE;
         endcase
      end
   end
endmodule
