module percept_if(
   input             clk,
   input             nRst,
   input             serial_in,
   input    [7:0]    address
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

   parameter      IDLE_RX        = 4'b1111,
                  AD_SHIFT_0     = 4'b0000,
                  AD_SHIFT_1     = 4'b0001,
                  AD_SHIFT_2     = 4'b0010,
                  AD_SHIFT_3     = 4'b0011,
                  AD_SHIFT_4     = 4'b0100,
                  AD_SHIFT_5     = 4'b0101,
                  AD_SHIFT_6     = 4'b0110,
                  AD_SHIFT_7     = 4'b0111,
                  AD_SHIFT_8     = 4'b1000,
                  FOUND          = 4'b1001;

   reg      [3:0]    state;
   reg      [7:0]    shift;

   always @(posedge clk or negedge nRst) begin
      if (!nRst) begin
         // percept
         shift_in       <= 0;
         shift_out      <= 0;
         mul_and_acc    <= 0;
         data_in        <= 0;


         // if
         state          <= IDLE_RX;
         shift          <= 0;
       end else begin
          case(state) 
            IDLE_RX:       if(!serial_in)
                              state <= AD_SHIFT_0;
            AD_SHIFT_0,
            AD_SHIFT_1,
            AD_SHIFT_2,
            AD_SHIFT_3,
            AD_SHIFT_4,
            AD_SHIFT_5,
            AD_SHIFT_6,
            AD_SHIFT_7:    begin
                              shift <= {shift,serial_in};
                              if(shift == address) 
                                 state <= FOUND;
                           end
            AD_SHIFT_8:    state <= IDLE_RX;
            FOUND:         begin
                              state <= IDLE_RX;
                           end
          endcase
       end
   end


endmodule
