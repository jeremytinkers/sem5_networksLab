BEGIN{

sttime[4]=0
stime[4]=0
ftime[4]=0
flag[4]=0
fsize[4]=0
throughput[4]=0
latency[4]=0

sttime2[4]=0
stime2[4]=0
ftime2[4]=0
flag2[4]=0
fsize2[4]=0
throughput2[4]=0
latency2[4]=0

}
{
# for ftp connection 1 with node 4 as destination
if($1=="r" && $2<50.1 && $4 ==4)
{
fsize[1]+=$6
if(flag[1]==0)
{
stime[1]=$2
flag[1]=1
}
ftime[1]=$2;
}

if($1=="r" && $2<100.1 && $2>50.1 && $4 ==4)
{
fsize[2]+=$6
if(flag[2]==0)
{
stime[2]=$2
flag[2]=1
}
ftime[2]=$2;
}

if($1=="r" && $2<150.1 && $2>100.1 && $4 ==4)
{
fsize[3]+=$6
if(flag[3]==0)
{
stime[3]=$2
flag[3]=1
}
ftime[3]=$2;
}
if($1=="r" && $2<200.1 && $2>150.1 && $4 ==4)
{
fsize[4]+=$6
if(flag[4]==0)
{
stime[4]=$2
flag[4]=1
}
ftime[4]=$2;
}
# for ftp connection 2 with node 5 as destination
if($1=="r" && $2<50.1 && $4 ==5)
{
fsize2[1]+=$6
if(flag2[1]==0)
{
stime2[1]=$2
flag2[1]=1
}
ftime2[1]=$2;
}

if($1=="r" && $2<100.1 && $2>50.1 && $4 ==5)
{
fsize2[2]+=$6
if(flag2[2]==0)
{
stime2[2]=$2
flag2[2]=1
}
ftime2[2]=$2;
}

if($1=="r" && $2<150.1 && $2>100.1 && $4 ==5)
{
fsize2[3]+=$6
if(flag2[3]==0)
{
stime2[3]=$2
flag2[3]=1
}
ftime2[3]=$2;
}
if($1=="r" && $2<200.1 && $2>150.1 && $4 ==5)
{
fsize2[4]+=$6
if(flag2[4]==0)
{
stime2[4]=$2
flag2[4]=1
}
ftime2[4]=$2;
}
}
END{
for(i=1; i<=4 ; i++)
{
latency[i]= ftime[i] - stime[i]
throughput[i] = (fsize[i]*8)/latency[i]
printf("\n Throughput for Interval %d of ftp connection1  is  : %f", i, throughput[i])
}
printf("\n");
for(i=1; i<=4 ; i++)
{
latency2[i]= ftime2[i] - stime2[i]
throughput2[i] = (fsize2[i]*8)/latency2[i]
printf("\n Throughput for Interval %d of ftp connection2  is  : %f", i, throughput[i])
}


}
