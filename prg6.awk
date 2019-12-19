BEGIN{
	rcvdSize=0;
	startTime=400;
	stopTime=0;
}
{
	event=$1;
	time=$2;
	node_id=$3;
	level=$4;
	pktSize=$8;
	if(level=="AGT" && event=="s" && pktSize>=512)
	{
	 if(startTime>time)
	 {
	 startTime=time;
	 }
	}
	if(level=="AGT" && event=="s" && pktSize>=512)
	{
	if(stopTime<time)
	{
	stopTime=time;
	}
	headerSize=pktSize%512;
	pktSize-=headerSize;
	rcvdSize+=pktSize;
	}
}
END{
	printf("%f\n",startTime)
	printf("%f\n",stopTime)
	printf("%f\n",(rcvdSize/(stopTime-startTime))*(8/1000))
}