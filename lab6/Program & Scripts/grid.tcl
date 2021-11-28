set ns [new Simulator]

#LS -> For OSPF Routing Protocol
#$ns rtproto LS 

#DV -> For RIP Routing Protocol
$ns rtproto DV

$ns color 1 Orange

set nf [open out.nam w]
$ns namtrace-all $nf
set nftr [open all.tr w]
$ns trace-all $nftr


set rows [lindex $argv 0]
set cols [lindex $argv 1]
set src [lindex $argv 2]
set dest [lindex $argv 3]

proc finish {} {
        global ns nf nftr src dest
        $ns flush-trace
        close $nf
	exec awk -f pdr.awk -v src=$src -v dest=$dest all.tr &
	exec awk -f plr.awk -v src=$src -v dest=$dest all.tr  &
        exec awk -f overhead.awk all.tr &
        exec awk -f energyC.awk -v dest=$dest all.tr  &
	exit 0
}

for {set i 0} {$i < ($rows * $cols)} {incr i} {
        set n($i) [$ns node]
}
for {set j 0} {$j < $rows-1} {incr j} {
	for {set i 0} {$i < $cols-1} {incr i} {
		$ns duplex-link $n([expr ($cols*($j)+$i)]) $n([expr ($cols*($j)+$i+1)]) 1Mb 10ms DropTail
	}
	for {set i 0} {$i < $cols} {incr i} {
		$ns duplex-link $n([expr ($cols*($j)+$i)]) $n([expr ($cols*($j+1)+$i)]) 1Mb 10ms DropTail
	}
}
for {set i 0} {$i < $cols-1} {incr i} {
	$ns duplex-link $n([expr ($rows-1)*($cols)+$i]) $n([expr ($rows-1)*($cols)+$i+1]) 1Mb 10ms DropTail	
}


#TCP
set tcp [new Agent/TCP]
$tcp set fid_ 1
set sink [new Agent/TCPSink]

$ns attach-agent $n($src) $tcp
$ns attach-agent $n($dest) $sink

$ns connect $tcp $sink

#FTP over TCP
set ftp [new Application/FTP]
$ftp attach-agent $tcp



#Scheduling event flow:-

$ns at 1.0 "$ftp start"


#For 36 stations:-
if {($rows * $cols)== 36} {
puts "36 stations"
$ns rtmodel-at 30 down $n(1) $n(2)
$ns rtmodel-at 30 down $n(15) $n(21)
$ns rtmodel-at 30 down $n(19) $n(13)
$ns rtmodel-at 30 down $n(2) $n(3)


$ns rtmodel-at 60 up $n(1) $n(2)
$ns rtmodel-at 60 up $n(2) $n(3)
$ns rtmodel-at 60 down $n(3) $n(9)


$ns rtmodel-at 90 up $n(15) $n(21)
$ns rtmodel-at 90 up $n(3) $n(9)
$ns rtmodel-at 90 up $n(13) $n(19)

}

#For 25 stations:-
if {($rows * $cols)== 25} {
puts "25 stations"
$ns rtmodel-at 30 down $n(8) $n(13)

$ns rtmodel-at 60 down $n(18) $n(23)
$ns rtmodel-at 60 up $n(8) $n(13)
$ns rtmodel-at 60 down $n(5) $n(6)


$ns rtmodel-at 90 up $n(5) $n(6)
$ns rtmodel-at 90 up $n(18) $n(23)

}

#For 16 stations:-
if {($rows * $cols)== 16} {
puts "16 stations"
$ns rtmodel-at 30 down $n(1) $n(2)

$ns rtmodel-at 60 down $n(9) $n(13)
$ns rtmodel-at 60 up $n(1) $n(2)

$ns rtmodel-at 90 up $n(9) $n(13)

}

$ns at 99.5 "$ftp stop"

$ns at 100.0 "finish"


$ns run
