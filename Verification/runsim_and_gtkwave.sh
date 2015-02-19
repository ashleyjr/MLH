iverilog -o design.dat -c filelist.txt
vvp design.dat -vcd
gtkwave tb.vcd


