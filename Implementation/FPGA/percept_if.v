module percept_front_if(
   input             clk,
   input             nRst,
   input    [7:0]    address,
   input             in,
   output            out
);

   // Percept module
   reg            shift_in;
   reg            shift_out;
   reg            mul_and_acc;
   reg            data_in;
   wire           data_out;

   percept percept (  
      .clk           (clk        ),
      .nRst          (nRst       ),
      .shift_in      (shift_in   ),
      .shift_out     (shift_out  ),
      .mul_and_acc   (mul_and_acc),
      .data_in       (data_in    ),
      .data_out      (data_out   )
   );  

   // IF
   reg            out;


   parameter      IDLE           = 4'b1111,
                  READ           = 4'b1101,
                  WRITE          = 4'b1100,
                  ADDRESS_0      = 4'b0000,
                  ADDRESS_1      = 4'b0001,
                  ADDRESS_2      = 4'b0010,
                  ADDRESS_3      = 4'b0011,
                  ADDRESS_4      = 4'b0100,
                  ADDRESS_5      = 4'b0101,
                  ADDRESS_6      = 4'b0110,
                  ADDRESS_7      = 4'b0111,
                  READ_WRITE     = 4'b1000;

   reg      [3:0]    state;
   reg      [7:0]    shift;
   reg      [7:0]    count;

   always @(posedge clk or negedge nRst) begin
      if (!nRst) begin
         // percept
         shift_in       <= 0;
         shift_out      <= 0;
         mul_and_acc    <= 0;
         data_in        <= 0;


         // if
         out            <= 0;
         state          <= IDLE;
         shift          <= 0;
         count          <= 0;
       end else begin
         if(count > 0)
            count <= count - 1;
         case(state) 
            IDLE:       begin
                           if(!in & (count == 0)) begin
                              count       <= 73;
                              state       <= ADDRESS_0;
                           end
                        end
            ADDRESS_0,
            ADDRESS_1,
            ADDRESS_2,
            ADDRESS_3,
            ADDRESS_4,
            ADDRESS_5,
            ADDRESS_6,
            ADDRESS_7:  begin
                           shift    <= {shift,in};
                           state    <= state + 1;
                        end

            READ_WRITE: if(shift == address) begin
                           if(in) begin
                              state       <= WRITE;
                              shift_in    <= 1;
                              data_in     <= in;
                           end else begin
                              state       <= READ;
                              shift_out   <= 1;
                              out         <= data_out;
                           end
                        end else begin
                           state <= IDLE;
                        end

            WRITE:      begin
                           data_in  <= in;
                           if(count == 0) begin
                              state       <= IDLE;
                              shift_in    <= 0;
                           end
                        end

            READ:       begin
                           out <= data_out;
                           if(count == 0) begin
                              state       <= IDLE;
                              shift_out   <= 0;
                           end
                        end
            default:    state <= IDLE;
          endcase
       end
   end


endmodule
