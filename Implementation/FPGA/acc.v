module acc(
   input             clk,
   input             nRst,
   input             rx,
   input             ctrl_acc,
   input    [3:0]    ctrl_sel,
   output   [7:0]    acc_data
);

   reg   [31:0]   shift;
   reg [127:0]    acc;
   reg   [1:0]    state;

   parameter   WAIT    = 2'h0;
               SHIFT     = 2'h1;
               ADD    = 2'h2;


   always @(posedge clk or negedge nRst) begin
      if(nRst) begin
         shift_in <= 0;
         acc      <= 0;
         state    <= NO_OP;
      end else begin
         case(state)
            WAIT:    begin
               

                     end
         endcase
         if(ctrl_acc) begin
            shift <= {shift,rx};
         end

      end
   end
  
endmodule
