module perceptron(
   input          clk,
   input          nRst,
   input          rx,    // Transmit this
   output         tx
);

   wire           recieved;
   wire  [7:0]    data_rx;
   wire  [15:0]   out;

   wire  [7:0]    mux1  [255:0];
       
   uart uart(
      .clk        (clk        ),
      .nRst       (nRst       ),
      .transmit   (     ),
      .data_tx    ( ),
      .rx         (rx    ),
      .busy_rx    ( ),
      .recieved   (recieved),
      .data_rx    (data_rx),
      .tx         (tx      )
   );
 

   genvar i;  
   generate  
      for (i=0; i<256; i=i+1)  begin: percepts  
         percept percept (  
            .clk     (clk        ),
            .nRst    (nRst       ),
            .write   (recieved   ),
            .in      (data_rx    ),
            .weight  (data_rx    ),
            .out     (out        )
         );  
      end  
   endgenerate 
endmodule
