set val(chan) Channel/WirelessChannel
set val(prop) Propagation/TwoRayGround
set val(ll) LL
set val(ant) Antenna/OmniAntenna
set val(rp) DSDV
set val(ifq) Queue/DropTail/PriQueue
set val(ifqlen) 50
set val(mac) Mac/802_11
set val(x) 500
set val(y) 500
set val(stop) 20
set val(netif) Phy/WirelessPhy
set val(nn) 2

set ns_ [new Simulator]
set tf [open prg6.tr w]
$ns_ trace-all $tf
set nf [open prg6.nam w]
$ns_ namtrace-all-wireless $nf $val(x) $val(y)
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
set god_ [create-god $val(nn)]

$ns_ node-config -adhocRouting $val(rp)\
-macType $val(mac)\
-llType $val(ll)\
-antType $val(ant)\
-propType $val(prop)\
-phyType $val(netif)\
-topoInstance $topo\
-agentTrace ON\
-macTrace ON\
-routerTrace ON\
-channelType $val(chan)\
-ifqLen $val(ifqlen)\
-ifqType $val(ifq)

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

for {set i 0} {$i<$val(nn)} {incr i} {
	$ns_ initial_node_pos $node_($i) 40
}
$ns_ at 0.1 "$node_(0) setdest 150.0 150.0 5.0"
$ns_ at 0.1 "$node_(1) setdest 200.0 200.0 5.0"

set tcp [new Agent/TCP]
$ns_ attach-agent $node_(0) $tcp 
set tcpsink [new Agent/TCPSink]
$ns_ attach-agent $node_(1) $tcpsink
$ns_ connect $tcp $tcpsink
set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns_ at 0.1 "$ftp start"
$ns_ at 15.1 "$ftp stop"

for {set i 0} {$i<$val(nn)} {incr i} {
	$ns_ at $val(stop) "$node_($i) reset"
}

$ns_ at $val(stop) "puts \"Exiting\";$ns_ halt"
$ns_ run
exec nam prg6.nam &
exec awk -f prg6.awk prg6.tr &