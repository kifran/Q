show "rts1.q";
/q tick/rts1.q [host]:port[:usr:pwd] [host]:port[:usr:pwd]

\e 1

if[not "w"=first string .z.o;system "sleep 1"];

/ get the ticker plant and history ports, defaults are 5010,5012
.u.x:.z.x,(count .z.x)_(":5010";":5012");

/ end of day: save, clear, hdb reload
.u.end:{
	/save tables down to disk
	/value each "delete from `",/:string each system"a"; 
	/close the connection to the old log file
	hclose logfile_handle;
	/create the new logfile
	logfile::hsym `$"rts1_",string .z.D;
	/Initialise the new log file
	.[logfile;();:;()];	
	logfile_handle::hopen logfile;
	};

/intra day update function
upd_trade:{[d]
	d:d lj latest_quote_data;
	`trades_with_asof_quote_data insert d;
	logfile_handle enlist (`replay;`trades_with_asof_quote_data;d);
 };
 
upd_quote:{[d]
	`latest_quote_data upsert select by sym from d;
 }; 

upd:`trade`quote!(upd_trade;upd_quote); 

/Initialise the intra day table schemas
\l tick/TP_schema.q
trades_with_asof_quote_data:update bid:0n,bsize:0N,ask:0n,asize:0N from delete from trade
latest_quote_data:select by sym from quote

/RTS1 log file replay function 

logfile:hsym `$"rts1_",string .z.D

replay:{[t;d]t insert d};

/attempt to replay RTS1 log file
@[{-11!x;show"successfully replayed rts1 log file"};logfile;
	{[e]
	show"failed to replay rts1 log file - assume it does not exist. Creating it now";
	/Initialise the log file
	.[logfile;();:;()];	
	}
 ];


/ open a connection to log file
logfile_handle:hopen logfile
 
/ init schema
.u.rep:{[x;y]
	(.[;();:;].)each x;
	}; 
 
/connect to ticker plant and subscribe to 2 syms for trade and quote tables only
.u.rep .(hopen `$":",.u.x 0)"((.u.sub[`trade;`BA.N`IBM.N];.u.sub[`quote;`BA.N`IBM.N]);`.u `i`L)";

/connect to ticker plant and subscribe to 2 syms for trade table only
/.u.rep .(hopen `$":",.u.x 0)"(enlist .u.sub[`trade;`BA.N`IBM.N];`.u `i`L)";






 