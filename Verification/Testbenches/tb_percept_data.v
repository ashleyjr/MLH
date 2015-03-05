`timescale 1ns/1ps


module tb;
   parameter CLK_PERIOD = 20;          // 50MHz clock - 20ns period  


   reg            clk;
   reg            nRst;
   reg            rx;
   reg   [2:0]    opcode; 
   wire           tx;

   integer i,j;


   percept_data percept_data(
      .clk           (clk        ),
      .nRst          (nRst       ),
      .rx            (rx         ),
      .opcode        (opcode     ),
      .tx            (tx         )
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
      input [31:0] data,weight;
      integer i;
      begin
         for(i=31;i>=0;i=i-1) begin  
            rx  = weight[i];
            #CLK_PERIOD;
         end
         for(i=31;i>=0;i=i-1) begin  
            rx  = data[i];
            #CLK_PERIOD;
         end
      end
   endtask
 
   initial begin
                     opcode = 7;
      #100           nRst = 1;
      #100           nRst = 0;
      #100           nRst = 1;

                     opcode = 0;
      #100           shift_in_data(1000,2000);
  
                     opcode = 1;
      #100           shift_in_data(1000,2000);
   
                     opcode = 2;
      #100           shift_in_data(1000,2000);

                     opcode = 3;
      #100           shift_in_data(1000,2000);
  
                     opcode = 4;
      #100           shift_in_data(1000,2000);
   
                     opcode = 5;
      #100           shift_in_data(1000,2000);
   
                     opcode = 6;
      #100           shift_in_data(1000,2000);
  
                     opcode = 7;
      #100           shift_in_data(1000,2000);
  

      #10000
      $finish;
   end




endmodule

