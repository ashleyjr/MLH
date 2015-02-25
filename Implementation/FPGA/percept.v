module percept(
   input             clk,
   input             nRst,
   input             shift_in,
   input             shift_out,
   input             mul_and_acc,
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
         // Only do an op when one bit is high
         case({shift_in,shift_out,mul_and_acc})
            4'b100:  begin
                        data_1      <= {data_1,data_in};
                        data_2      <= {data_2,data_1[SIZE-1]};
                     end
            4'b010:  begin
                        data_out    <= accumulator[(4*SIZE)-1];
                        accumulator <= accumulator << 1;
                     end
            4'b001:  begin
                        multiplied     <= data_1*data_2;
                        accumulator    <= accumulator + multiplied;
                     end
         endcase
      end
   end


endmodule
