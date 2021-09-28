#Create a simulator object
set ns [new Simulator]

puts "Welcome onboard! Jeremiah Thomas | Network Lab3 | Q1 "

#Trace File to log simulation info
set tracefile [open q1log.tr w]
$ns trace-all $tracefile


#NAM FIle creation, for animation 
set nf [open q1disp.nam w]
$ns namtrace-all $nf

#Define a 'finish' procedure
proc finish {} {
    global ns nf
    $ns flush-trace
    #Close the NAM trace file
    close $nf
    exit 0
}

#Create six nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

#Create links between the nodes
$ns duplex-link $n0 $n2 10Mb 1ms DropTail
$ns duplex-link $n1 $n2 10Mb 1ms DropTail
$ns duplex-link $n2 $n3 1Mb 3ms DropTail
$ns duplex-link $n3 $n4 10Mb 1ms DropTail
$ns duplex-link $n3 $n5 10Mb 1ms DropTail


#Setup a TCP connection
set tcp1 [new Agent/TCP]
set sink1 [new Agent/TCPSink]
set tcp2 [new Agent/TCP]
set sink2 [new Agent/TCPSink]

#$tcp set class_ 2
$ns attach-agent $n0 $tcp1
$ns attach-agent $n4 $sink1
$ns attach-agent $n1 $tcp2
$ns attach-agent $n5 $sink2
$ns connect $tcp1 $sink1
$ns connect $tcp2 $sink2


#Setup a FTP over TCP connection
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2

#Start the 2 transfers
$ns at 0.0 "$ftp1 start"
$ns at 0.0 "$ftp2 start"

#End simulation at 200s
$ns at 200.0 "finish"

puts "Running SImulation now...... XGraph should pop up soon."
#Run the simulation
$ns run
view raw

