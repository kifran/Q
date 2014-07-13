/
There are 3 scripts that make up this gateway example.
gw1.q - main process which connects to the RDB and the HDB processes
hdb.q - process which kicks off the HDB
rtd.q - process which kicks off the RDB

HDB has access to an on disk TAQ date partitioned database
RDB is an in memory real time TAQ database
\

/
Use protected execution to attempt to connect to the RDB and HDB
If either connection attempt fails, the gateway will terminate
\
hr:@[{hopen x};5001;{[p;e]show"cannot connect to RTD on port ",-3!p;exit 0}[5001;]];

hh:@[{hopen x};5002;{[p;e]show"cannot connect to HDB on port ",-3!p;exit 0}[5002;]];

/
Define stored procedures for accessing the tables on each database and combine the results in
a meaningful way. The stored procs increase in complexity as you move from proc0 to proc3
\


/return all trades for stock s in the last h hours
/sample usage: proc0[`IBM;10]

proc0:{[s;h]
	res_rtd:hr("proc0";s;h);
	res_hdb:hh("proc0";s;h);
	res:res_rtd upsert res_hdb;
	res
 };


/return max price throughout history for input stock s
/sample usage: proc1[`IBM]

proc1:{[s]
		res_rtd:hr("proc1";s);
		res_hdb:hh("proc1";s);
		res:res_rtd,res_hdb;
		res:select max MAX by sym from res;
		res
 };
/return max daily price within date range sd to ed for input stock s 
/sample usage: proc2[`IBM;2011.01.01;.z.D]

proc2:{[s;sd;ed]
	res_rtd:hr("proc2";s;sd;ed);
	res_hdb:hh("proc2";s;sd;ed);
	res:res_rtd,res_hdb;
	res
 };

/
return the vwap for stock s in the last h hours 
This stored proc uses a map reduce approach to efficeintly calculate the vwap over the last h hours
VWAP is sum[price*size]%sum[size]
We will calculate both the numerator and denominator separately on both databases then sum the results and divide
This approach is efficient because it means only a small amount of data will be transmitted over the network. It is
a good idea to run calculations locally and transmit (small) result sets across the network
\
/sample usage: proc3[`IBM;100]

proc3:{[s;h]
	res_rtd:hr("proc3";s;h);
	res_hdb:hh("proc3";s;h);
	res:(res_rtd[`NUM]+res_hdb[`NUM])%(res_rtd[`DEN]+res_hdb[`DEN]);
	res:(`sym`vwap`hours)!(s;res;h);
	enlist res
	};

 










/

