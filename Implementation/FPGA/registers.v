module registers(
   input          clk,
   input          nRst,
   input    [7:0] data_in,    // Transmit this
   input          read,
   input          write,
   output   [7:0] data_out
);

   // Outputs
   reg [7:0]   data_out ;  
   

   // Params
   parameter   ADDRESS  = 4'b0000, 
               DATA     = 4'b0001;

   // Internal Regs
   reg [3:0]   state;
 

     
   // Serial clock generation - 115200 baud = 50MHz/434
   always @(posedge clk or negedge nRst) begin
      if(!nRst) begin
         state <= ADDRESS;
      end else begin
         case(state)
            ADDRESS:    
            DATA:       
            default:    state       <= ADDRRESS;
         endcase
      end
   end
endmodule