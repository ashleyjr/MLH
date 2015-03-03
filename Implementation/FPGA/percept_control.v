module percept_control(
   input             clk,
   input             nRst,
   input    [7:0]    address,
   input             in,
   output            shift,
   output            shift_res,
   output            mul,
   output            acc
);

   // Percept module
   reg            shift;
   reg            shift_res;
   reg            mul;
   reg            acc;

   parameter      IDLE           = 4'hF,
                  ADDRESS_0      = 4'h0,
                  ADDRESS_1      = 4'h1,
                  ADDRESS_2      = 4'h2,
                  ADDRESS_3      = 4'h3,
                  ADDRESS_4      = 4'h4,
                  ADDRESS_5      = 4'h5,
                  ADDRESS_6      = 4'h6,
                  ADDRESS_7      = 4'h7,
                  OP             = 4'h8;

   reg      [3:0]    state;
   reg      [7:0]    shifter;
   reg      [7:0]    count;

   always @(posedge clk or negedge nRst) begin
      if (!nRst) begin
         // percept
         shift       <= 0;
         shift_res   <= 0;
         mul         <= 0;
         acc         <= 0;


         // if
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
                           shifter     <= {shifter,in};
                           state       <= state + 1;
                        end
            OP:         if((shifter == address) & (count > 0))begin
                           shift <= 1;
                           state <= OP;
                        end else begin
                           shift <= 0;
                           state <= IDLE;
                        end 
            default:    state <= IDLE;
          endcase
       end
   end


endmodule
