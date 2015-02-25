module percept(
   input             clk,
   input             nRst,
   input             shift_in,
   input             shift_out,
   input             mul,
   input             acc,   
   input             data_in,
   output            data_out
);

   reg                     data_out;

   parameter               SIZE  = 32;


   reg   [SIZE-1:0]        data_1;
   reg   [SIZE-1:0]        data_2;
   reg   [(2*SIZE)-1:0]    multiplied;
   reg   [(4*SIZE)-1:0]    accumulator;
   

   always @(posedge clk or negedge nRst) begin
      if (!nRst) begin
         data_1         <= 0;
         data_2         <= 0;  
         multiplied     <= 0;
         accumulator    <= 0;
         data_out       <= 0;
      end else begin
         // Only calc whe one bit high
         case({shift_in,shift_out,mul,acc})
            4'b1000: begin
                        data_1      <= {data_1,data_in};
                        data_2      <= {data_2,data_1[SIZE-1]};
                     end
            4'b0100: begin
                        data_out    <= accumulator[(4*SIZE)-1];
                        accumulator <= accumulator << 1;
                     end
            4'b0010: multiplied  <= data_1*data_2;
            4'b0001: accumulator <= accumulator + multiplied;
         endcase
      end
   end


endmodule
