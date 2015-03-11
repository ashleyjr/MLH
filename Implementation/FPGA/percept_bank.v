module percept_bank(
   input             clk,
   input             nRst,
   input             rx,
   output            tx
);

   /// BROKEN!!!!!
   // USE GENVAR!!
   
   genvar [7:0] i;
   generate
      for (i=0; i <= 255; i=i+1)  begin: bank
         percept percept_inst (  
            .clk           (clk        ),
            .nRst          (nRst       ),
            .address       (i          ),
            .rx            (rx         ),
            .tx            (tx         )
         );  
      end  
   endgenerate
endmodule
