# [scenario]
# It consists of 8 mobile nodes: 4 source nodes and 4 destination node.
# Each source is a # CBR source over UDP. The size of a transmitted packet is 512 bytes. # Transmission rate # of a node is 600 Kbps.
# We assumed that the nodes are in transmission range at a # constant distance of 195 m. # The simulation time lasted for 80 sec.

# ====================================================================

# Define Node Configuration paramaters

#====================================================================

set val(chan)           Channel/WirelessChannel    ;# channel type

set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model

set val(netif)           Phy/WirelessPhy            ;# network interface type



set val(mac)            Mac/802_11                ;# MAC type

set val(ifq)            Queue/DropTail/PriQueue   ;# interface queue type



set val(ll)             LL                         ;# link layer type

set val(ant)            Antenna/OmniAntenna        ;# antenna model

set val(ifqlen)         50                         ;# max packet in ifq

set val(nn)             8                          ;# number of mobilenodes

set val(rp)             DSDV                       ;# routing protocol

set val(x)              500                        ;# X dimension of the topography

set val(y)              500                           ;# Y dimension of the topography



Mac/802_11 set RTSThreshold_  3000

Mac/802_11 set basicRate_ 1Mb

Mac/802_11 set dataRate_  2Mb



#=====================================================================

# Initialize trace file desctiptors

#=====================================================================

# *** Throughput Trace ***

set f0 [open out02.tr w]

set f1 [open out12.tr w]

set f2 [open out22.tr w]

set f3 [open out32.tr w]




# *** Packet Loss Trace ***

set f4 [open lost02.tr w]

set f5 [open lost12.tr w]

set f6 [open lost22.tr w]

set f7 [open lost32.tr w]


# *** Packet Delay Trace ***

set f8 [open delay02.tr w]

set f9 [open delay12.tr w]

set f10 [open delay22.tr w]

set f11 [open delay32.tr w]



# *** Initialize Simulator ***

set ns [new Simulator]



# *** Initialize Trace file ***

set tracefd [open trace2.tr w]
$ns trace-all $tracefd



# *** Initialize Network Animator ***

set namtrace [open sim12.nam w]

#$ns_ namtrace-all-wireless $namtrace $val(x) $val(y)
$ns namtrace-all $namtrace

# *** set up topography object ***

set topo       [new Topography]

$topo load_flatgrid 500 500



# Create  General Operations Director (GOD) object. It is used to store global information about the state of the environment, network, or nodes that an

# omniscent observer would have, but that should not be made known to any participant in the simulation.



create-god $val(nn)



# configure nodes

            


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
set sink [new Agent/LossMonitor] 
set tcp2 [new Agent/TCP]
set sink2 [new Agent/LossMonitor] 

#$tcp set class_ 2
$ns attach-agent $n0 $tcp1
$ns attach-agent $n4 $sink
$ns attach-agent $n1 $tcp2
$ns attach-agent $n5 $sink2
$ns connect $tcp1 $sink
$ns connect $tcp2 $sink2


#Setup a FTP over TCP connection
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2


# Initialize Flags

set holdtime 0

set holdseq 0



set holdtime1 0

set holdseq1 0



set holdtime2 0

set holdseq2 0



set holdtime3 0

set holdseq3 0



set holdrate1 0

set holdrate2 0

set holdrate3 0

set holdrate4 0



# Function To record Statistcis (Bit Rate, Delay, Drop)



proc record {} {

        global sink sink2 f0 f1 f2 f3 f4 f5 f6 f7 holdtime holdseq holdtime1 holdseq1 holdtime2 holdseq2 holdtime3 holdseq3 f8 f9 f10 f11 holdrate1 holdrate2 holdrate3 holdrate4

     

        set ns [Simulator instance]

     

    set time 0.9 ;#Set Sampling Time to 0.9 Sec



        set bw0 [$sink set bytes_]

        set bw1 [$sink2 set bytes_]

       



        set bw4 [$sink set nlost_]

        set bw5 [$sink2 set nlost_]




        set bw8 [$sink set lastPktTime_]

        set bw9 [$sink set npkts_]



        set bw10 [$sink2 set lastPktTime_]

        set bw11 [$sink2 set npkts_]

     

    set now [$ns now]

     

        # Record Bit Rate in Trace Files

        puts $f0 "$now [expr (($bw0+$holdrate1)*8)/(2*$time*1000000)]"

        puts $f1 "$now [expr (($bw1+$holdrate2)*8)/(2*$time*1000000)]"



        # Record Packet Loss Rate in File

        puts $f4 "$now [expr $bw4/$time]"

        puts $f5 "$now [expr $bw5/$time]"

 


        # Record Packet Delay in File

        if { $bw9 > $holdseq } {

                puts $f8 "$now [expr ($bw8 - $holdtime)/($bw9 - $holdseq)]"

        } else {

                puts $f8 "$now [expr ($bw9 - $holdseq)]"

        }



        if { $bw11 > $holdseq1 } {

                puts $f9 "$now [expr ($bw10 - $holdtime1)/($bw11 - $holdseq1)]"

        } else {

                puts $f9 "$now [expr ($bw11 - $holdseq1)]"

        }


     

        # Reset Variables

        $sink set bytes_ 0

        $sink2 set bytes_ 0

       


        $sink set nlost_ 0

        $sink2 set nlost_ 0

      


        set holdtime $bw8

        set holdseq $bw9



        set  holdrate1 $bw0

        set  holdrate2 $bw1

     


    $ns at [expr $now+$time] "record"   ;# Schedule Record after $time interval sec

}





# Start Recording at Time 0

$ns at 0.0 "record"



$ns at 0.0 "$ftp1 start"                 ;# Start transmission at time t = 1.4 Sec



$ns at 0.0 "$ftp2 start"               ;# Start transmission at time t = 10 Sec


# Stop Simulation at Time 80 sec

$ns at 200.0 "stop"




# Exit Simulatoion at Time 80.01 sec

$ns at 200.01 "puts \"NS EXITING...\" ; $ns halt"



proc stop {} {

        global ns tracefd f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11



        # Close Trace Files

        close $f0

        close $f1

        close $f2

        close $f3



        close $f4

        close $f5

        close $f6

        close $f7



        close $f8

        close $f9

        close $f10

        close $f11



        # Plot Recorded Statistics

      #  exec xgraph out02.tr out12.tr out22.tr out32.tr -geometry 800x400 -P -bg white &

       # exec xgraph lost02.tr lost12.tr lost22.tr lost32.tr -geometry 800x400 -P -bg white &

        #exec xgraph delay02.tr delay12.tr delay22.tr delay32.tr -geometry 800x400 -P -bg white &

     

        # Reset Trace File

        $ns flush-trace

        close $tracefd

     

        exit 0

}



puts "Starting Simulation..."

$ns run

