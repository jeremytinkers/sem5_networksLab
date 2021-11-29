#packet delivery ratio
BEGIN{

pktsend=0;
pktrec=0;
ctime=0;

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
pktrec++;
}
if(e =="+" && (tf_src==1 || tf_src == 2))
{
pktsend++;
}

if(pktsend>0){
printf("%f %f \n", ctime, pktrec/pktsend);
}

}

END{


}
