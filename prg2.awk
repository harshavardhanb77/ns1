BEGIN{
	telnet_pkt=0;
	ftp_pkt=0;
	start=0.1;
	stop=10.1;
}
{
	if($1=="r" && $5=="tcp" && $3==1)
	{
	 ftp_pkt+=$6
	}
	if($1=="r" && $5=="tcp" && $3==0)
	{
	telnet_pkt+=$6
	}
}
END{
	printf("%fkbps",(ftp_pkt/(stop-start))*(8/1000));
	printf("%fkbps",(telnet_pkt/(stop-start))*(8/1000));
}