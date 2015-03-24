module perceptron(
   input             clk,
   input             nRst,
   input             host_tx,
   output            uart_tx
);

   wire  [7:0] acc_data;

   wire        ctrl_acc;
   wire  [3:0] ctrl_sel;
   wire  [7:0] ctrl_data;
   wire        ctrl_good;
   wire        ctrl_tx;

   wire  [7:0] uart_data;
   wire        uart_good;


   uart uart(
      .clk        (clk        ),
      .nRst       (nRst       ),
      .transmit   (ctrl_good  ),
      .data_tx    (ctrl_data  ),
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
      .tx         ()
   );

   bank bank(
      .clk        (clk),
      .nRst       (nRst),
      .rx         (),
      .tx         ()
   );
   
endmodule
