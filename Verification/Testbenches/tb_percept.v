`timescale 1ns/1ps


module tb;
   parameter CLK_PERIOD = 20;          // 50MHz clock - 20ns period  


   reg            clk;
   reg            nRst;
   reg            in;
   reg            in_res;
   reg            shift;
   reg            shift_res;
   reg            mul;
   reg            acc;
   wire           out;
   wire           out_res;

   integer i,j;


   percept percept(
      .clk           (clk        ),
      .nRst          (nRst       ),
      .in            (in         ),
      .in_res        (in_res     ),
      .shift         (shift      ),
      .shift_res     (shift_res  ),
      .mul           (mul        ),
      .acc           (acc        ),
      .out           (out        ),
      .out_res       (out_res    )
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
            shift = 1;
            in  = weight[i];
            #CLK_PERIOD;
         end
         for(i=31;i>=0;i=i-1) begin  
            shift = 1;
            in  = data[i];
            #CLK_PERIOD;
         end
         shift = 0;
      end
   endtask

   task shift_out_data;
      integer i;
      begin
         for(i=63;i>=0;i=i-1) begin  
            shift = 1;
            in  = 0;
            #CLK_PERIOD;
         end
         shift = 0;
      end
   endtask

   task shift_out_res;
      integer i;
      begin
         for(i=127;i>=0;i=i-1) begin  
            shift_res = 1;
            in_res  = 0;
            #CLK_PERIOD;
         end
         shift_res = 0;
      end
   endtask
   
   initial begin
                     in_res = 0;
                     mul = 0;
                     acc = 0;
                     shift = 0;
                     shift_res = 0;
      #100           nRst = 1;
      #100           nRst = 0;
      #100           nRst = 1;

      #100           shift_in_data(1000,2000);
      #CLK_PERIOD    mul = 1;
      #CLK_PERIOD    mul = 0;
      #CLK_PERIOD    acc = 1;
      #CLK_PERIOD    acc = 0;
      #100           shift_out_data();
      #100           shift_out_res();





      #10000
      $finish;
   end




endmodule

