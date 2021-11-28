import os

#run the tcl file
os.system("ns code.tcl")

#build data for the 3 tcp connections & display STDV & Average
for x in range(3):
 print("For X : {} ".format(x+3))
 cmd1 = "awk -f interarrival.awk -v dest={} log.tr>graphData{}".format(x+3, x+3) 
 cmd2 = "awk -f avg_stdv.awk -v dest={} log.tr".format(x+3) 
 os.system(cmd1)
 os.system(cmd2)
 
print("")
print("To run xgraph and see graphs:-")
print("Run in terminal: xgraph -color 3 graphData3 -color 12 graphData4 -color 2 graphData5")


