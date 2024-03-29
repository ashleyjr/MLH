module mojo_top(
    // 50MHz clock input
    input clk,
    // Input from reset button (active low)
    input rst_n,
    // Outputs to the 8 onboard LEDs
    output[7:0]led,
    // UART
    output tx,
    input rx
);

wire rst = ~rst_n; // make reset active high


///////////////////////////////////////////////////
// Points to top module of perceptron code
perceptron perceptron(
   .clk     (clk),
   .nRst    (rst_n),
   .host_tx (rx),
   .uart_tx (tx),
   .leds    (led)
);
///////////////////////////////////////////////////



endmodule
