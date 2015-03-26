#!/usr/bin/python
import os
import platform
import subprocess
from optparse import OptionParser




if "__main__" == __name__:
    print
    print "--- MLH runsim ---"

    parser = OptionParser(usage="runsim.py [-m module] [-w view waves]" )
    parser.add_option("-m", "--module", dest="module", help="module to simulate - should not be defined if program is")
    parser.add_option("-w", "--waves", action="store_true", dest="waves")
    (options, args) = parser.parse_args()

    print "INFO: Simulate " + options.module


    if(platform.system() == 'Linux'):
        print "INFO: Linux OS detected"
        folder = "Testbenches"
        sim = "tb_" + options.module + "_filelist.txt"


        cmd = "iverilog -o " + options.module + ".dat -c " + os.path.join(folder,sim)
        print " CMD: " + cmd
        os.system(cmd)


        cmd = "vvp " + options.module + ".dat -vcd"
        print " CMD: " + cmd
        os.system(cmd)


        if(options.waves):
            cmd = "gtkwave " + options.module +".vcd"
            print " CMD: " + cmd
            os.system(cmd)




    elif(platform.system() == 'Windows'):
        print "INFO: Windows OS detected"

    print
