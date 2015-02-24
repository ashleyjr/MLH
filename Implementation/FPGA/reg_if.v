module reg_if(
   input          clk,
   input          nRst,
   input          rx,    // Transmit this
   input          tx
);

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

   registers registers(
      .clk           (clk        ),
      .nRst          (nRst       ),
      .data_in       (data_in   ),
      .read          (read    ),
      .write         (write       ),
      .data_out      (data_out    ),
      .valid         (valid   )
   );

   

endmodule