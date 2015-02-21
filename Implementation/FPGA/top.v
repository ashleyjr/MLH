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



   uart uart(
      .clk        (clk        ),
      .nRst       (nRst       ),
      .transmit   (  recieved    ),
      .data_tx    (data_rx ),
      .rx         (rx    ),
      .busy_rx    ( busy_rx),
      .recieved   (recieved  ),
      .data_rx    (data_rx    ),
      .tx         (tx      )
   );

endmodule
