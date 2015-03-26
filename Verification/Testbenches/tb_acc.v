`timescale 1ns/1ps


module tb;
   parameter CLK_PERIOD = 20;          // 50MHz clock - 20ns period  


   reg            clk;
   reg            nRst;
   reg            rx;
   reg            add;
   reg   [3:0]    sel;
   wire  [7:0]    data; 

   integer i,j;


   acc acc(
      .clk        (clk        ),
      .nRst       (nRst       ),
      .rx         (rx         ),
      .add        (add        ),
      .sel        (sel        ),
      .data       (data       )
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
                     add   = 0;
                     rx    = 1;
      #100           nRst  = 1;
      #100           nRst  = 0;
      #100           nRst  = 1;
 
      #10000         shift_and_add(32'hAAAAAAAA);
      #10000
      #10000         shift_and_add(32'hAAAAAAAA);
      #10000
      #10000         shift_and_add(32'hAAAAAAAA);
      #10000
      $finish;
   end




endmodule

