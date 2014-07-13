/
ipc2.q defines the IPC functions so that the server process maintains a table detailing the 
currently open connections on the server process 
\
\l taq.q

current_connections:([]
		time:`time$(); /time connection was made
		handle:`int$(); /server side handle back to client
		user:`symbol$(); /username of client
		host:`$(); /host name of client
		IP:(); /IP address of client. this column will contain lists of integers. Therefore do not cast 
		number_messages:`int$() /number of messages sent through this connection
 );

/insert a row into the current_connections table with client information 
.z.po:{
	`current_connections insert (.z.T;.z.w;.z.u;.Q.host[.z.a];`int$vs[0x00;.z.a];0);
 }; 

/delete the appropriate row from the table 
.z.pc:{
	delete from `current_connections where handle=x;
 }; 

/increment the number_messages field by one for the appropriate row 
.z.pg:{
	update number_messages+1 from `current_connections where handle=.z.w;
	res:value x;
	res
 }; 

/increment the number_messages field by one for the appropriate row  
.z.ps:{
	update number_messages:number_messages+1 from `current_connections where handle=.z.w;
	value x;
 }; 

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
/ 