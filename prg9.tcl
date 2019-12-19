set val(chan) Channel/WirelessChannel
set val(prop) Propagation/TwoRayGround
set val(ll) LL
set val(ant) Antenna/OmniAntenna
set val(mac) Mac/802_11
set val(stop) 100.0
set val(nn) 3
set val(netif) Phy/WirelessPhy
set val(ifq) Queue/DropTail/PriQueue
set val(ifqlen) 50
set val(x) 500
set val(y) 500
set val(rp) AODV

set ns_ [new Simulator]
set tf [open prg9.tr w]
set nf [open prg9.nam w]
$ns_ trace-all $tf
$ns_ namtrace-all-wireless $nf $val(x) $val(y)
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
set god_ [create-god $val(nn)]
set cwind1 [open win9.tr w]

$ns_ node-config -adhocRouting $val(rp)\
-llType $val(ll)\
-channelType $val(chan)\
-propType $val(prop)\
-phyType $val(netif)\
-antType $val(ant)\
-macType $val(mac)\
-agentTrace ON\
-routerTrace ON\
-macTrace ON\
-topoInstance $topo\
-ifqType $val(ifq)\
-ifqLen $val(ifqlen)\
-incomingErrorProc "uniformProc"\
-outgoingErrorProc "uniformProc"

proc uniformProc {} {
	set err [new ErrorModel]
	$err unit pkt
	$err set rate _0.1
	return $err
}

for {set i 0} {$i<$val(nn)} {incr i} {
 set node_($i) [$ns_ node]
 $node_($i) random-motion 0
}

$node_(0) set X_ 110.0
$node_(0) set Y_ 110.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 210.0
$node_(1) set Y_ 210.0
$node_(1) set Z_ 0.0

$node_(2) set X_ 310.0
$node_(2) set Y_ 310.0
$node_(2) set Z_ 0.0

for {set i 0} {$i<$val(nn)} {incr i} {
	$ns_ initial_node_pos $node_($i) 40
}

$ns_ at 0.1 "$node_(0) setdest 150.0 150.0 10.0"
$ns_ at 0.1 "$node_(1) setdest 170.0 170.0 10.0"
$ns_ at 0.1 "$node_(2) setdest 190.0 190.0 10.0"
$ns_ at 5.0 "$node_(0) setdest 50.0 50.0 10.0"
$ns_ at 5.0 "$node_(2) setdest 250.0 250.0 10.0"

proc plotWindow {tcpSource file} {
	global ns_ 
	set time 0.01
	set now [$ns_ now]
	set cwnd [$tcpSource set cwnd_]
	puts $file "$now $cwnd"
	$ns_ at [expr $now+$time] "plotWindow $tcpSource $file"
}
set tcp [new Agent/TCP]
$ns_ attach-agent $node_(0) $tcp
set tcpsink [new Agent/TCPSink]
$ns_ attach-agent $node_(2) $tcpsink
$ns_ connect $tcp $tcpsink
set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns_ at 0.1 "$ftp start"
$ns_ at 10.0 "$ftp stop"
$ns_ at 0.1 "plotWindow $tcp $cwind1"
for {set i 0} {$i<$val(nn)} {incr i} {
	$ns_ at $val(stop) "$node_($i) reset"	
}

$ns_ at $val(stop) "puts \"Exiting nam\";$ns_ halt"
$ns_ run 
exec nam prg9.nam &
exec xgraph win9.tr &