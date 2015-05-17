`timescale 1ns/1ps

module serial(
   input                   clk,
   input                   nRst,
   input       [7:0]       data,
   input                   send,
   input                   get,
   output reg              tx
);

   reg   [47:0]      load;
   reg   [8:0]       count;
   reg               state;

   parameter   LOAD     = 1'h0,
               SEND     = 1'h1;


   always @(posedge clk or negedge nRst) begin
      if(!nRst) begin
         load     <= 0;
         count    <= 0;
         tx       <= 1;
         state    <= LOAD;

      end else begin
         case(state)
            LOAD: begin
                     if(get) begin
                        count <= count + 8;
                        case(count)
                           0:    load[7:0]         <= data;
                           8:    load[15:8]        <= data;
                           16:   load[23:16]       <= data;
                           24:   load[31:24]       <= data;
                           32:   load[39:32]       <= data;
                           40:   load[47:40]       <= data;
                        endcase
                     end
                     if(send) begin
                        tx <= 0;
                        state <= SEND;
                     end
                  end
            SEND: begin
                     if(count == 0) begin
                        state <= LOAD;
                        tx    <= 1;
                     end else begin
                        count <= count - 1;
                        tx    <= load[0];
                        load  <= load >> 1;
                     end
                  end
         endcase
      end
   end
endmodule
