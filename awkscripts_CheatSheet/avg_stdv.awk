# Packet Interarrival times:-
# Standard DV & Average
BEGIN{

ctime=0;
i=0;
avg;

}

{

e=$1;
#Trace File current destination
tf_dest=$4;
#Trace File current source
tf_src=$3;
ctime=$2

if(e =="r" && tf_dest==dest)
{
# rtime stores the times of the first bit of a sequence received by dest
rtime[i] = ctime;
if(i!=0){
iat[i] = ctime -rtime[i-1];
}else{
iat[i] = ctime;
}
avg+= iat[i];
i++;

}


}

END{

avg=avg/i;

stdv=0;

for(j=0;j<i;j++){

stdv+= (iat[i]- avg)*(iat[i] - avg);

}

stdv = sqrt(stdv/i);

printf("Average Packet Interarrival Time  : %f\n", avg);
printf("Standard Deviation of Packet Interarrival Time  : %f\n", stdv);
}
