module perceptron(
   input          clk,
   input          nRst,
   input          rx,    // Transmit this
   output         tx
);

   wire           recieved;
   wire  [7:0]    data_rx;
   wire  [15:0]   out;
      
   uart uart(
      .clk           (clk        ),
      .nRst          (nRst       ),
      .transmit      (transmit   ),
      .data_tx       (data_tx    ),
      .rx            (rx         ),
      .busy_rx       (busy_rx    ),
      .recieved      (recieved   ),
      .data_rx       (data_rx    ),
      .tx            (tx         )
   );

   percept percept (  
      .clk           (clk        ),
      .nRst          (nRst       ),
      .shift_in      (shift_in   ),
      .shift_out     (shift_out  ),
      .mul_and_acc   (mul_and_acc),
      .data_in       (data_in    ),
      .data_out      (data_out   )
   );  

endmodule
