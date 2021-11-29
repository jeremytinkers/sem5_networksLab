# avg delivery delay
BEGIN{


pksend=0;
pkrec=0;
ctime=0;
tdelay=0;

}
{

e=$1;
#Trace File current destination
tf_dest=$4;
#Trace File current source 
tf_src=$3;
ctime=$2

if(e =="r" && (tf_dest==9 || tf_dest==10))
{
tdelay+= ctime - stime[$11];
}
if(e =="+" && (tf_src==1 || tf_src == 2))
{
stime[$11]= ctime;
}

printf("%f %f \n", ctime, (tdelay/ctime));

}

END{


}
