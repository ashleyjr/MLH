module percept_data(
   input             clk,
   input             nRst,
   input             rx,
   input    [2:0]    opcode,
   output            tx
);

   // Default 32 bits wide
   parameter               SIZE        = 32;

   // Opcodes
   parameter               OUT_DATA1   = 3'h0;
   parameter               OUT_DATA2   = 3'h1;
   parameter               OUT_RES     = 3'h2;
   parameter               LOAD        = 3'h3;
   parameter               LOAD_RES    = 3'h4;
   parameter               MUL         = 3'h5;
   parameter               MUL_ADD     = 3'h6;
   parameter               NO_OP       = 3'h7;

   // Weight and data regs
   reg   [SIZE-1:0]        data_1;
   reg   [SIZE-1:0]        data_2;
   
   // Accumualtor is 4 times the size
   reg   [(4*SIZE)-1:0]    acc;
  
   // 4 possible output states on the mux
   always@(opcode) begin
      case(opcode)
         OUT_DATA1:  tx = data_1[SIZE-1];
         OUT_DATA2:  tx = data_2[SIZE-1];
         OUT_RES:    tx = acc[(4*SIZE)-1];
         LOAD,
         LOAD_RES,
         MUL,
         MUL_ADD,
         NO_OP:      tx = 1'bz;
      endcase
   end

   // Shifting and maths 
   always @(posedge clk or negedge nRst) begin
      if (!nRst) begin
         data_1         <= 0;
         data_2         <= 0;  
         accumulator    <= 0;
      end else begin
         case(opcode)
            OUT_DATA1:  data_1      <= {data_1,rx};
            OUT_DATA2:  data_2      <= {data_2,rx};
            OUT_RES:    acc         <=  
            LOAD:       begin
                           data_1   <= {data_1,rx};
                           data_2   <= {data_2,data_1[SIZE-1]};
                        end
            LOAD_RES:   acc         <= {acc,rx};
            MUL:        acc         <= data_1*data_2;
            MUL_ADD:    acc         <= acc + (data_1*data_2);
         endcase
      end
   end


endmodule
