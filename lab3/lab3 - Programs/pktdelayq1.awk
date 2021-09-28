BEGIN{


pksend=0;
pkrec=0;
ctime=0;
tdelay=0;

}
{

e=$1;
dest=$4;
src=$3;
ctime=$2
if(e =="r" && (dest==5 || dest==4))
{
tdelay+= ctime = stime[$11];
}
if(e =="+" && (src==1 || src==2))
{
stime[$11]= ctime;
}

printf("%f %f \n", ctime, tdelay);

}

END{


}
