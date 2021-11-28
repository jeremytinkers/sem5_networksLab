#Create a simulator object
set ns [new Simulator]

$ns color 1 Orange
$ns color 2 Red
$ns color 3 Blue


puts "Welcome onboard! Jeremiah Thomas | Assignment II | Q2 "

#Trace File to log simulation info
set tracefile [open log.tr w]
$ns trace-all $tracefile

#NAM FIle creation, for animation 
set nf [open disp.nam w]
$ns namtrace-all $nf

#Define a 'finish' procedure
proc finish {} {
    global ns nf
    $ns flush-trace
    #Close the NAM trace file
    close $nf
    exit 0
}

#Create six nodes -> a & b:-
set a0 [$ns node]
set a1 [$ns node]
set a2 [$ns node]

set b0 [$ns node]
set b1 [$ns node]
set b2 [$ns node]

#router nodes
set X [$ns node]
set Y [$ns node]

#Create links between the nodes
$ns duplex-link $a0 $X 10Mb 1ms DropTail
$ns duplex-link $a1 $X 10Mb 1ms DropTail
$ns duplex-link $a2 $X 1Mb 3ms DropTail

$ns duplex-link $b0 $Y 10Mb 1ms DropTail
$ns duplex-link $b1 $Y 10Mb 1ms DropTail
$ns duplex-link $b2 $Y 10Mb 1ms DropTail

$ns duplex-link $X $Y 10Mb 1ms DropTail

#Setup three TCP connection
set tcp1 [new Agent/TCP]
$tcp1 set fid_ 1
set sink1 [new Agent/TCPSink]

set tcp2 [new Agent/TCP]
$tcp2 set fid_ 2
set sink2 [new Agent/TCPSink]

set tcp3 [new Agent/TCP]
$tcp3 set fid_ 3
set sink3 [new Agent/TCPSink]

#attach agents
$ns attach-agent $a0 $tcp1
$ns attach-agent $a1 $tcp2
$ns attach-agent $a2 $tcp3

$ns attach-agent $b0 $sink1
$ns attach-agent $b1 $sink2
$ns attach-agent $b2 $sink3

$ns connect $tcp1 $sink1
$ns connect $tcp2 $sink2
$ns connect $tcp3 $sink3

#Setup a FTP over TCP connection
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2

set ftp3 [new Application/FTP]
$ftp3 attach-agent $tcp3


#Start the 3 transfers
$ns at 0.0 "$ftp1 start"
$ns at 0.0 "$ftp2 start"
$ns at 0.0 "$ftp3 start"

#End simulation at 50s
$ns at 50.0 "finish"


#Run the simulation
$ns run
view raw

