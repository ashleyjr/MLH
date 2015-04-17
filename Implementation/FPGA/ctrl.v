module ctrl(
   input             clk,
   input             nRst,
   input       [7:0] data_in,
   input             in,
   input             rx,
   output reg  [7:0] data_out,
   output reg        out,
   output reg        tx
);
   always @(posedge clk) begin
      data_out <= data_in;
      out <= in;


   end
endmodule
