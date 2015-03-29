`timescale 1ns/1ps

module acc(
   input                   clk,
   input                   nRst,
   input                   rx,
   input                   add,
   input                   clear,
   output reg  [127:0]     big
);

   reg   [32:0]      shift;
   reg               state;

   parameter   WAIT     = 2'h0,
               SHIFT    = 2'h1;


   always @(posedge clk or negedge nRst) begin
      if(!nRst) begin
         shift    <= 0;
         big      <= 0;
         state    <= WAIT;
      end else begin
         case(state)
            WAIT:    case({add,clear})
                        2'b10:   begin
                                    shift <= {shift,rx};
                                    state <= SHIFT;
                                 end
                        2'b01:   big <= 0;
                     endcase
            SHIFT:   if(add) begin
                        shift <= {shift,rx};
                     end else begin
                        big <= big + shift;
                        state <= WAIT;
                     end
         endcase
      end
   end
  
endmodule
