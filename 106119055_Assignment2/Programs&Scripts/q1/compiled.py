import os

#run the tcl file
os.system("ns ns-tcp-wired.tcl")

#build data for the cwnd graph
cmd1 = "awk -f parseCwnd.awk cwnd-tcp-wired.out>graphData" 
cmd2 = "awk -f throughput.awk all.tr"
os.system(cmd1)
os.system(cmd2)
 
print("")
print("To run xgraph and see graph:-")
print("Run in terminal: xgraph graphData")

