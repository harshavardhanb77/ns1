set ns [new Simulator]
set tf [open prg3.tr w]
set nf [open prg3.nam w]
$ns trace-all $tf
set cwind1 [open win3.tr w]
$ns namtrace-all $nf
$ns rtproto DV

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n1 1.5Mb 5ms DropTail
$ns duplex-link $n0 $n2 1.5Mb 5ms DropTail
$ns duplex-link $n1 $n4 1.5Mb 5ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 5ms DropTail
$ns duplex-link $n4 $n3 1.5Mb 5ms DropTail
$ns duplex-link $n4 $n5 1.5Mb 5ms DropTail
$ns duplex-link $n3 $n5 1.5Mb 5ms DropTail
$ns duplex-link $n1 $n2 1.5Mb 5ms DropTail

$ns duplex-link-op $n0 $n1 orient up-right 
$ns duplex-link-op $n0 $n2 orient down-right
$ns duplex-link-op $n1 $n2 orient down
$ns duplex-link-op $n1 $n4 orient right 
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n4 $n3 orient down
$ns duplex-link-op $n4 $n5 orient down-right
$ns duplex-link-op $n3 $n5 orient up-right


set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp 
set tcpsink [new Agent/TCPSink]
$ns attach-agent $n4 $tcpsink
$ns connect $tcp $tcpsink
set ftp [new Application/FTP]
$ftp attach-agent $tcp

proc plotWindow {tcpSource file} {
	global ns
	set time 0.01
	set now [$ns now]
	set cwnd [$tcpSource set cwnd_]
	puts $file "$now $cwnd"
	$ns at [expr $now+$time] "plotWindow $tcpSource $file"
}
$ns rtmodel-at 1.0 down $n1 $n4
$ns rtmodel-at 5.0 up $n1 $n4
$ns at 0.1 "$ftp start"
$ns at 10.0 "$ftp stop"
$ns at 0.1 "plotWindow $tcp $cwind1"
$ns at 10.1 "finish"


proc finish {} {
	global ns tf nf
	$ns flush-trace
	close $tf
	close $nf
	exec nam prg3.nam &
	exec xgraph win3.tr &
	exit 0
}

$ns run