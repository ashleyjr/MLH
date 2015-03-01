module demux_1_to_4(
   input 			data_in, 
   input 	[1:0]	address,
   output 	[3:0]	data_out
);

	reg 	[3:0] 	data_out;

	always@(*) begin
   		case(address)
   			2'b00: data_out[0] = data_in;
   			2'b01: data_out[1] = data_in;
   			2'b10: data_out[2] = data_in;
   			2'b11: data_out[3] = data_in;
   		endcase
   	end
endmodule