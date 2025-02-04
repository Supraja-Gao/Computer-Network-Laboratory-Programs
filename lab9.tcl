#9.⁠ ⁠Go-Back-N Protocol Simulation
#Simulate and study the Go-Back-N ARQ protocol.

set ns [ new Simulator ]
set tracefile [ open lab9.tr w ]
$ns trace-all $tracefile
set namfile [ open lab9.nam w ]
$ns namtrace-all $namfile

set n0 [ $ns node ]
set n1 [ $ns node ]

$ns at 0.0 "$n0 label Sender"
$ns at 0.0 "$n1 label Reciever"

$ns duplex-link $n0 $n1 0.2Mb 200ms DropTail
$ns duplex-link-op $n0 $n1 orient right

Agent/TCP set nam_tracevar_ true
set tcp [ new Agent/TCP ]
$tcp set fid_ 1
$tcp set window_ 3
$tcp set maxcwnd_ 4
$ns attach-agent $n0 $tcp
set sink [ new Agent/TCPSink ]
$ns attach-agent $n1 $sink
$ns connect $tcp $sink

set ftp [ new Application/FTP ]
$ftp attach-agent $tcp

$ns add-agent-trace $tcp tcp
$ns monitor-agent-trace $tcp
$tcp tracevar cwnd_

proc finish { } {
global ns namfile
$ns flush-trace
close $namfile
puts "running nam..."
exec nam lab9.nam &
exit 0
}

$ns at 0.1 "$ftp start"
$ns at 3.0 "$ns detach-agent $n0 $tcp ; $ns detach-agent $n1 $sink"
$ns at 3.5 "finish"

$ns run