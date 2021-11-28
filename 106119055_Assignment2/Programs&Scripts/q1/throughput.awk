#throughput
BEGIN{
rcvsize=0;
ctime=0;
}

{
e=$1;
#Trace File current destination
tf_dest=$4;

ctime=$2
if(e =="r" && tf_dest==1)
{
rcvsize+=$6;
}

}

END{
printf("Throughput:  %f \n", (8*rcvsize)/(100000 * ctime));
}
