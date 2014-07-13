/
This client will connect to the master process and send a query
sample usage:q client.q -sym IBM -master 5000

\

args:.Q.opt[.z.x];
args[`sym]:first`$args[`sym];
args[`master]:first"I"$args[`master];

/res will be a list containing all the result sets
res:(); 

/define asynch message handling function so that the client process knows what to do with the
/result sent by the master process
.z.ps:{
	show"result received";
	show x;
	res,:x;
 };
 
h:neg hopen args[`master];
 
/send the request to the master process asynch 
h(`proc1;args[`sym])

 
