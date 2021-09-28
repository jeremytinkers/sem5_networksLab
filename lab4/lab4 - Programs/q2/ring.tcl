#Simulator object
set ns [new Simulator]

#tcp
$ns color 1 Yellow    


puts " "
puts " "
puts "------------------------------------------------------------ "
puts " Welcome onboard! Jeremiah Thomas | Network Lab4 | Q2 | RING "
puts "------------------------------------------------------------ "

#Log simulation info to run awk scripts on
set tracefile [open ring_log.tr w]
$ns trace-all $tracefile

#Nam Trace FILE for the animation
set nf [open ring_disp.nam w]
$ns namtrace-all $nf

#finish procedure
proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exit 0
}

#Node Creation : Create 6 nodes
for {set i 0} {$i < 6} {incr i} {
    set n($i) [$ns node]
}

#Links

set j 1

for {set i 0} {$i < 5} {incr i} {
    $ns duplex-link $n($i) $n($j) 5Mb 8ms DropTail
    incr j
  }
  
 $ns duplex-link $n(5) $n(0) 5Mb 8ms DropTail ;# Close the Ring

#Picking a random source and dest

set src [ expr int(rand()*6) ]

set dest [ expr int(rand()*6) ]

while {$dest == $src} {

set dest [ expr int(rand()*6) ]

}


puts "The Source Node is : $src"
puts "The Destination Node is : $dest"


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
$ns at 49.0 "$ftp stop"

$ns at 50.0 "finish"


puts " "
puts "---------------------------------------------------------------------------------------------- "
puts " The NAM and Log Trace files have been created. Do run the following commands in order:- "
puts ""
puts " For viewing the simulation : nam ring_disp.nam"
puts ""
puts "---------------------------------------------------------------------------------------------- "
puts " 1.For plotting Packet Delivery Ratio :-"
puts "---------------------------------------------------------------------------------------------- "
puts "   A) Run : awk -f pdr.awk -v src=<src> -v dest=<dest> ring_log.tr>ring_pdr"
puts "   B) Run : xgraph ring_pdr"

puts ""
puts "---------------------------------------------------------------------------------------------- "
puts " 2.For plotting Packet Loss Ratio :-"
puts "---------------------------------------------------------------------------------------------- "
puts "   A) Run : awk -f plr.awk -v src=<src> -v dest=<dest>  ring_log.tr>ring_plr"
puts "   B) Run : xgraph ring_plr"
puts ""
puts "---------------------------------------------------------------------------------------------- "
puts " 3.For plotting End to End Delay :-"
puts "---------------------------------------------------------------------------------------------- "
puts "   A) Run : awk -f e2e_delay.awk -v src=<src> -v dest=<dest> ring_log.tr>ring_e2e_delay"
puts "   B) Run : xgraph ring_e2e_delay"
puts ""
puts "---------------------------------------------------------------------------------------------- "
puts " "

#Run the simulation
$ns run

