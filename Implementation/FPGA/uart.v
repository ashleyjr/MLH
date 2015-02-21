module uart(
   input          clk,
   input          nRst,
   input          transmit,   // Raise to trasmit
   input    [7:0] data_tx,    // Transmit this
   input          rx,
   output         busy_rx,
   output         recieved,   // Raised when byte recieved, zero when getting
   output   [7:0] data_rx,    // This is recieved
   output         tx
);

   // Outputs
   reg         recieved;
   reg         tx;
   reg         busy_rx;
   reg [7:0]   data_rx;  
   

   // Params
   parameter   BAUD = 9'd434, 
               BAUD_05 = BAUD / 2;

   parameter   IDLE  = 4'b0000, 
               START = 4'b0001, 
               RX_1  = 4'b0010,
               RX_2  = 4'b0011,
               RX_3  = 4'b0100,
               RX_4  = 4'b0101,
               RX_5  = 4'b0110,
               RX_6  = 4'b0111,
               RX_7  = 4'b1000,
               RX_8  = 4'b1001,
               WAIT  = 4'b1010;


   // Internal Regs
   reg [3:0]   state;
   reg [8:0]   count;
   reg [7:0]   shift_rx;
   reg         ser_clk;
 

     
   // Serial clock generation - 115200 baud = 50MHz/434
   always @(posedge clk) begin
      if(!nRst) begin
         ser_clk  <= 0;
         count    <= 0;
         shift_rx <= 0;
         busy_rx  <= 0;
      end else begin
         count <= count + 1;
         case(state)
            IDLE:    begin                                     // Wait for incoming
                        count       <= 0;
                        recieved    <= 0;
                        if(!rx) begin
                           state    <= START;
                           busy_rx  <= 1; 
                        end
                     end
            START:   if(count == BAUD_05) begin                // Half sample
                        state       <= RX_1;
                        count       <= 0;
                     end
            RX_1, RX_2, RX_3, RX_4, RX_5, RX_6, RX_7:          // Shift in the bits at sample
                     if(count == BAUD) begin
                        shift_rx    <= {rx,shift_rx[7:1]};
                        count       <= 0;
                        state       <= state + 1;
                     end
            RX_8:    if(count == BAUD) begin                   // Last bit
                        data_rx    <= {rx,shift_rx[7:1]};
                        count       <= 0;
                        state       <= WAIT;
                        recieved    <= 1;
                     end
            WAIT:    if(rx) begin                              // Wait for line to go high
                        busy_rx     <= 0;
                        state       <= IDLE;
                        count       <= 0;
                     end
            default: state <= IDLE;
         endcase
      end
   end
endmodule