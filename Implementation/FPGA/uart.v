module uart(
   input          clk,
   input          nRst,
   input          transmit,   // Raise to trasmit
   input    [7:0] data_tx,    // Transmit this
   input          rx,
   output         busy_tx,
   output         recieved,   // Raised when byte recieved, zero when getting
   output   [7:0] data_rx,    // This is recieved
   output         tx
);

   // Outputs
   reg         recieved;
   reg         tx;
   reg [7:0]   data_rx;  
   

   // Params
   parameter   BAUD = 9'd434, 
               BAUD_05 = 9'd217;

   parameter   IDLE  = 4'b0000, 
               START = 4'b0001, 
               RX_1  = 4'b0010,
               RX_2  = 4'b0011,
               RX_3  = 4'b0100,
               RX_4  = 4'b0101,
               RX_5  = 4'b0110,
               RX_6  = 4'b0111,
               RX_7  = 4'b1000,
               RX_8  = 4'b1001;


   // Internal Regs
   reg [2:0]   state;
   reg [8:0]   count;
   reg         ser_clk;
 
   // Info from regs
   wire busy_tx      = |bitcount_tx[3:1];
   wire sending      = |bitcount_tx;
   wire busy_rx      = |bitcount_rx[3:1];
   wire recieving    = |bitcount_rx;
     
   // Serial clock generation - 115200 baud = 50MHz/434
   always @(posedge clk) begin
      if(!nRst) begin
         ser_clk  <= 0;
         count    <= 0;
      end else begin
         count <= count + 1;
         case(state)
            IDLE:    if(!rx) state <= START;
            START:   if(count == BAUD_05) begin
                        state <= RX_1;
                        count <= 0
                     end
            RX:      if(count == BAUD) begin
                        data_rx     <= {rx,data_rx[7:1]};
                        count       <= 0;
                        state       <= IDLE;
                     end
            default: state <= IDLE;
         endcase
         count    <= count + 1;
         ser_clk  <= 0;
         if(count == 9'd434) begin
            count    <= 0;
            ser_clk  <= 1;
         end
      end
   end

