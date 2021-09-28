BEGIN{


pktsend=0;
pktrec=0;
ctime=0;

}
{

e=$1;
dest=$4;
src=$3;
ctime=$2
printf("\n %f", ctime );
if(e =="r" && (dest==5 || dest==4))
{
pktrec++;
}
if(e =="+" && (src==1 || src==2))
{
pktsend++;
}

if(pktsend>0){
printf("%f %f \n", ctime, (pktsend -pktrec));
}

}

END{


}
