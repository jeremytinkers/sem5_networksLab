set ns [new Simulator]

#For OSPF Routing Protocol
$ns rtproto LS 

$ns color 1 Orange
$ns color 2 Green

set nf [open out.nam w]
$ns namtrace-all $nf
set nftr [open log.tr w]
$ns trace-all $nftr


proc finish {} {
        global ns nf nftr
        $ns flush-trace
        close $nf
	exec awk -f pdeliveryr.awk log.tr >plotPdrOspf &
	exec awk -f avgDeliveryDelay.awk log.tr >plotAddOspf   &
        exec awk -f lostPkts.awk log.tr >plotLpOspf  &
        exec awk -f throughput.awk log.tr >plotTOspf   &
	exit 0
}



#Create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]
set n10 [$ns node]
set n11 [$ns node]


#Create links between the nodes
$ns duplex-link $n1 $n2 9Mb 1ms DropTail
$ns queue-limit $n1 $n2 3

$ns duplex-link $n2 $n4 13Mb 1ms DropTail
$ns queue-limit $n2 $n4 4

$ns duplex-link $n2 $n6 7Mb 1ms DropTail
$ns queue-limit $n2 $n6 5

$ns duplex-link $n3 $n6 8Mb 1ms DropTail
$ns queue-limit $n3 $n6 6

$ns duplex-link $n4 $n5 8Mb 3ms DropTail
$ns queue-limit $n4 $n5 7

$ns duplex-link $n5 $n7 10Mb 1ms DropTail
$ns queue-limit $n5 $n7 8

$ns duplex-link $n5 $n6 12Mb 4ms DropTail
$ns queue-limit $n5 $n6 9

#Missing link between n6 and n8 (ma'am asked us to assume conneciton exists and proceed)
$ns duplex-link $n6 $n8 11Mb 1ms DropTail
$ns queue-limit $n6 $n8 8

$ns duplex-link $n7 $n8 8Mb 2ms DropTail
$ns queue-limit $n7 $n8 7

$ns duplex-link $n7 $n11 9Mb 1ms DropTail
$ns queue-limit $n7 $n11 6

$ns duplex-link $n8 $n10 7Mb 3ms DropTail
$ns queue-limit $n8 $n10 5

$ns duplex-link $n10 $n9 9Mb 6ms DropTail
$ns queue-limit $n10 $n9 4

$ns duplex-link $n11 $n10 6Mb 1ms DropTail
$ns queue-limit $n11 $n10 3

#UDP Connection:-
    set udp [new Agent/UDP]
    $udp set fid_ 1
    $ns attach-agent $n1 $udp

    # create a cbr traffic
    set cbr [new Application/Traffic/CBR]
    $cbr set packetSize_ 120
    $cbr set interval_ 0.005
    $cbr attach-agent $udp
    
    # create null agent
    set null [new Agent/Null]
    $ns attach-agent $n10 $null
    
    $ns connect $udp $null


#Setup a TCP connection
set tcp [new Agent/TCP]
$tcp set fid_ 2
set sink [new Agent/TCPSink]


#$tcp set class_ 2
$ns attach-agent $n2 $tcp
$ns attach-agent $n9 $sink


$ns connect $tcp $sink


#Setup a FTP over TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns rtmodel-at 8 down $n8 $n6
$ns rtmodel-at 12 down $n7 $n11


$ns rtmodel-at 16 up $n8 $n6
$ns rtmodel-at 24 up $n7 $n11

#Start the 2 transfers
$ns at 2.0 "$cbr start"
$ns at 30.0 "$ftp start"

#End simulation at 200s
$ns at 50.0 "finish"


$ns run
