/1 Store query as well as client handle when new request is received
/2 assign unique id to each new query
/3 Store combination of client handle,query id,query and call back function in master table
/4 Do not automatically send new query to least busy slave, instead only send new query when a slave is free


/ client query signature:
/h(request;callback_function)
/client callback signature:
/callback[qid;query;result]
/example client side callback function:
/callback1:{[qid;query;result]show (qid;query;result);res,:()}
/example client query:
/(neg h)("proc1[`IBM]";"callback1")
/`results insert (qid;query;status;result);} 

queries:([qid:`int$()]
		query:();
		client_handle:`int$();
		client_callback_function:();
		time_received:`time$();
		time_returned:`time$();
		slave_handle:`int$();
		location:`symbol$());

update `u#qid from `queries;		

send_query:{[hdl]
	qid:exec first qid from queries where location=`master;
	/if there is an outstanding query to be sent, try to send it
	if[not null qid;
	query:queries[qid;`query];
	h[hdl],:qid;
	queries[qid;`slave_handle]:hdl;
	queries[qid;`location]:`slave;
	hdl({[qid;query](neg .z.w)(qid;@[value;query;`error])};qid;query)
	];
 };

.z.ps:{[x]
	$[not(w:neg .z.w)in key h;
	/request
	[
	/x@0 - request
	/x@1 - callback_function
	new_qid:1^1+exec last qid from queries; /assign id to new query
	`queries upsert (new_qid;first x;(neg .z.w);last x;.z.T;0Nt;0N;`master);
	/check for a free slave.If one exists,send oldest query to that slave
	if[not 0N=hdl:?[count each h;0];send_query[hdl]];
	];
	/response
	[
	/x@0 - query id
	/x@1 - result
	qid:first x;
	result:last x;
	/try to send result back to client
	.[{[qid;result]
	query:queries[qid;`query];
	client_handle:queries[qid;`client_handle];
	client_callback_function:queries[qid;`client_callback_function];
	client_handle(client_callback_function;qid;query;result);
	queries[qid;`location`time_returned]:(`client;.z.T);
	 };(qid;result);
	{[qid;error]queries[qid;`location`time_returned]:(`client_failure;.z.T)}[qid]];
	/drop the first query id from the slave list in dict h
	h[w]:1_h[w];
	/send oldest unsent query to slave
	send_query[w];
	]];	
 };
 
/TBD
/Reset location of queries outstanding on the dead slave to master and try to resend
.z.pc:{

 };
 
/
PROBLEM - MASTER IS SENDING RESULTS BACK TO WRONG CLIENT WHEN MULTIPLE CLIENT REQUESTS ARE SENT 
 
 
 
 
 
 
 
 
 
 
 
 
/ 