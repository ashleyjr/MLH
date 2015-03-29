`timescale 1ns/1ps


module tb;
   parameter CLK_PERIOD = 20;          // 50MHz clock - 20ns period  


   reg            clk;
   reg            nRst;
   reg            rx;
   reg            add;
   reg            clear;
   wire  [127:0]  big; 

   integer i,j;


   acc acc(
      .clk        (clk        ),
      .nRst       (nRst       ),
      .rx         (rx         ),
      .add        (add        ),
      .clear      (clear      ),
      .big        (big        )
   );

   initial begin
      while(1) begin
         #(CLK_PERIOD/2) clk = 0;
         #(CLK_PERIOD/2) clk = 1;
      end
   end

   initial begin
      $dumpfile("acc.vcd");
      $dumpvars(0,tb);
   end

   initial  begin
      $display("\t\ttime,\tbig"); 
      $monitor("%d:\t%d",$time, acc.big); 
   end 

   task shift_and_add;
      input [31:0]    data;
      integer i;
      begin
         add = 1;
         rx = 0;
         #CLK_PERIOD;
         for(i=31;i>=0;i=i-1) begin 
            rx  = data[i];
            #CLK_PERIOD;
         end
         add = 0;
      end
   endtask

   initial begin
                     clear = 0;
                     add   = 0;
                     rx    = 1;
      #100           nRst  = 1;
      #100           nRst  = 0;
      #100           nRst  = 1;
 

      for(i=0;i < 10;i=i+1) begin
         #1000 shift_and_add(32'h00000001);
      end

      #1000          clear = 1;
      #1000          clear = 0;

      for(i=0;i < 10;i=i+1) begin
         #1000 shift_and_add(32'h10000000);
      end

      #1000          clear = 1;


      for(i=0;i < 10;i=i+1) begin
         #1000 shift_and_add(32'h00000001);
      end

      #10000
      $finish;
   end




endmodule

