set ns [new Simulator]
set tf [open prg1.tr w]
$ns trace-all $tf
set nf [open prg1.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 1.5Mb 5ms DropTail
$ns duplex-link $n1 $n2 1.5Mb 5ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 5ms DropTail

$ns queue-limit $n0 $n2 5
$ns queue-limit $n1 $n2 5
$ns queue-limit $n2 $n3 5
$ns color 1 blue
$ns color 2 Red

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set tcpsink [new Agent/TCPSink]
$ns attach-agent $n3 $tcpsink
$ns connect $tcp $tcpsink
$tcp set class_ 1
set ftp [new Application/FTP]
$ftp attach-agent $tcp

set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set udpsink [new Agent/Null]
$ns attach-agent $n3 $udpsink
$ns connect $udp $udpsink
$udp set class_ 2
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp

$ns at 0.1 "$ftp start"
$ns at 10.0 "$ftp stop"
$ns at 0.1 "$cbr start"
$ns at 10.0 "$cbr stop"
$ns at 10.1 "finish"


proc finish {} {
	global ns tf nf
	$ns flush-trace
	close $tf
	close $nf
	exec nam prg1.nam &
	exec awk -f prg1.awk prg1.tr &
	exit 0
}

$ns run