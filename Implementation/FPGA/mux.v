module mux(
   input       [127:0]  in,
   input       [3:0]    sel,
   output  [7:0]    out
);
   
   // Big mux

   assign out = 
      (sel == 0)  ?   in[7:0]       :
      (sel == 1)  ?   in[15:8]      :
      (sel == 2)  ?   in[23:16]     :
      (sel == 3)  ?   in[31:24]     :
      (sel == 4)  ?   in[39:32]     :
      (sel == 5)  ?   in[47:40]     :
      (sel == 6)  ?   in[55:48]     :
      (sel == 7)  ?   in[63:56]     :
      (sel == 8)  ?   in[71:64]     :
      (sel == 9)  ?   in[79:72]     :
      (sel == 10) ?   in[87:80]     :
      (sel == 11) ?   in[95:88]     :
      (sel == 12) ?   in[103:96]    :
      (sel == 13) ?   in[111:104]   :
      (sel == 14) ?   in[119:112]   :
                      in[127:120]   ;

endmodule
