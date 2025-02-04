
# 1.⁠ ⁠Point-to-Point Network Simulation
#Implement a 3-node point-to-point network with duplex links between them. Set the queue size, vary the bandwidth, and find the number of packets dropped.
set ns [ new Simulator ]

set tracefile [ open lab1.tr w ]
$ns trace-all $tracefile
set namfile [ open lab1.nam w ]
$ns namtrace-all $namfile

set n0 [ $ns node ]
set n1 [ $ns node ]
set n2 [ $ns node ]

#labelling and colouring not a compulsion
$n0 label " TcpSource "
$n2 label " Sink "
$ns color 1 blue

$ns duplex-link $n0 $n1 1Mb 10ms DropTail   #change the bandwidth to 0.5mb to increase packets drop ,5Mb to decrease packets drop
$ns duplex-link $n1 $n2 1Mb 10ms DropTail

$ns queue-limit $n0 $n1 10 #set it to 5 ,the packets dropped will increase
$ns queue-limit $n1 $n2 10

set tcp [ new Agent/TCP ]
$ns attach-agent $n0 $tcp

set sink [ new Agent/TCPSink ]
$ns attach-agent $n2 $sink

$ns connect $tcp $sink

set cbr [ new Application/Traffic/CBR ]
$cbr attach-agent $tcp

proc finish { } {
global ns tracefile namfile
$ns flush-trace
close $namfile
close $tracefile
exec nam lab1.nam &
exec echo " number of packets dropped: " &
exec grep -c "^d" lab1.tr &
exit 0
}

$ns at 0.1 " $cbr start "
$ns at 5.0 " $cbr stop "
$ns at 5.5 "finish"

$ns run

