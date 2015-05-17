module bank(
   input             clk,
   input             nRst,
   input             rx,
   output            tx
);

   wire   [7:0] address [255:0];

   genvar i;
   
   generate
      for (i=0; i <= 3; i=i+1)  begin: bank
         percept percept_inst (  
            .clk           (clk        ),
            .nRst          (nRst       ),
            .address       (address[i] ),
            .rx            (rx         ),
            .tx            (tx         )
         );  
      end  
   endgenerate

   // Create an address for each percept   
   assign address[0] = 0;
   assign address[1] = 1;
   assign address[2] = 2;
   assign address[3] = 4;

endmodule

