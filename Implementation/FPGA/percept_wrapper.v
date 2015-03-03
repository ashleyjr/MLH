module percept_wrapper(
   input             clk,
   input             nRst,
   input             in,
   output            out
);

   wire        shift;
   wire        shift_res;
   wire        mul;
   wire        acc;

  percept percept(
      .clk           (clk        ),
      .nRst          (nRst       ),
      .in            (in         ),
      .in_res        (0          ),
      .shift         (shift      ),
      .shift_res     (shift_res  ),
      .mul           (mul        ),
      .acc           (acc        ),
      .out           (out        ),
      .out_res       (out_res    )
   );

  percept_control percept_control(
      .clk           (clk        ),
      .nRst          (nRst       ),
      .address       (8'hAA      ),
      .in            (in         ),
      .shift         (shift      ),
      .shift_res     (shift_res  ),
      .mul           (mul        ),
      .acc           (acc        )
   );


endmodule
