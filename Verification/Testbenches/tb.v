`timescale 1ns/1ns

module tb;
   parameter CLK_PERIOD = 20;          // 50MHz clock - 20ns period  
   parameter BAUD_PERIOD = 8700;

   reg         clk;
   reg         nRst;
   reg         tx;
   wire        rx;

   integer i;

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

   task uart;
      input [7:0] send;
      integer i;
      begin
         tx = 0;
         for(i=0;i<=7;i=i+1) begin   
            #BAUD_PERIOD tx = send[i];
         end
         #BAUD_PERIOD tx = 1;
      end

   endtask
	
   initial begin

      #100     nRst = 1;
               tx = 1;
      #100     nRst = 0;
      #100     nRst = 1;

      for(i=0;i<256;i=i+1) begin
         #100000   uart(8'hAA);
      end

      #300000
	   $finish;
	end





endmodule

