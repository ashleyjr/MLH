`timescale 1ns/1ps


module tb;
   parameter CLK_PERIOD = 20;          // 50MHz clock - 20ns period  


   reg            clk;
   reg            nRst;
   reg            in;
   wire           out;

   integer i,j;


   percept_wrapper percept_wrapper(
      .clk           (clk        ),
      .nRst          (nRst       ),
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
      input [7:0]    address;
      input [63:0]   data;
      integer i;
      begin
         for(i=7;i>=0;i=i-1) begin  
            in  = address[i];
            #CLK_PERIOD;
         end
         in = 1;
         #CLK_PERIOD;
         for(i=63;i>=0;i=i-1) begin  
            in  = data[i];
            #CLK_PERIOD;
         end
         in = 1;
      end
   endtask
   
   initial begin
      #100           nRst = 1;
      #100           nRst = 0;
      #100           nRst = 1;
      #10000          write(8'h55,256);
      #10000          write(8'hAA,128);
      #1000
      $finish;
   end




endmodule

