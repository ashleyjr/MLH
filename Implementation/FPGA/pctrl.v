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
                  OUT_RES_ADD    = 3'h3,
                  LOAD_RES       = 3'h4,
                  MUL            = 3'h5,
                  MUL_ADD        = 3'h6,
                  NO_OP          = 3'h7;


   // Sates
   parameter      IDLE           = 3'h0,
                  FETCH          = 3'h1,
                  DECODE         = 3'h2,
                  EXECUTE        = 3'h3,
                  WAIT           = 3'h4;
      
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
         if(count != 0) count <= count - 1;
         case(state) 
            IDLE:       if(!rx) begin
                           count       <= 8;
                           state       <= FETCH;
                        end
            FETCH:      begin
                           shifter     <= {rx,shifter[7:1]}; 
                           if(count == 0)
                              if(shifter == address) begin
                                 count <= 7'd6;
                                 state <= DECODE;
                              end else begin 
                                 count <= 7'd50;
                                 state <= WAIT;
                              end
                        end
            DECODE:     begin
                           shifter     <= {rx,shifter[7:1]}; 
                           if(count == 0) begin
                              opcode   <= shifter[3:1];     // use what's in for op
                              state    <= EXECUTE;
                              case(shifter[3:1])
                                 OUT_RES,
                                 OUT_RES_ADD:   count    <= 7'd127;
                                 default:       count    <= 7'd31;
                              endcase
                           end
                        end


            EXECUTE:    begin
                           if(opcode == MUL)       opcode <= NO_OP;
                           if(opcode == MUL_ADD)   opcode <= NO_OP;
                           if(count == 0) begin 
                              state <= IDLE;
                              opcode <= NO_OP;
                           end
                        end
            WAIT:       begin
                           count <= count - 1;
                           if(count == 1) begin
                              state <= IDLE;
                              shifter <= 0;
                           end 
                        end
            default:    state <= IDLE;
          endcase
       end
   end


endmodule
