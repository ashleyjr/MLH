module perceptron(
   input             clk,
   input             nRst,
   input             rx,
   output            tx
);

   uart uart(
      .clk        (clk),
      .nRst       (nRst),
      .transmit   (),
      .data_tx    (),
      .rx         (),
      .busy_tx    (),
      .busy_rx    (),
      .recieved   (),
      .data_rx    (),
      .tx         ()
   );

   percept_bank_control percept_bank_control(
      .clk        (clk),
      .nRst       (nRst),
      .data_in    (),
      .in         (),
      .rx         (),
      .data_out   (),
      .out        (),
      .tx         ()
   );

   percept_bank percept_bank(
      .clk        (clk),
      .nRst       (nRst),
      .rx         (),
      .tx         ()
   );
   
endmodule
