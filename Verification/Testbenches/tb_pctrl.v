`timescale 1ns/1ps


module tb;
   parameter CLK_PERIOD = 20;          // 50MHz clock - 20ns period  


   reg            clk;
   reg            nRst;
   reg            rx;
   wire  [2:0]    opcode; 

   integer i,j;


   pctrl pctrl(
      .clk           (clk        ),
      .nRst          (nRst       ),
      .address       (8'hAA      ),
      .rx            (rx         ),
      .opcode        (opcode     )
   );

   initial begin
      while(1) begin
         #(CLK_PERIOD/2) clk = 0;
         #(CLK_PERIOD/2) clk = 1;
      end
   end

   initial begin
      $dumpfile("pctrl.vcd");
      $dumpvars(0,tb);
   end

   task do_op;
      input [7:0]    address;
      input [2:0]    opcode;
      input [61:0]   data;
      integer i;
      begin
         rx = 0;
         #CLK_PERIOD;
         for(i=7;i>=0;i=i-1) begin 
            rx  = address[i];
            #CLK_PERIOD;
         end
         for(i=2;i>=0;i=i-1) begin  
            rx  = opcode[i];
            #CLK_PERIOD;
         end
         for(i=61;i>=0;i=i-1) begin
            rx = data[i];
            #CLK_PERIOD;
         end
      end
   endtask

   initial begin
                     rx    = 1;
      #100           nRst  = 1;
      #100           nRst  = 0;
      #100           nRst  = 1;
 
      #10000         do_op(8'hAA,3'h4,100);
      #10000
      $finish;
   end




endmodule

