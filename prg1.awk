BEGIN{
	tcp_r=0;
	tcp_d=0;
	udp_r=0;
	udp_d=0;
}
{
	if($1="r" && $5=="tcp")
	{
		tcp_r+=1;
	}
	if($1="d" && $5=="tcp")
	{
	tcp_d+=1;
	}
	if($1="r" && $5=="cbr")
	{
	udp_r+=1;
	}
	if($1="d" && $5=="cbr")
	{
	udp_d+=1;
	}
}
END{
	printf("%f\n%f\n%f\n%f",tcp_r,tcp_d,udp_r,udp_d);
}
