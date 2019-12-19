set val(chan) Channel/WirelessChannel
set val(prop) Propagation/TwoRayGround
set val(ll) LL
set val(ant) Antenna/OmniAntenna
set val(nn) 25
set val(x) 500
set val(y) 400
set val(stop) 100
set val(netif) Phy/WirelessPhy
set val(ifq) Queue/DropTail/PriQueue
set val(ifqlen) 50
set val(mac) Mac/802_11
set val(rp) AODV
#set val(sc) "mob"
set val(cp) "tcp"

set ns_ [new Simulator]
set tf [open prg10.tr w]
set nf [open prg10.nam w]
$ns_ trace-all $tf
$ns_ namtrace-all-wireless $nf $val(x) $val(y)
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
set god_ [create-god $val(nn)]


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
-ifqLen $val(ifqlen)

for {set i 0} {$i<$val(nn)} {incr i} {
 set node_($i) [$ns_ node]
 $node_($i) random-motion 0
}

for {set i 0} {$i<$val(nn)} {incr i} {
 set XX [expr rand()*500]
 set YY [expr rand()*400]
 $node_($i) set X_ $XX
 $node_($i) set Y_ $YY	
}

for {set i 0} {$i<$val(nn)} {incr i} {
	$ns_ initial_node_pos $node_($i) 40	
}

#puts "loading scenario file"
#source $val(sc)

puts "loading connection file"
source $val(cp)

for {set i 0} {$i<$val(nn)} {incr i} {
	$ns_ at $val(stop) "$node_($i) reset"	
}

$ns_ at $val(stop) "puts \"Exiting nam\";$ns_ halt"
$ns_ run 
exec nam prg10.nam &
exec awk -f prg7.awk prg10.tr & 