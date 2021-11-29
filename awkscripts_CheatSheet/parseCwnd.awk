#parse for cwnd, assignment2 , q2
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
