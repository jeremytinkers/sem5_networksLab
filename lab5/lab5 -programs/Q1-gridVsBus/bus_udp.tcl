
LanRouter set debug_ 0

#Simulator object
set ns [new Simulator]

#tcp
$ns color 1 Orange    


puts " "
puts " "
puts "----------------------------------------------------------- "
puts " Welcome onboard! Jeremiah Thomas | Network Lab5 "
puts "----------------------------------------------------------- "

#Log simulation info to run awk scripts on
set tracefile [open bus_udp_log.tr w]
$ns trace-all $tracefile

#Nam Trace FILE for the animation
set nf [open bus_udp_disp.nam w]
$ns namtrace-all $nf

#finish procedure
proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exit 0
}

#Node Creation : Create 10 nodes
for {set i 0} {$i < 10} {incr i} {
    set n($i) [$ns node]
}

#Links
# Need to create a LAN since its bus


set lan0 [$ns newLan "$n(0) $n(1) $n(2) $n(3) $n(4) $n(5) $n(6) $n(7) $n(8) $n(9)" 1Mb 10ms LL Queue/FQ MAC/Csma/Cd Channel]

set j 1
#for {set i 0} {$i < 9} {incr i} {
#    $ns duplex-link $n($i) $n($j) 5Mb 8ms DropTail
#    incr j
#  }


#Picking a random source and dest

set src [ expr int(rand()*10) ]

set dest [ expr int(rand()*10) ]

while {$dest == $src} {

set dest [ expr int(rand()*10) ]

}


puts "The Source Node is : $src"
puts "The Destination Node is : $dest"



#UDP
set udp [new Agent/UDP]
$udp set fid_ 1
set null [new Agent/Null]

$ns attach-agent $n($src) $udp
$ns attach-agent $n($dest) $null

$ns connect $udp $null

#CBR over UDP
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp


#Scheduling event flow:-

$ns at 1.0 "$cbr start"
$ns at 99.0 "$cbr stop"

$ns at 100.0 "finish"

puts " "
puts "---------------------------------------------------------------------------------------------- "
puts "Instead of bus, replace with : bus_udp"
puts " The NAM and Log Trace files have been created. Do run the following commands in order:- "
puts ""
puts " For viewing the simulation : nam star_disp.nam"
puts ""
puts "---------------------------------------------------------------------------------------------- "
puts " 1.For plotting Packet Delivery Ratio :-"
puts "---------------------------------------------------------------------------------------------- "
puts "   A) Run : awk -f pdr.awk -v src=<src> -v dest=<dest> bus_log.tr>bus_pdr"
puts "   B) Run : xgraph bus_pdr"

puts ""
puts "---------------------------------------------------------------------------------------------- "
puts " 2.For plotting Packet Loss Ratio :-"
puts "---------------------------------------------------------------------------------------------- "
puts "   A) Run : awk -f plr.awk -v src=<src> -v dest=<dest>  bus_log.tr>bus_plr"
puts "   B) Run : xgraph bus_plr"
puts ""
puts "---------------------------------------------------------------------------------------------- "
puts " 3.For plotting End to End Delay :-"
puts "---------------------------------------------------------------------------------------------- "
puts "   A) Run : awk -f e2e_delay.awk -v src=<src> -v dest=<dest> bus_log.tr>bus_e2e_delay"
puts "   B) Run : xgraph bus_e2e_delay"
puts ""
puts "---------------------------------------------------------------------------------------------- "
puts " "

#Run the simulation
$ns run



