set bwDL(cdna) 384000
set bwUL(cdna) 64000
set propDL(cdma) .150
set propuL.(cdma) .150
set buf(cdma) 20
set ns [new Stmulator]
set nt [open lab12.tr w]
$ns trace-all $nt
set nodes(c1) [$ns node]
set nodes(ms) [$ns node]
set nodes(bs1) [$ns node]
set nodes(bs2) [$ns node]
set nodes(c2) [Sns node]
proc cell_topo {} {
global ns nodes
$ns duplex-link $nodes(c1) $nodes(bs1) 3Mbps 10ns DropTail
$ns duplex-link $nodes(bs1) $nodes(ns) 1 1 RED
$ns duplex-link $nodes(ns) Snodes(bs2) 1 1 RED
$ns duplex-link $nodes(bs2) $nodes(c2) 3Mbps 50ms DropTail
}
switch umts (
cdma -
umts (cell_topo)
)
$ns bandwidth $nodes(bs1) $nodes(ms) $bwDL(cdma) simplex
$ns bandwidth $nodes(ms) $nodes(bs1) $bwUL(cdma) simplex 
$ns bandwldth $nodes(bs2) $nodes(ms) $bwDL(cdma) simplex 
$ns bandwidth $nodes(ms) $nodes(bs2) $bwUL(cdma) simplex 
$ns delay $nodes(bs1) $nodes(ms) $propDL(cdma) stnplex
$ns delay $nodes(ms) $nodes(bs1) $propDL(cdma) simplex
$ns delay $nodes(bs2) $nodes(ms) $propDL(cdma) simplex
$ns delay $nodes(ms) $nodes(bs2) $propDL(cdma) simplex
$ns queue-limit $nodes(bs1) $nodes(ms) $buf(cdma)
$ns queue-limit $nodes(ms) $nodes(bs1) $buf(cdma)
$ns queue-limit $nodes (bs2) $nodes (ms) $buf(cdma)
$ns queue-limit $nodes (ms) $nodes (bs2) $buf (cdma)
$ns insert- delayer $nodes (ms) $nodes(bs) [new Delayer]
$ns insert-delayer $nodes(bs1) $nodes(ms) [new Delayer]
$ns insert-delayer $nodes(bs2) $nodes(ms) [new Delayer]
$ns insert-delayer $nodes(ms) $nodes(bs2) [new Delayer]
set tcp [new Agent/TCP]
$ns attach-agent $nodes(c1) $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $nodes(c2) $sink
set ftp [new Applicatton/FTP]
$ftp attach-agent $tcp
$ns connect $tcp $sink


proc End {} {
global ns nt
$ns flush-trace
close $nt
exec awk -f lab12.awk lab12.tr
exec xgraph -P -bar -x TIME -y DATA lab12.xg &
exit0
}


$ns at 0. O "$ftp start"
$ns at 10.0 "End"
$ns run


#awk 
BEGIN (Total_no_of_pkts=0;)
{
if($1 -= "r")
{
Total_no_of_pkts=Total_no_of_pkts + $6;
printf("%f %d\n",$2,Total_no_of_pkts) >> "lab12.xg"
}
}
END