module percept(
   input             clk,
   input             nRst,
   input             write,
   input    [7:0]    in,   
   input    [7:0]    weight,
   output   [15:0]   out
);

   parameter   DATA  = 1;
   parameter   CALC  = 0;

   reg   [7:0]    percept_in;
   reg   [7:0]    percept_weight;
   reg   [15:0]   out;
   reg            state;
   

   // TURN INPUT in to shift register!!
   always @(posedge clk or negedge nRst) begin
      if (!nRst) begin
         percept_in     <= 0;
         percept_weight <= 0;
         state          <= DATA;
      end else begin
         case(state)
            DATA:    if(write) begin
                        percept_in     <= in;
                        percept_weight <= weight;
                        state          <= CALC;
                     end
            CALC:    if(!write) begin
                        out   <= percept_in*percept_weight;
                        state <= DATA;
                     end
            default: state <= DATA;
         endcase
      end
   end


endmodule
