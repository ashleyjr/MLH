module percept(
   input             clk,
   input             nRst,
   input [7:0]       address,
   input             rx,
   output            tx
);

   wire  [7:0] address;
   wire  [2:0] opcode;

   pctrl pctrl(
      .clk           (clk        ),
      .nRst          (nRst       ),
      .address       (address    ),
      .rx            (rx         ),
      .opcode        (opcode     )
   );

   pdata pdata(
      .clk           (clk        ),
      .nRst          (nRst       ),
      .rx            (rx         ),
      .opcode        (opcode     ),
      .tx            (tx         )
   );

endmodule
