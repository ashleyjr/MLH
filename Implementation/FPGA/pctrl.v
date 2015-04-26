module pctrl(
   input             clk,
   input             nRst,
   input       [7:0] address,
   input             rx,
   output reg  [2:0] opcode
);
   
   // Opcodes
   parameter      OUT_DATA1      = 3'h0,
                  OUT_DATA2      = 3'h1,
                  OUT_RES        = 3'h2,
                  LOAD           = 3'h3,
                  LOAD_RES       = 3'h4,
                  MUL            = 3'h5,
                  MUL_ADD        = 3'h6,
                  NO_OP          = 3'h7;


   // Sates
   parameter      IDLE           = 2'h0,
                  FETCH          = 2'h1,
                  DECODE         = 2'h2,
                  EXECUTE        = 2'h3;
      
   reg      [3:0]    state;
   reg      [7:0]    shifter;
   reg      [6:0]    count;

   always @(posedge clk or negedge nRst) begin
      if (!nRst) begin
         opcode   <= NO_OP; 
         state    <= IDLE;
         shifter  <= 0;
         count    <= 0;
       end else begin
         if(count > 0)
            count <= count - 1;
         case(state) 
            IDLE:       if(!rx) begin
                           count       <= 7;
                           state       <= FETCH;
                        end
            FETCH:      begin
                           shifter     <= {rx,shifter[7:1]}; 
                           if(count == 0)
                              if(shifter == address) begin
                                 count <= 6;
                                 state <= DECODE;
                              end else begin 
                                 state <= IDLE;
                              end
                        end
            DECODE:     begin
                           shifter     <= {rx,shifter[7:1]}; 
                           if(count == 0) begin
                              opcode   <= shifter[3:1];     // use what's in for op
                              state    <= EXECUTE;
                              count    <= 31;
                           end
                        end


            EXECUTE:    if(count == 0) begin 
                           state <= IDLE;
                           opcode <= NO_OP;
                        end
            default:    state <= IDLE;
          endcase
       end
   end


endmodule
