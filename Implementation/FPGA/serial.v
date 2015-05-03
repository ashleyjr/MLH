`timescale 1ns/1ps

module serial(
   input                   clk,
   input                   nRst,
   input       [7:0]       data,
   input       [2:0]       sel,
   input                   send,
   input                   get,
   output reg              tx
);

   reg   [47:0]      load;

   parameter   LOAD     = 2'h0,
               SHIFT    = 2'h1;


   always @(posedge clk or negedge nRst) begin
      if(!nRst) begin
         load     <= 0;
      end else begin
         if(get) begin
            case(sel)
               0: load[7:0]         <= data;
               1: load[15:8]        <= data;
               2: load[23:16]       <= data;
               3: load[31:24]       <= data;
               4: load[39:32]       <= data;
               5: load[47:40]       <= data;
            endcase
         end else begin
            if(send) begin
               tx <= load[0];
               load <= load >> 1;
            end
         end
      end
   end
  
endmodule
