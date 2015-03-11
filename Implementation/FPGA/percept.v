module percept(
   input             clk,
   input             nRst,
   input [7:0]       address,
   input             rx,
   output            tx
);

   wire  [7:0] address;
   wire  [2:0] opcode;

   percept_control percept_control(
      .clk           (clk        ),
      .nRst          (nRst       ),
      .address       (address    ),
      .rx            (rx         ),
      .opcode        (opcode     )
   );

   percept_data percept_data(
      .clk           (clk        ),
      .nRst          (nRst       ),
      .rx            (rx         ),
      .opcode        (opcode     ),
      .tx            (tx         )
   );

endmodule
