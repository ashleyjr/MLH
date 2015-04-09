`timescale 1ns/1ps


module tb;

   reg   [127:0]  in; 
   reg   [3:0]    sel;
   wire  [7:0]    out;



   mux mux(
      .in         (in         ),
      .sel        (sel        ),
      .out        (out        )
   );

   initial begin
      $dumpfile("mux.vcd");
      $dumpvars(0,tb);
   end


   initial begin
               in = 128'h00112233445566778899AABBCCDDEEFF;

      #100     sel = 4'h0;
      #100     sel = 4'h1;
      #100     sel = 4'h2;
      #100     sel = 4'h3;
      #100     sel = 4'h4;
      #100     sel = 4'h5;
      #100     sel = 4'h6;
      #100     sel = 4'h7;
      #100     sel = 4'h8;
      #100     sel = 4'h9;
      #100     sel = 4'hA;
      #100     sel = 4'hB;
      #100     sel = 4'hC;
      #100     sel = 4'hD;
      #100     sel = 4'hE;
      #100     sel = 4'hF;



      #10000
      $finish;
   end




endmodule

