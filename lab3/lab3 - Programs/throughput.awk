BEGIN{

sttime[15]=0
stime[15]=0
ftime[15]=0
flag[15]=0
fsize[15]=0
throughput[15]=0
latency[15]=0

avgt=0
count=0

}
{

for(i=0; i<=14 ; i=i+2)
if($1=="r" && $4 ==i)
{
fsize[i]+=$6
if(flag[i]==0)
{
stime[i]=$2
flag[i]=1
count++;
}
ftime[i]=$2;

}
}
END{
for(i=0; i<=14 ; i=i+2)
if(i<= ((count-1)*2))
{
latency[i]= ftime[i] - stime[i]
throughput[i] = (fsize[i]*8)/latency[i]
avgt += throughput[i]
}
avgt = avgt /count;
printf("\n throughput for this run : %f", avgt)
}
