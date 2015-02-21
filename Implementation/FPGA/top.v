module top(
   input          clk,              // 50 MHz clock input 
   input          nRst,             // Input from reset button (active low)         
   input          rx,               // UART RX
   output         tx                // UART TX
);

   wire [7:0]     data_rx;
   reg [7:0]      data_tx;  
   wire           busy_rx;

   wire loop;

   always @(posedge clk or negedge nRst) begin
      if (!nRst)  data_tx <= 0;
      else begin
         data_tx <= data_tx + 1;
      end
   end

   uart uart(
      .clk        (clk        ),
      .nRst       (nRst       ),
      .transmit   (!busy_rx       ),
      .data_tx    (8'hAA   ),
      .rx         (loop        ),
      .busy_rx    ( busy_rx),
      .recieved   (recieved   ),
      .data_rx    (data_rx    ),
      .tx         (loop       )
   );

endmodule
