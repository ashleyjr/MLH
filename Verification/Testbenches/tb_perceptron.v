
module tb_perceptron;
   parameter CLK_PERIOD = 20;          // 50MHz clock - 20ns period  
   parameter BAUD_PERIOD = 8600;

   reg         clk;
   reg         nRst;
   reg         tx;
   wire        rx;
   

   integer i,j;

   reg   [7:0] data;
   reg sample_rx;
   reg sample_tx;

   perceptron perceptron(
      .clk        (clk        ),
      .nRst       (nRst       ),
      .host_tx    (tx         ),
      .uart_tx    (rx         )
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
      $dumpfile("perceptron.vcd");
      $dumpvars(0,tb_perceptron);
   end

   task uart_send;
      input [7:0] send;
      integer i;
      begin
         tx = 0;
         for(i=0;i<=7;i=i+1) begin   
            sample_tx = !sample_tx;
            #BAUD_PERIOD tx = send[i];
         end
         sample_tx = !sample_tx;
         #BAUD_PERIOD tx = 1;
      end
   endtask

   task uart_get;
      output [7:0] get;
      integer i;
      begin
         sample_rx = !sample_rx;
         for(i=0;i<=7;i=i+1) begin   
            #BAUD_PERIOD  get[i] = rx;
            sample_rx = !sample_rx;
         end
         #BAUD_PERIOD sample_rx = !sample_rx;
      end
   endtask


   initial begin
               sample_tx = 0;
               sample_rx = 0;
      #100     nRst = 1;
               tx = 1;
      #100     nRst = 0;
      #100     nRst = 1;

      repeat(30) begin
         // Load Data 1
         #90000    uart_send(0);
         #90000    uart_send(0);
         #90000    uart_send(1);
         #90000    uart_send(0);
         #90000    uart_send(0);
         #90000    uart_send(0);

         // Load Data 2
         #90000    uart_send(0);
         #90000    uart_send(1);
         #90000    uart_send(1);
         #90000    uart_send(0);
         #90000    uart_send(0);
         #90000    uart_send(0);

         // MUL
         #90000    uart_send(0);
         #90000    uart_send(5);
         

         // MUL ADD
         #90000    uart_send(0);
         #90000    uart_send(6);
   
         // OUT RES
         #90000    uart_send(0);
         #90000    uart_send(2);
     


         #2000000;
	   end
      $finish;
	end





endmodule

