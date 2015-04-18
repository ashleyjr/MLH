#!/usr/bin/python
import os
import platform
import subprocess
from optparse import OptionParser




if "__main__" == __name__:

    modules = ['acc','uart']

    print
    print "--- Running all simulations! ---"

    for module in modules:
        os.system("python runsim.py -s -m " + module)
