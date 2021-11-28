import os

for x in range(10):
 print("For X : {} ".format(x))
 cmd1 = "ns code.tcl " + str(x+1)
 cmd2 = "python3 tracer.py>>tableData"
 os.system(cmd1)
 os.system(cmd2)
