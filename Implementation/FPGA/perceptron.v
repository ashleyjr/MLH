module perceptron(
   input             clk,
   input             nRst,
   input             host_tx,
   output            uart_tx,
   output reg  [7:0] leds
);

   
   // ACC
   wire  [7:0] acc_data;

   // CTRL
   wire        ctrl_acc;
   wire  [3:0] ctrl_sel;
   wire  [7:0] ctrl_data;
   wire        ctrl_good;
   wire        ctrl_tx;

   // MUX
   wire  [7:0] mux_data;

   //UART
   wire  [7:0] uart_data;
   wire        uart_good;

   
   
   
   always@(posedge clk) begin
      leds <= uart_data;
   end


   uart uart(
      .clk        (clk        ),
      .nRst       (nRst       ),
      .transmit   (ctrl_good  ),
      .data_tx    (mux_data   ),
      .rx         (host_tx    ),
      .busy_tx    (           ),
      .busy_rx    (           ),
      .recieved   (uart_good  ),
      .data_rx    (uart_data  ),
      .tx         (uart_tx    )
   );


   ctrl ctrl(
      .clk        (clk        ),
      .nRst       (nRst       ),
      .data_in    (uart_data  ),
      .in         (uart_good  ),
      .rx         (),
      .data_out   (),
      .out        (),
      .tx         (ctrl_tx    )
   );

   //bank bank(
   //   .clk        (clk),
   //   .nRst       (nRst),
   //   .rx         (),
   //   .tx         ()
   //);
   
endmodule
