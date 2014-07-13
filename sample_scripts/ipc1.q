/
ipc1.q simply defines the IPC functions to log messages on the screen of the server process
\

\l taq.q /load in taq.q so the clients can query tables and execute stored procedures



/open
/
Display information about the newly connected client
\
.z.po:{
	show ".z.po";
	show x; /input is the new server side handle to the client
	show .z.w; /this is the callback handle to the client. In .z.po, .z.w and the input are the same
	show .Q.host[.z.a]; /convert and display client's IP address (supplied from incoming list of bytes) to the corresponding host name
	show .z.u; /display  client's username (supplied from incoming list of bytes)
 };
 
/close 
/
The only information on the newly disconnected client is the dead handle to this client
\
.z.pc:{
	show ".z.pc";
	show x; /input is the old server side handle to the disconnected client
 }; 
 
/synch (get)
/
Display information about the received synch message and the client who sent it
Then actually execute the message and return the result.
The result of .z.pg will implicitly be sent back to the client
\

.z.pg:{[x]
	show ".z.pg";
	show x;
	show .z.w;
	show .Q.host[.z.a];
	show .z.u;
	res:value x; /execute the message
	res /return the result
 };
 
/.z.pg:.z.ps:{value x} 
 
/asynch (set) 
/
Display information about the received asynch message and the client who sent it
Then actually execute the message. There is no point returning anything from this function as the result
will not be sent back to the client. This is because the client sent the message asynch.
\
.z.ps:{[x]
	show ".z.ps";
	show x;
	show .z.w;
	show .Q.host[.z.a];
	show .z.u;
	value x; /execute the message
 }; 

 

 