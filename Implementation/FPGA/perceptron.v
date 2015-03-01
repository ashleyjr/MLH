module perceptron(
   input          clk,
   input          nRst,
   input          rx,    // Transmit this
   output         tx
);

 
   // UART
   reg            transmit;
   reg   [7:0]    data_tx; 
   wire           busy_tx;
   wire           busy_rx;
   wire           recieved;
   wire  [7:0]    data_rx;    

   uart uart(
      .clk           (clk        ),
      .nRst          (nRst       ),
      .transmit      (transmit   ),
      .data_tx       (data_tx    ),
      .rx            (rx         ),
      .busy_rx       (busy_rx    ),
      .recieved      (recieved   ),
      .data_rx       (data_rx    ),
      .tx            (tx         )
   );




   // Percept modules connected to serial line
   reg            serial;

   percept_if percept_if_1 (  
      .clk           (clk        ),
      .nRst          (nRst       ),
      .serial_in     (serial     ),
      .address       (8'h00      )
   );

   percept_if percept_if_2 (  
      .clk           (clk        ),
      .nRst          (nRst       ),
      .serial_in     (serial     ),
      .address       (8'h01     )
   );    

   percept_if percept_if_3 (  
      .clk           (clk        ),
      .nRst          (nRst       ),
      .serial_in     (serial     ),
      .address       (8'h02      )
   );  

   percept_if percept_if_4 (  
      .clk           (clk        ),
      .nRst          (nRst       ),
      .serial_in     (serial     ),
      .address       (8'h03      )
   );  




   parameter      IDLE_RX     = 4'b1111,
                  SHIFT_0     = 4'b0000,
                  SHIFT_1     = 4'b0001,
                  SHIFT_2     = 4'b0010,
                  SHIFT_3     = 4'b0011,
                  SHIFT_4     = 4'b0100,
                  SHIFT_5     = 4'b0101,
                  SHIFT_6     = 4'b0110,
                  SHIFT_7     = 4'b0111,
                  DONE        = 4'b1000;

   reg   [3:0]    state;
   reg   [3:0]    count;

   // Serial controlled state machine
   always @(posedge clk or negedge nRst) begin
      if (!nRst) begin
         // UART
         transmit    <= 0;
         data_tx     <= 0;

         // Percept
         serial   <= 1;

         // Perceptron
         state       <= IDLE_RX;
         count       <= 0;
      end else begin
         case(state)
            IDLE_RX: if(recieved) begin
                        serial   <= 0;       // begin tx
                        state    <= SHIFT_7;
                     end
            SHIFT_7,
            SHIFT_6,
            SHIFT_5,
            SHIFT_4,
            SHIFT_3,
            SHIFT_2,
            SHIFT_1: begin
                        serial   <= data_rx[state];
                        state    <= state - 1;
                     end
            SHIFT_0: begin
                        serial   <= data_rx[0];
                        state    <= DONE;
                     end
            DONE:    begin
                        state    <= IDLE_RX;
                        serial   <= 1;
                     end
         endcase
      end
   end


endmodule
