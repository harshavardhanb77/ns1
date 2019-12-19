set ns [new Simulator]
set tf [open prg4.tr w]
$ns trace-all $tf
set nf [open prg4.nam w]
$ns namtrace-all $nf

#node 0
set s [$ns node]
#node 1
set c [$ns node]
$s label "Server"
$c label "Client"

$ns duplex-link $s $c 10Mb 22ms DropTail

set tcp [new Agent/TCP]
$ns attach-agent $s $tcp
$tcp set packetSize_ 1500
set tcpsink [new Agent/TCPSink]
$ns attach-agent $c $tcpsink
$ns connect $tcp $tcpsink
set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns at 0.1 "$ftp start"
$ns at 15.0 "$ftp stop"
$ns at 15.1 "finish"

proc finish {} {
	global ns tf nf
	$ns flush-trace
	close $tf
	close $nf
	exec nam prg4.nam &
	exec awk -f prg4.awk prg4.tr &
	exec awk -f prg4convert.awk prg4.tr > convert.tr
	exec xgraph convert.tr &
	exit 0 
}

$ns run