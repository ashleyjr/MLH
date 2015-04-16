module perceptron(
   input             clk,
   input             nRst,
   input             host_tx,
   output            uart_tx,
   output reg  [7:0] leds
);

   always@(posedge clk) begin
      leds <= data;
   end
   //wire  [7:0] acc_data;

   //wire        ctrl_acc;
   //wire  [3:0] ctrl_sel;
   //wire  [7:0] ctrl_data;
   //wire        ctrl_good;
   //wire        ctrl_tx;

   //wire  [7:0] uart_data;
   //wire        uart_good;

   wire     [7:0] data;

   wire bounce;
   uart uart(
      .clk        (clk        ),
      .nRst       (nRst       ),
      .transmit   (bounce  ),
      .data_tx    (8'hAA  ),
      .rx         (host_tx    ),
      .busy_tx    (           ),
      .busy_rx    (           ),
      .recieved   (bounce),
      .data_rx    (data),
      .tx         (uart_tx    )
   );

   //ctrl ctrl(
   //   .clk        (clk        ),
   //   .nRst       (nRst       ),
   //   .data_in    (uart_data  ),
   //   .in         (uart_good  ),
   //   .rx         (),
   //   .data_out   (),
   //   .out        (),
   //   .tx         ()
   //);

   //bank bank(
   //   .clk        (clk),
   //   .nRst       (nRst),
   //   .rx         (),
   //   .tx         ()
   //);
   
endmodule
