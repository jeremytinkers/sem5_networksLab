# ns-tcp-wired.tcl
# Author: Jeff Pang <jeffpang+744@cs.cmu.edu>
#
# 15-744 ps2

# whether to create the nam log for visualization {yes,no}

set namlog      "yes"
# when to start the sender
set starttime    1.0
# when to stop the simulation
set stoptime     10.0
# where to log the sender's cwnd trace
set logfilename  "cwnd-tcp-wired.out"

puts "Running Tcl File"

set ns [new Simulator]
set cwndf [open $logfilename w]

if {$namlog == "yes"} {
    set namf [open tcp-wired.nam w]
    $ns namtrace-all $namf
}

set nftr [open all.tr w]
$ns trace-all $nftr

proc finish {} {
    global ns namlog cwndf namf
    $ns flush-trace
    close $cwndf
    if {$namlog == "yes"} {
	close $namf
    }
    exit 0
}

# source node
set src [$ns node]
# desination node
set dst [$ns node]
# routers
set r1 [$ns node]
set r2 [$ns node]

# bottleneck link
$ns duplex-link $r1 $r2 1Mb 16ms DropTail
# router queue
$ns queue-limit $r1 $r2 5
# access links
$ns duplex-link $src $r1 11Mb 2ms DropTail
$ns duplex-link $dst $r2 11Mb 2ms DropTail

# attach tcp agents
set tcpSender [new Agent/TCP/Reno]
# configure tcp agent
$ns attach-agent $src $tcpSender
set tcpReceiver [new Agent/TCPSink]
$ns attach-agent $dst $tcpReceiver

# have the sender run an ftp app
set ftp [new Application/FTP]
$ftp attach-agent $tcpSender

# trace the sender's cwnd
$tcpSender attach $cwndf
$tcpSender tracevar cwnd_

$ns connect $tcpSender $tcpReceiver

$ns at $starttime "$ftp start"
$ns at $stoptime "$ftp stop"

$ns at $stoptime "finish"

# do the simulation
$ns run
