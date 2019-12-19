BEGIN{
	time=0;
	totalSent=0;
	totalRecived=0;
}
{
	if($1=="+" && $3==0 && $5=="tcp")
	{
		totalSent+=$6;
	}
	if($1=="r" && $4==1 && $5=="tcp")
	{
		totalRecived+=$6;
	}
	time=$2;
}
END{
	printf("%f\n",(totalSent)/1000000);
	printf("%f\n",(totalRecived)/1000000);
	printf("%f",(time));
}