`timescale 1ns/1ps


module tb;
   parameter CLK_PERIOD = 20;          // 50MHz clock - 20ns period  
   parameter BAUD_PERIOD = 8700;


   reg            clk;
   reg            nRst;
   reg            write;
   reg   [7:0]    in;
   reg   [7:0]    weight;
   wire  [15:0]   out;

   integer i,j;

   percept percept(
      .clk           (clk        ),
      .nRst          (nRst       ),
      .write         (write      ),
      .in            (in         ),
      .weight        (weight     ),
      .out           (out        )
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


   task mul;
      input [7:0] i, w;
      begin
         #10000   write    = 0;
         #10000   in       = i;
         #10000   weight   = w;
         #10000   write    = 1;
      end
   endtask
   
   initial begin
      #100     nRst     = 1;
               write    = 0;
      #100     nRst     = 0;
      #100     nRst     = 1;

      mul(8,8);
      mul(8,9);
      mul(8,10);
      mul(8,11);


      #10000
      $finish;
   end




endmodule

