module acc(
   input             clk,
   input             nRst,
   input             rx,
   input             add,
   input    [3:0]    sel,
   output   [7:0]    data
);

   reg   [31:0]      shift;
   reg   [127:0]     big;
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
            WAIT:    if(add) begin
                        shift <= {shift,rx};
                        state <= SHIFT;
                     end
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
