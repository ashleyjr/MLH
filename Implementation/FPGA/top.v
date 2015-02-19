module top(
   input          clk,              // 50 MHz clock input 
   input          nRst,             // Input from reset button (active low)         
   input          rx,               // UART RX
   output         tx                // UART TX
);

   wire [7:0]     data_rx;
   reg [7:0]      data_tx;  

   uart uart(
      .clk        (clk        ),
      .nRst       (nRst       ),
      .transmit   (1'h0       ),
      .data_tx    (8'hAA      ),
      .rx         (rx         ),
      .busy_tx    (busy_tx    ),
      .recieved   (recieved   ),
      .data_rx    (data_rx    ),
      .tx         (tx         )
   );

endmodule
