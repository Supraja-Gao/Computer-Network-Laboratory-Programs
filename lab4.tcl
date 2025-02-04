#Token Ring Protocol (Ring Topology)
#Create a simulation scenario and study the performance of token ring protocols using a ring topology.
set ns [ new Simulator ]
set namfile [ open lab4.nam w ]
$ns namtrace-all $namfile
proc finish { } {
global ns namfile
$ns flush-trace
close $namfile
exec nam lab4.nam &
exit 0
}
set n0 [ $ns node ]
set n1 [ $ns node ]
set n2 [ $ns node ]
set n3 [ $ns node ]
set n4 [ $ns node ]
set n5 [ $ns node ]

#not a compulsion
$ns color 1 blue

$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail
$ns duplex-link $n3 $n4 1Mb 10ms DropTail
$ns duplex-link $n4 $n5 1Mb 10ms DropTail
$ns duplex-link $n5 $n0 1Mb 10ms DropTail

set tcp [ new Agent/TCP ]
$tcp set class_ 1
$ns attach-agent $n1 $tcp
set sink [ new Agent/TCPSink ]
$ns attach-agent $n3 $sink
$ns connect $tcp $sink

set cbr [ new Application/Traffic/CBR ]
$cbr set packetSize_ 500
$cbr set interval_ 0.01
$cbr set type_ CBR
$cbr attach-agent $tcp

$ns at 0.1 "$cbr start"
$ns at 5.0 "$cbr stop"
$ns at 5.5 "finish"

$ns run