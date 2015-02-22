
module tb;
   parameter CLK_PERIOD = 20;          // 50MHz clock - 20ns period  
   
   reg            clk;
   reg            nRst;
   reg   [7:0]    data_in;
   reg            read;
   reg            write;
   wire  [7:0]    data_out;
   wire           valid;


   integer i,j;

   registers registers(
      .clk           (clk        ),
      .nRst          (nRst       ),
      .data_in       (data_in   ),
      .read          (read    ),
      .write         (write       ),
      .data_out      (data_out    ),
      .valid         (valid   )
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
               read = 0;
               write = 0;
      #100     nRst = 1;
      #100     nRst = 0;
      #100     nRst = 1;

      // Rubbish
      
      for(i=0;i<20;i=i+1) begin
         #100 data_in <= i;
      end


      for(i=0;i<20;i=i+1) begin
         read <= 1;
         write <= 1;
         #100 data_in <= i;
      end
      read <= 0;
      write <= 0;




      // Write to regs
      for(i=0;i<256;i=i+1) begin
         #100    data_in <= i;
         #100    write <= 1;
         #100    data_in <= 8'hFF - i;
         #100    write    <= 0;
      end

      // Red from regs
      for(i=0;i<256;i=i+1) begin
         #100     data_in    <= i;
         #100     read <= 1;
         #100     read    <= 0;
      end

      #3000
	   $finish;
	end





endmodule

