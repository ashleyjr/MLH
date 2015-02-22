module registers(
   input          clk,
   input          nRst,
   input    [7:0] data_in,    // Transmit this
   input          read,
   input          write,
   output   [7:0] data_out,
   output         valid
);

   // Outputs
   reg [7:0]   data_out ;  
   reg         valid;

   // Params
   parameter   REGS     = 4'hF;

   parameter   ADDRESS  = 4'b0000, 
               WRITE    = 4'b0001,
               READ     = 4'b0010;


   // Internal Regs
   reg [3:0]   state;
   reg [7:0]   address;
   reg [7:0]   regs [REGS:0];


     
   // Serial clock generation - 115200 baud = 50MHz/434
   always @(posedge clk or negedge nRst) begin
      if(!nRst) begin
         state <= ADDRESS;
         data_out <= 0;
         valid <= 0;
      end else begin
         case(state)
            ADDRESS:    begin
                           valid <= 0;
                           if(data_in < REGS) address <= data_in;
                            
                           
                                 if(read & !write)    
                                    state <= READ;
                                 if(write & !read)
                                    state <= WRITE;
                           
                        end
            READ:       begin
                           data_out <= regs[address];
                           valid    <= 1;
                           if(!read)   
                              state <= ADDRESS;
                        end
            WRITE:      begin
                           valid <= 1;
                           regs[address]  <= data_in;
                           if(!write) 
                              state <= ADDRESS;
                        end
            default:    state       <= ADDRESS;
         endcase
      end
   end
endmodule