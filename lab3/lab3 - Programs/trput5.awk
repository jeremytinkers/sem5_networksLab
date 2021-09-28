BEGIN{

stime1=0
ftime1=0
flag1=0
fsize1=0
throughput1=0
latency1=0

stime2=0
ftime2=0
flag2=0
fsize2=0
throughput2=0
latency2=0

stime3=0
ftime3=0
flag3=0
fsize3=0
throughput3=0
latency3=0
}
{
if($1=="r" && $4 ==4)
{
fsize1+=$6
if(flag1==0)
{
stime1=$2
flag1=1
}
ftime1=$2;
}

}
END{
latency1=ftime1-stime1
throughput1=(fsize1*8)/latency1

printf("\n throughput for this run : %f", throughput1)
}
