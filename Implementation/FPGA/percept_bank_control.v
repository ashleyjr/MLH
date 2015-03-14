module percept_bank_control(
   input             clk,
   input             nRst,
   input       [7:0] data_in,
   input             in,
   input             rx,
   output reg  [7:0] data_out,
   output reg        out,
   output reg        tx
);
   always @(posedge clk or negedge nRst) begin
      data_out <= data_in;
      out <= in;
   end
endmodule
