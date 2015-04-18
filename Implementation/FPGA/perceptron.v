module perceptron(
   input             clk,
   input             nRst,
   input             host_tx,
   output            uart_tx,
   output      [7:0] leds
);

   
   // ACC
   wire  [127:0] acc_data;

   // CTRL
   wire        ctrl_acc;
   wire        ctrl_clear;
   wire  [3:0] ctrl_sel;
   wire  [7:0] ctrl_data;
   wire        ctrl_good;
   wire        ctrl_tx;

   // MUX
   wire  [7:0] mux_data;

   //UART
   wire  [7:0] uart_data;
   wire        uart_good;
   wire        uart_tx_busy;

   
   
   
   uart uart(
      .clk        (clk        ),
      .nRst       (nRst       ),
      .transmit   (ctrl_good  ),
      .data_tx    (mux_data   ),
      .rx         (host_tx    ),
      .busy_tx    (uart_tx_busy),
      .busy_rx    (      ),
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
      .status     (leds       ),
      .busy       (uart_tx_busy),
      .data_out   (),
      .out        (ctrl_good),
      .tx         (ctrl_tx    ),
      .acc        (ctrl_acc   ),
      .clear      (ctrl_clear ),
      .sel        (ctrl_sel)
   );

   acc acc(
      .clk        (clk),
      .nRst       (nRst),
      .rx         (ctrl_tx),
      .add        (ctrl_acc),
      .clear      (ctrl_clear),
      .big        (acc_data)
   );

   mux mux(
      .in         (acc_data),
      .sel        (ctrl_sel),
      .out        (mux_data)
   );
endmodule
