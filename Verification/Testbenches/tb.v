`timescale 1ns/1ns

module tb;
   parameter CLK_PERIOD = 20;          // 50MHz clock - 20ns period  

   reg         clk;
   reg         nRst;
   reg         tx;
   wire        rx;


   top top(
      .clk        (clk     ),
		.nRst       (nRst    ),
      .rx         (tx      ),
      .tx         (rx      )
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
      $dumpfile("tb.vcd");
      $dumpvars(0,tb);
   end
	
   initial begin
      #100     nRst = 1;
               tx = 1;
      #100     nRst = 0;
      #100     nRst = 1;

      #300000
	   $finish;
	end





endmodule

