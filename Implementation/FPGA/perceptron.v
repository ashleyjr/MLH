module perceptron(
   input          clk,
   input          nRst,
   input          rx,    // Transmit this
   output         tx
);

   uart uart(
      .clk        (clk        ),
      .nRst       (nRst       ),
      .transmit   (     ),
      .data_tx    ( ),
      .rx         (rx    ),
      .busy_rx    ( ),
      .recieved   ( ),
      .data_rx    (   ),
      .tx         (tx      )
   );


   registers inputs(
      .clk           (clk        ),
      .nRst          (nRst       ),
      .data_in       (   ),
      .read          (   ),
      .write         (     ),
      .data_out      (    ),
      .valid         (   )
   );

   registers weights(
      .clk           (clk        ),
      .nRst          (nRst       ),
      .data_in       (  ),
      .read          (  ),
      .write         (     ),
      .data_out      (   ),
      .valid         (  )
   );

   parameter   TIMED    = 2500;

   parameter   CHOICE   = 2'b00,
               ADDRESS  = 2'b01,
               WRITE    = 2'b10,
               READ     = 2'b11;

   reg [2:0] state;
   reg [31:0] timeout;

   always @(posedge clk or negedge nRst) begin
      if (!nRst) begin
         timeout  <= 0;
         state    <= CHOICE;
      end else begin
         timeout <= timeout + 1;
         if(timeout == TIMED) begin
            state    <= CHOICE;
            timeout  <= 0;
         end else 
            case(state)
               CHOICE:  state <= ADDRESS;
               ADDRESS: state <= ADDRESS;
               WRITE:   state <= ADDRESS;
               READ:    state <= ADDRESS;
               default: state <= ADDRESS;
            endcase
      end
   end


endmodule