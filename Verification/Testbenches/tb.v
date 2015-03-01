
module tb;
   parameter CLK_PERIOD = 20;          // 50MHz clock - 20ns period  
   parameter BAUD_PERIOD = 8700;

   reg         clk;
   reg         nRst;
   reg         tx;
   wire        rx;

   integer i,j;

   perceptron perceptron(
      .clk        (clk        ),
      .nRst       (nRst       ),
      .rx         (tx         ),
      .tx         (rx         )
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
      $dumpfile("tb.vcd");
      $dumpvars(0,tb);
   end

   task uart_send;
      input [7:0] send;
      integer i;
      begin
         tx = 0;
         for(i=0;i<=7;i=i+1) begin   
            #BAUD_PERIOD tx = send[i];
         end
         #BAUD_PERIOD tx = 1;
      end
   endtask

   task uart_get;
      output [7:0] get;
      integer i;
      begin
         for(i=0;i<=7;i=i+1) begin   
            #BAUD_PERIOD  get[i] = rx;
         end
      end
   endtask
	
   initial begin
      #100     nRst = 1;
               tx = 1;
      #100     nRst = 0;
      #100     nRst = 1;


      #100000     uart_send(8'hAA);
      #100000     uart_send(8'hAA);
      #100000     uart_send(8'hAA);
      #100000     uart_send(8'hAA);
      #100000     uart_send(8'hAA);
      #100000     uart_send(8'hAD);
      #100000     uart_send(8'h01);
      #100000     uart_send(8'h00);
      #100000     uart_send(8'hAA);

      #300000
	   $finish;
	end





endmodule

