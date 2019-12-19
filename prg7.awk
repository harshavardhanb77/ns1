BEGIN{
	rcvdSize=0;
	startTime=0;
	stopTime=0;
}
{  
	event=$1;
	time=$2;
	level=$4;
	node_id=$3;
	pktSize=$8;
	if(level=="AGT" && event=="s" && pktSize>=512)
	{
		if(startTime>time)
		{
		startTime=time;
		}
	}
	if(level=="AGT" && event=="r" && pktSize>=512)
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
	printf("AWK output");
	printf("%f\n",startTime);
	printf("%f\n",stopTime);
	printf("%f\n",(rcvdSize/(stopTime-startTime))*(8/1000));
}
