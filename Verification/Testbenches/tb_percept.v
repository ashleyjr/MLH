`timescale 1ns/1ps


module tb;
   parameter CLK_PERIOD = 20;          // 50MHz clock - 20ns period  
   parameter BAUD_PERIOD = 8700;


   reg            clk;
   reg            nRst;
   reg            shift_in;
   reg            shift_out;
   reg            mul_and_acc;
   reg            data_in;
   wire           data_out;

   integer i,j;



   percept percept(
      .clk           (clk        ),
      .nRst          (nRst       ),
      .shift_in      (shift_in   ),
      .shift_out     (shift_out  ),
      .mul_and_acc   (mul_and_acc),
      .data_in       (data_in    ),
      .data_out      (data_out   )
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

    task shift_in_data;
      input [31:0] in,weight;
      integer i;
      begin
         for(i=31;i>=0;i=i-1) begin  
            shift_in = 1;
            data_in  = weight[i];
            #CLK_PERIOD;
         end
         for(i=31;i>=0;i=i-1) begin  
            shift_in = 1;
            data_in  = in[i];
            #CLK_PERIOD;
         end
         shift_in = 0;
      end
   endtask
   
   initial begin
                     mul_and_acc = 0;
                     shift_in = 0;
                     shift_out = 0;
      #100           nRst = 1;
      #100           nRst = 0;
      #100           nRst = 1;

      #100           shift_in_data(1000,2000);
      #CLK_PERIOD    mul_and_acc = 1;
      #CLK_PERIOD    mul_and_acc = 1;
      #CLK_PERIOD    mul_and_acc = 0;


      #10000         shift_out = 1;

      #10000
      $finish;
   end




endmodule

