module perceptron(
   input             clk,
   input             nRst,
   input             host_tx,
   output            uart_tx,
   output      [7:0] leds
);

   
   // ACC
   wire  [127:0] acc_data;

   // BANK
   wire           bank_tx;

   // CTRL
   wire           ctrl_acc;
   wire           ctrl_clear;
   wire  [3:0]    ctrl_sel;
   wire  [7:0]    ctrl_data;
   wire           ctrl_good;
   wire           ctrl_get;
   wire           ctrl_send;

   // MUX
   wire  [7:0]    mux_data;

   //UART
   wire  [7:0]    uart_data;
   wire           uart_good;
   wire           uart_tx_busy;



   reg clk_div;
   always @(posedge clk or negedge nRst) begin
      if(!nRst) begin
         clk_div <= 0;
      end else begin
         clk_div <= ~clk_div;
      end
   end
   
   uart uart(
      .clk        (clk_div       ),
      .nRst       (nRst          ),
      .transmit   (ctrl_good     ),
      .data_tx    (mux_data      ),
      .rx         (host_tx       ),
      .busy_tx    (uart_tx_busy  ),
      .busy_rx    (              ),
      .recieved   (uart_good     ),
      .data_rx    (uart_data     ),
      .tx         (uart_tx       )
   );


   ctrl ctrl(
      .clk        (clk_div       ),
      .nRst       (nRst          ),
      .data_in    (uart_data     ),
      .in         (uart_good     ),
      .status     (leds          ),
      .busy       (uart_tx_busy  ),
      .out        (ctrl_good     ),
      .acc        (ctrl_acc      ),
      .clear      (ctrl_clear    ),
      .sel        (ctrl_sel      ),
      .get        (ctrl_get      ),
      .send       (ctrl_send     )
   );

   bank bank(
      .clk        (clk_div       ),
      .nRst       (nRst          ),
      .rx         (serial_tx     ),
      .tx         (bank_tx       )
   );

   acc acc(
      .clk        (clk_div       ),
      .nRst       (nRst          ),
      .rx         (bank_tx       ),
      .add        (ctrl_acc      ),
      .clear      (ctrl_clear    ),
      .big        (acc_data      )
   );

   mux mux(
      .in         (acc_data      ),
      .sel        (ctrl_sel      ),
      .out        (mux_data      )
   );

   serial serial(
      .clk        (clk_div       ),
      .nRst       (nRst          ),
      .data       (uart_data     ),
      .send       (ctrl_send     ),
      .get        (ctrl_get      ),
      .tx         (serial_tx     )
   );
endmodule
