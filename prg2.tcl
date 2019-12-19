set ns [new Simulator]
set tf [open prg2.tr w]
$ns trace-all $tf
set nf [open prg2.nam w]
$ns namtrace-all $nf
set cwind1 [open win1.tr w]
set cwind2 [open win2.tr w]


set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n2 1.5Mb 5ms DropTail
$ns duplex-link $n1 $n2 1.5Mb 5ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 5ms DropTail
$ns duplex-link $n4 $n3 1.5Mb 5ms DropTail
$ns duplex-link $n5 $n3 1.5Mb 5ms DropTail

$ns duplex-link-op $n0 $n2 orient down-right
$ns duplex-link-op $n1 $n2 orient up-right
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n4 $n3 orient down-left
$ns duplex-link-op $n5 $n3 orient up-left

set tcp0 [new Agent/TCP]
$ns attach-agent $n1 $tcp0
set tcpsink0 [new Agent/TCPSink]
$ns attach-agent $n5 $tcpsink0
$ns connect $tcp0 $tcpsink0
set ftp [new Application/FTP]
$ftp attach-agent $tcp0

set tcp1 [new Agent/TCP]
$ns attach-agent $n0 $tcp1
set tcpsink1 [new Agent/TCPSink]
$ns attach-agent $n4 $tcpsink1
$ns connect $tcp1 $tcpsink1
set telnet [new Application/Telnet]
$telnet attach-agent $tcp1

proc plotWindow {tcpSource file} {
	global ns
	set time 0.01
	set now [$ns now]
	set cwnd [$tcpSource set cwnd_]
	puts $file "$now $cwnd"
	$ns at [expr $now+$time] "plotWindow $tcpSource $file"
}

$ns at 0.1 "$ftp start"
$ns at 10.0 "$ftp stop"
$ns at 0.1 "$telnet start"
$ns at 10.0 "$telnet stop"
$ns at 0.1 "plotWindow $tcp0 $cwind1"
$ns at 0.1 "plotWindow $tcp1 $cwind2"
$ns at 10.1 "finish"

proc finish {} {
	global ns tf nf
	$ns flush-trace
	close $tf
	close $nf
	exec nam prg2.nam &
	exec xgraph win1.tr &
	exec xgraph win2.tr &
	exec awk -f prg2.awk prg2.tr &
	exit 0
}


$ns run