# Packet Interarrival times:-
BEGIN{
ctime=0;
i=0;
}

{

e=$1;
#Trace File current destination
tf_dest=$4;
#Trace File current source
tf_src=$3;
ctime=$2

if(e =="r" && tf_dest==dest && i<101)
{
# rtime stores the times of the first bit of a sequence received by dest
rtime[i] = ctime;
if(i!=0){
iat[i] = ctime -rtime[i-1];
}else{
iat[i] = ctime;
}
printf("%d %f\n", i , iat[i]);
i++;

}


}

END{


}
