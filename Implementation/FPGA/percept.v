module percept(
   input             clk,
   input             nRst,
   input             in,
   input             in_res,
   input             shift,
   input             shift_res,
   input             mul,
   input             acc,
   output            out,
   output            out_res
);

   parameter               SIZE  = 32;

   reg   [SIZE-1:0]        data_1;
   reg   [SIZE-1:0]        data_2;
   reg   [(4*SIZE)-1:0]    accumulator;
   
   assign out = data_2[SIZE-1];
   assign out_res = accumulator[(4*SIZE)-1];

   always @(posedge clk or negedge nRst) begin
      if (!nRst) begin
         data_1         <= 0;
         data_2         <= 0;  
         accumulator    <= 0;
      end else begin
         // Only do an op when one bit is high
         case({shift,shift_res,mul,acc})
            4'b1000:    begin
                           data_1      <= {data_1,in};
                           data_2      <= {data_2,data_1[SIZE-1]};
                        end
            4'b0100:    begin
                           accumulator <= {accumulator,in_res};
                        end
            4'b0010:    begin
                           accumulator <= data_1*data_2;
                        end
            4'b0001:    begin
                           accumulator <= accumulator + (data_1*data_2);
                        end
         endcase
      end
   end


endmodule
