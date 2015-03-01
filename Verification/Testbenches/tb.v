`timescale 1ns/1ps


module tb;
   parameter CLK_PERIOD = 20;          // 50MHz clock - 20ns period  
   parameter BAUD_PERIOD = 8700;


   reg            clk;
   reg            nRst;
   reg            in;

   integer i,j;



   percept_front_if percept_front_if_1(
      .clk           (clk        ),
      .nRst          (nRst       ),
      .address       (8'h01      ),
      .in            (in         ),
      .out           (out        )
   );

   percept_front_if percept_front_if_2(
      .clk           (clk        ),
      .nRst          (nRst       ),
      .address       (8'hAA      ),
      .in            (in         ),
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

   task write;
      input [7:0] address;
      input [63:0] data;
      integer i;
      begin
         in  = 0;
         #CLK_PERIOD;
         for(i=7;i>=0;i=i-1) begin  
            in  = address[i];
            #CLK_PERIOD;
         end
         in  = 1;
         #CLK_PERIOD;
         for(i=63;i>=0;i=i-1) begin  
            in  = data[i];
            #CLK_PERIOD;
         end
         in = 1;
      end
   endtask

   task read;
      input [7:0] address;
      integer i;
      begin
         in  = 0;
         #CLK_PERIOD;
         for(i=7;i>=0;i=i-1) begin  
            in  = address[i];
            #CLK_PERIOD;
         end
         in  = 0;
         #CLK_PERIOD;
         for(i=63;i>=0;i=i-1) begin  
            #CLK_PERIOD;
         end
         in = 1;
      end
   endtask
   
   initial begin
      #1               in = 1;
      #100           nRst = 1;
      #100           nRst = 0;
      #100           nRst = 1;

      #1000          write(8'h10,64'h0000000000000000);
      #1000          write(8'h10,64'hAAAAAAAAAAAAAAAA);
      #1000          write(8'hAA,64'h0101010101010101);

      #1000          read(8'hAA);

      #10000
      $finish;
   end




endmodule

