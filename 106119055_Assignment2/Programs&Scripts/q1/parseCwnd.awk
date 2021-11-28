#parse for cwnd
BEGIN{

rcvsize=0;
ctime=0;

}
{

ctime=$1
cwnd=$7

printf("%f %f \n", ctime, cwnd )
}

END{

}
