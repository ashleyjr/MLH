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

   parameter   ADDRESS  = 2'b00, 
               WRITE    = 2'b01,
               READ     = 2'b10;


   // Internal Regs
   reg [1:0]   state;
   reg [3:0]   address;
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
                           if(data_in < REGS) begin
                              if(read & !write) begin
                                 state    <= READ;
                                 data_out <= regs[data_in];
                                 valid    <= 1;
                              end   
                              if(write & !read) begin
                                 state    <= WRITE;
                                 address  <= data_in;
                                 valid    <= 1;
                              end
                           end           
                        end
            READ:       begin
                           if(!read) begin  
                              state       <= ADDRESS;
                              valid       <= 0;
                           end
                        end
            WRITE:      begin
                           valid <= 1;
                           if(!write) begin 
                              regs[address]  <= data_in;
                              state          <= ADDRESS;
                              valid          <= 0;
                           end
                        end
            default:    state       <= ADDRESS;
         endcase
      end
   end
endmodule