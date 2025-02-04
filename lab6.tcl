# 6.⁠ ⁠Token Bus Protocol Simulation
#Create a scenario and study the performance of token bus protocol through a simulator using bus topology.

set ns [ new Simulator ]

set namfile [ open lab6.nam w ]
$ns namtrace-all $namfile

proc finish { } {
global ns namfile
$ns flush-trace
close $namfile
exec nam lab6.nam &
exit 0
}

set n0 [ $ns node ]
set n1 [ $ns node ]
set n2 [ $ns node ]
set n3 [ $ns node ]
set n4 [ $ns node ]
set n5 [ $ns node ]

set lan0 [$ns newLan "$n0 $n1 $n2 $n3 $n4 $n5" 0.5Mb 40ms LLQueue/DropTailMac/CSMA/CdChannel]

set tcp [ new Agent/TCP ]
$tcp set class_ 1
$ns attach-agent $n1 $tcp
set sink [ new Agent/TCPSink]
$ns attach-agent $n3 $sink
$ns connect $tcp $sink

set cbr [ new Application/Traffic/CBR ]
$cbr set packetSize_ 500
$cbr set interval_ 0.1
$cbr set type_ CBR
$cbr attach-agent $tcp

$ns at 0.1 "$cbr start"
$ns at 5.0 "$cbr stop"
$ns at 5.5 "finish"
$ns run