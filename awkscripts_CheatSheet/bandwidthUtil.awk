#bandwidth utilization
BEGIN{

rcvsize=0;
ctime=0;

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
rcvsize+=$6;
}


printf("%f %f \n", ctime,(8*rcvsize)/(1000000));


}

END{


}
