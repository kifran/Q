/
ipc3.q extends ipc2.q so that the server process also maintains a table listing details 
of all synch/asynch messages received by the server process
\

\l taq.q
\c 10 140

/
we can make the handle column the primary key of current_connections since the handle uniquely
identifies the connection for the duration of the connection
\
current_connections:([handle:`int$()]
				time_of_connect:`datetime$();
				user:`symbol$();
				IP_address:();
				host:`symbol$();
				number_of_messages:`int$());

requests:([]
			time:`datetime$(); /datetime the request was received
			request:(); /the actual request. This column will contain strings, lists etc so don't cast
			user:`symbol$(); /username of the client who sent in the request
			host:`symbol$(); /hostname of the client who sent in the request
			IP_address:(); /IP address of the client who sent in the request
			duration:`time$(); /amount of time the request took to run
			success:`boolean$(); /was the request completed successfully - true for yes. False for no
			synch_assynch:`symbol$() /was the request sent synch or asynch
 );
				
.z.po:{[h]
		`current_connections upsert 
		(h;.z.Z;.z.u;`int$0x00 vs .z.a;.Q.host[.z.a];0)
 };				
 
 .z.pc:{[h]
		delete from `current_connections where handle=h;
	};
	
.z.pg:{[m]
	update number_of_messages+1 from `current_connections
	where handle=.z.w;
	st:.z.Z; /capture the datetime just before the server attempts to run the request
	/run the request in a try/catch.
	/If request runs without error, res contains (1b;result)
	/If server encounters error while running request, res contains (0b;error message)
	res:@[{[i](1b;value i)};m;{[e](0b;e)}];
	et:.z.Z; /capture the datetime just after the server attempted to run the request
	success:res[0]; /true or false
	result:res[1]; /result or error message
	/insert a row into the requests table
	/et-st is a fraction of a day. Duration column is of type time (integer number of milliseconds)
	/Therefore scale (et-st) by number of milliseconds in one day and cast to time
	`requests insert
	(st;m;.z.u;.Q.host[.z.a];`int$0x00 vs .z.a;
	`time$(24*60*60*1000)*et-st;success;`synch);
	result
 };	

.z.ps:{[m]
	update number_of_messages+1 from `current_connections
	where handle=.z.w;
	st:.z.Z;
	res:@[value;m;{`ERROR}];
	et:.z.Z;
	$[`ERROR~res;success:0b;success:1b];
	`requests insert
	(st;m;.z.u;.Q.host[.z.a];`int$0x00 vs .z.a;
	"t"$(24*60*60*1000)*et-st;success;`asynch);
 };	










