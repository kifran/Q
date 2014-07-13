/*********************************************************************************************************
/
Function:
Summary:
Where is it used:
Input:
Output:
Example Usage:
Line by line description:

\
/*********************************************************************************************************


/*********************************************************************************************************
/
Function: .u.init
Summary: Init stands for initialise. This function executes when the TP starts up.
It has two purposes:
1. Define the list of tables (.u.t) which can be subscribed to
2. Define the dictionary (.u.w) which maps each table name to the related subsriber handle/sym pairs
Where is it used: Executed inside function .u.tick which is first function on the TP to execute
Input:None
Output:None
Example Usage: .u.init[]
Line by line description:
/Get a list of table names
tables`.
/Assign that list to the global variable .u.t
.u.t::
/Get a count (COUNT)of the number of tables
(count .u.t)
/Create a list of size COUNT containing empty lists
(count .u.t)#()
/Create a dict mapping tables names to empty lists
.u.w::.u.t!(count .u.t)#()
\
.u.init:{
	.u.w::.u.t!(count .u.t::tables`.)#()
	};

/*********************************************************************************************************

/*********************************************************************************************************
/
Function:.u.tick
Summary:
This function does the following:
1. Execute .u.init to initialise .u.t and .u.w
2. Verify that all tables on the TP have time,sym as their first two columns, 
otherwise an error is thrown and the TP won't startup.
3.For strictly performance reasons, apply the g attrbute to the sym column of all tables
4. Initialise .u.d to be the current date
5. Execute .u.ld to create TP log file and establish a connection to this file
Where is it used: Executed on standalone file as follows: .u.tick[src;.z.x 1];
Input:2 inputs. 1st Input: name of schema file.2nd Input: directory of log file and HDB
Output:None
Example Usage: .u.tick["TP_Schema";"C:/q_work/data"]
Line by line description:
/Execute .u.init
.u.init[];
/Get list of tables
.u.t
/Pass each table name into a list
()each .u.t
For each table name, reading from the right,
	/Use value function in conjunction with @ form of apply to get data associated with input table
	(value @)each .u.t	
	/flip the table to get the corresponding dictionary
	(flip value @)each .u.t	
	/get keys from dict
	(key flip value @)each .u.t	
	/Take first 2 keys and check they match `time`sym. Return 1b or 0b
	(`time`sym~2#key flip value@)each .u.t
	/Doing this N times where there are N tables results in a list of booleans. Eg: 111b
	/Verify all tables have `time`sym as first 2 columns. Otherwise, throw error '`timesym and real time subsribers won't start up right
	if[not min(`time`sym~2#key flip value@)each .u.t;'`timesym];
	/Apply g attribute to the sym column of each table by using a projection onto the @ form of amend
	@[;`sym;`g#]each .u.t;
	/Initialise .u.d to be the current local date
	.u.d::.z.D;
	/Check there was a schema name specified by verifying the string length of the second input y
	.u.l::count y
	/Initialise .u.l as this string length
	if[.u.l::count y]
	/Initialise .u.L (file descriptor of log file) to be of the form `:path/TP_schemaYYYY.MM.DD
	.u.L::`$":",y,"/",x,10#"."
	/Execute function .u.ld with input of current date in order to create log file and connect to it
	.u.l::.u.ld[.u.d]
\
.u.tick:{[x;y]
	.u.init[];
	if[not min(`time`sym~2#key flip value@)each .u.t;'`timesym];
	@[;`sym;`g#]each .u.t;
	.u.d::.z.D;
	if[.u.l::count y;.u.L::`$":",y,"/",x,10#".";.u.l::.u.ld[.u.d]]
	};

/*********************************************************************************************************

/*********************************************************************************************************
/
Function: .u.ld
Summary: Establish connection to new day's log file
Where is it executed: .u.endofday
Input: new current date .u.d
Output: file handle to new log file.
Example Usage: .u.ld[2012.03.27]
Line by line description:
/Create the name of the new log file and assign to .u.L
.u.L::`$(-10_string .u.L),string x
/Check if the new log file already exists. It shouldn't.
not type key .u.L
/Assuming the new file doesn't exist, initialize the file to contain an empty list
.[.u.L;();:;()]
/Get a count of the number of valid messages in the new log file. It should equal zero
-11!(-2;.u.L)
/Re-initialize .u.i and .u.j to be this zero count
.u.i::.u.j::
/Return handle to new log file
hopen .u.L
\
.u.ld:{
	if[not type key .u.L::`$(-10_string .u.L),string x;.[.u.L;();:;()]];
	.u.i::.u.j::-11!(-2;.u.L);
	hopen .u.L};

/*********************************************************************************************************

/*********************************************************************************************************
/
Function: .u.sub
Summary: This is the function that a real time subscriber (RTS)calls on the TP when it connects and subscribes.
It returns the appropriate empty schemas to the RTS as well as the location and number of messages (.u.i) presently
in the log file. The RTS then replays the first .u.i messages in the log file to get up to speed.
Where is it used:Executed as a result of a remote call from a new real time subscriber (RDB for example)
Input:Two inputs: 1st input:list of table names (or ` if all tables).2nd input: list of syms (or ` if all syms)
First Example Usage: .u.sub[`;`] /subscribe to all tables and for all syms
Second Example Usage: .u.sub[`trade`quote;`IBM`MSFT] /subscribe to trade and quote tables for IBM and MSFT
Output:A pair of the form: (tbl_name;empty_tbl)
Line by line description:
/check if RTS wishes to subscribe to all tables. If so, execute .u.sub N times, where there are N tables on the TP.
/One iteration for each of the N tables
if[x~`;:.u.sub[;y]each .u.t];
/Check if the table the RTS has specified is not present on the TP. If so, throw an appropriate error
/Eg: If there is no table called foo on the TP, the error 'foo would be thrown if the RTS tries to subscribe to foo
if[not x in .u.t;'x];
/.z.w is the callback handle from the TP to the RTS
/Execute the dyadic function .u.del with inputs of the table name (x) and the callback handle .z.w. The purpose of this
/is to clear out this RTS's subscription to the table x if one already exists.
.u.del[x].z.w;
/Set up the new subscriber in the dict .u.w by executing dyadic function .u.add with inputs of table x and list of syms
.u.add[x;y]
\
.u.sub:{[x;y]
	if[x~`;:.u.sub[;y]each .u.t];
	if[not x in .u.t;'x];
	.u.del[x].z.w;
	.u.add[x;y]
	};
/*********************************************************************************************************

/*********************************************************************************************************
/
Function: .u.del
Summary: Used to clear out any pre-existing subscription from the new Real Time Subscriber y to the table x 
within the dictionary .u.w
Where is it used: Executed as part of .u.sub when new RTS connects and subscribes to a table
Input:Two inputs: 1st input (x):table name.2nd input (y): Callback handle to RTS
Output:None
Example Usage: .u.del[`trade;5]
Line by line description:
/Elide into the multi-dimensional dict .u.w to grab a list of all callback handles for the input table x
.u.w[x;;0] /This returns a simple 1-D list of callback handles
/Use the find function (?) to identify the index where the input callback handle (y) occurs
.u.w[x;;0]?y /This will return an atomic integer index like 0
/Use the drop operator (_) to remove the information at that index for the input table x
/Simple example of syntax: d1:`a`b!(10 20;30 40);d1[`a]_:0
.u.w[x]_:.u.w[x;;0]?y 
\
.u.del:{[x;y]
	.u.w[x]_:.u.w[x;;0]?y
	};
/*********************************************************************************************************

/*********************************************************************************************************
/
Function: .u.add
Summary: This function does the following:
1. It appropriately modifies the dictionary .u.w with information on the new subscription (x;y)
2. It returns (ultimately to the RTS) an empty copy of the relevant table (x)
Where is it used:Executed as part of .u.sub when a new RTS connects and subscribes to a table for a list of syms
Input:Two inputs: 1st input:table name.2nd input: list of syms (or ` if all syms)
Example Usage: .u.add[`trade`quote;`IBM`MSFT] /subscribe to trade and quote tables for IBM and MSFT
Output:A pair of the form: (tbl_name;empty_tbl)
where tbl_name is the name of the relevant table (x) and empty_tbl is an empty copy of that table
Line by line description:
/.z.w is the callback handle to the new RTS
/Index into the dict .u.w and use the find function to see if that RTS is currently subscribed to the table x
/Assign index for that RTS to the local variable i.We will need this if the RTS is already subscribed to this table for some syms
i:.u.w[x;;0]?.z.w
/Index into the dict .u.w and count the number of current subscriptions to the table x
count .u.w[x]
/There are 2 cases. 
/Case 1:The RTS is currently subscribed to the table x.
/In that case, (count .u.w[x])>i is TRUE (given behaviour of the find function)
/Case 2:The RTS is NOT currently subscribed to the table x. 
/In that case, (count .u.w[x])>i is FALSE (given behaviour of the find function)
	/Case 1: we need to upsert the (new) syms to the present subsciption list for that RTS/table combination
		/Use the . form of amend to index at depth into .u.w at the relevant table/subscriber index
		/Apply the union function to upsert the new sym list into the existing sym list
		.[`.u.w;(x;i;1);union;y];
	/Case 2:we need to set the new syms as the subscription list for that RTS/table combination
		/Append the singleton pair (call_back_handle;sym list) to the existing .u.w[table] row
		.u.w[x],:enlist(.z.w;y)
	/At this point, we have modified .u.w s required.
	/Now it's time to return an empty copy of the relevant table
	/Grab the table data associated with the table name x
	v:value x
	/I believe the following check is redundant
	99=type v
	/This would only return true, if the table x was keyed. But it is not possible for a table on a TP to be keyed.
	/Therefore, this condition will always return false and we return:
	(x;0#v) /1st element - table name. 2nd element - empty copy of table
	
\
.u.add:{[x;y]
	$[(count .u.w[x])>i:.u.w[x;;0]?.z.w;
	.[`.u.w;(x;i;1);union;y];
	.u.w[x],:enlist(.z.w;y)
	];
	(x;$[99=type v:value x;.u.sel[v]y;0#v])
	};
/*********************************************************************************************************

/*********************************************************************************************************
/
Function: .u.sel
Summary:This table returns the appropriate subset of rows from a table x based on sym list y
Where is it used: Inside function .u.pub to grab subset of table that the RTS cares about
Input:Two inputs: 1st input:full contents of table (x).2nd input: list of syms (or ` if all syms) (y)
Output:Subset of table x that RTS care about
Example Usage: .u.sel[select from trade;`IBM`MSFT]
Line by line description:
/Check if y~`. If this is the case, the RTS has subscribed to all syms and we should return all rows of table x
/If this is not the case, we should only return the rows for the syms y
$[`~y;x;select from x where sym in y]
\
.u.sel:{[x;y]
	$[`~y;x;select from x where sym in y]
	};
/*********************************************************************************************************

/*********************************************************************************************************
/
Function: .u.pub
Summary:This function publishes out the relevant rows of the input table to all of the interested Real Time Subscribers.
Where is it used: Within .z.ts (if publishing on timer) or else in .u.upd (if publishing on every new update)
Input: 2 inputs. First input: Table Name. Second input: Current contents of table
Output:
Example Usage: .u.pub[`trade;select from trade where time within (.z.T-00:00:01t;.z.T)] /publish trades in last second
Line by line description:
/Define an anonymous triadic function which takes the following three inputs:
/1st input:table name
/2nd input:contents of table
/3rd input:a pair of the form (hdl;syms) where hdl is a hdl to a RTS and syms is the list of syms that RTS is interested in
/Fix the 1st and 2nd inputs (monadic projection)and for the 3rd input,loop over all the pairs associated with that table
{[t;x;w]}[t;x]each .u.w[t]
	/select the rows we care about from the table and assign those rows to x
	x:sel[x]w 1
	/Check if there are any rows
	if[count x]
	/If there are rows, send them in an asynch message to the RTS
	/The message has the format (upd;tbl_name;tbl_data). So the RTS needs a dyadic function called upd defined
	(neg first w)(`upd;t;x)
\
.u.pub:{[t;x]
			{[t;x;w]
				if[count x:sel[x]w 1;(neg first w)(`upd;t;x)]
			}[t;x]each .u.w[t]
		};
/*********************************************************************************************************


/*********************************************************************************************************
/
Function:.u.end
Summary: Send asynch message to all subscribers telling them to execute their .u.end function 
with yesterday's date as input
Where is it used:.u.endofday
Input: Yesterday's date
Output:None
Example Usage: .u.end[2012.03.27]
Line by line description:
/Index at depth into dict .u.w to isolate client handles
.u.w[;;0]
/Modify union function with the over adverb to get a distinct list of client handles
union/[]
/Make client handles asynch
neg[]
/We wish to send an asynch message to each subscriber telling the subscriber to execute their function
/.u.end with yesterday's date as input
(`.u.end;x)
/Modify the @ form of apply with the each left adverb to actually send the messages across the asynch handles
@\:
\
.u.end:{
	(neg union/[.u.w[;;0]])
	@\:
	(`.u.end;x)
	};
/*********************************************************************************************************

/*********************************************************************************************************
/
Function:.u.endofday
Summary:Perform the following EOD processing:
	1. Send identical message to all subscribers telling them to execute their EOD function .u.end
	2. Increment current date .u.d
	3. Close connection to old log file and establish connection to new log file
Where is it used: Executed inside .u.ts iff we have gone past EOD
Input:None
Output:None
Example Usage: .u.endofday[]
Line by line description:
/Send message to all subscribers telling them to execute their EOD function
.u.end[.u.d];
/Increment current date .u.d
.u.d+:1;
/Check if we are still connected to the old log file
if[.u.l;]
/Iff we are still connected (this should be the case): 
	/close that connection
	hclose .u.l
	/Create connection to new log file
	.u.ld[.u.d]
	/Assign new connection to variable .u.l
	.u.l::
\
.u.endofday:{
	.u.end[.u.d];
	.u.d+:1;
	if[.u.l;hclose .u.l;.u.l::.u.ld[.u.d]]
	};	
/*********************************************************************************************************

/*********************************************************************************************************
/
Function:.u.ts
Summary:This functions checks to see if we have gone past midnight
Where is it used: Within the timer function .z.ts
Input: The (new)current date
Output:None
Example Usage:.u.ts[.z.D]
Line by line description:
/check to see if the input (current date) exceeds the flag .u.d
if[.u.d<x]
	/If so, check for unlikely event that yesterday>flag .u.d. This shouldn't be the case. If it is the case, turn off timer and throw error.
	/Execute EOD function
	.u.endofday[]
\
.u.ts:{[x]
	if[.u.d<x;
		if[.u.d<x-1;system"t 0";'"more than one day?"];
		.u.endofday[]]
	};
/*********************************************************************************************************


/*********************************************************************************************************
/
Function: .z.ts (definition iff the timer was set on startup. In this case, we publish on the timer)
Summary: This is the standard timer function, executed on a pre-defined hearbeat frequency.
	It does the following
	1. Publish relevant updates to interested subscribers
	2. Clear out the tables
	3. Set .u.i to have value of .u.j
	4. Check if we have gone past EOD.
Where is it used: It will execute every N milliseconds where N is defined at the startup of the tickerplant process
Input:Current Timestamp
Output: None
Line by line description:
/return the tables associated with the table names .u.t
value each .u.t
/modify the dyadic function .u.pub with the each both adverb
.u.pub'[]
/Then loop over the combinations of table name/table data. This will publish the relevant updates to interested subscribers
.u.pub'[.u.t;value each .u.t]
/For each table name in .u.t:
	/Create empty copy of table
	0#
	/Use amend to apply `g attribute to the sym column of the empty table copy
	@[;`sym;`g#]
	/Assign the empty table (with g attribute set on sym column) back to default namespace using amend
	@[`.;.u.t;];
/Set .u.i to have value of .u.j
.u.i::.u.j;
/Check if we have gone past EOD
.u.ts[.z.D]	
\
.z.ts:{
	.u.pub'[.u.t;value each .u.t];
	@[`.;.u.t;@[;`sym;`g#]0#];
	.u.i::.u.j;
	.u.ts[.z.D]
	};
/*********************************************************************************************************

/*********************************************************************************************************
/
Function: .u.upd (definition iff the timer was set on startup. In this case, we publish on the timer, NOT in .u.upd)
Summary: This function does the following:
	1. Prepend current time to incoming data as necessary
	2. Insert data into Tickerplant table
	3. Write message to log file
	4. Increment message counter .u.j by one
Where is it used: Executed every time a message is received from the feedhandler
Input: 2 inputs. First input: Table Name. Second input: new data
Output: None
First Example Usage (Single row update): .u.upd[`trade;(09:30:00.000;`IBM;100.3;50)]
Second Example Usage (Bulk update): .u.upd[`trade;(09:30:00.001 09:30:00.002;`IBM`MSFT;100.3 65.7 ;50 60)]
Notes: This function supports both single row and bulk (multi-row) updates
Line by line description:
/Look at the type of the first element of the incoming data. The first element will either be an atom (single row update case) 
/or a homogenous list (bulk update case). (Hence the two invocations of first).
/In either case, check if it is of type time
-19=type first first x;
/IF the data does not contains time as the first element:
if[not -19=type first first x;
		/Capture the current datetime as a local variable called a.This will serve as the received time for the data
		a:.z.Z
		/Check if the current date exceeds .u.d. If it does,that means we have just passed midnight.
		/therefore execute the timer function .z.ts which will 
		/publish the data and run the EOD function
		if[.u.d<"d"$a:.z.Z;.z.ts[]];
		/Cast the local variable a from datetime to time
		a:"t"$a;
		/It's now time to prepend the received time to the data. There are 2 cases to check for.
		/Check if the first element is an atom (case 1), or a list (case 2)
		$[0>type first x]
		/Case 1 - single row update => prepend the atomic received time to the data and save as x
		x:$[true;a,x]
		/Case 2 - bulk update => 
			/calculate row count (COUNT) of incoming data
			(count first x)
			/Create COUNT copies of received time
			(count first x)#a
			/Turn into a singleton and prepend to bulk data
			(enlist(count first x)#a),x
			/save as local variable x
			x:$[false;(enlist(count first x)#a),x]
			
/Now the first element of the data is time - either incoming time or else tickerplant received time
/Insert the data into the TP table
t insert x;
/Check if we are connected to the TP log file
if[.u.l]
/If we are connected:
	/write a message to the log file. This message will be such that a process 
	/(Real time database for example) when they reply the log file, will execute
	/a dyadic function called upd with two inputs: table name and data
	.u.l enlist (`upd;t;x)
/Increment message counter .u.j by one	
	.u.j+:1
\
.u.upd:{[t;x]
	if[not -19=type first first x;
		if[.u.d<"d"$a:.z.Z;.z.ts[]];
		a:"t"$a;
		x:$[0>type first x;a,x;(enlist(count first x)#a),x]
	];
	t insert x;
	if[.u.l;.u.l enlist (`upd;t;x);.u.j+:1];
 
	}
/*********************************************************************************************************
	
	
/*********************************************************************************************************	
/
Function: .z.ts (definition iff timer was NOT set at startup - set frequency at one second)
Summary: Every second, execute the function .u.ts to check for EOD
Input:Current Timestamp
Output: None
Line by line description:
/Execute function .u.ts with the (new) current date as input
.u.ts[.z.D]
\
.z.ts:{.u.ts[.z.D]};
/*********************************************************************************************************

/*********************************************************************************************************
/
Function:.u.upd (definition iff the timer was NOT set on startup. In this case, we publish in .u.upd)
Summary:If the TP was not started with the timer enabled, this is considered low latency mode in the 
sense that we will publish data as soon as it is received, as opposed to bulking up updates for a period of time

This function does the following:
	0. Execute the function .u.ts to check for EOD
	1. Prepend current time to incoming data as necessary
	
	3. Write message to log file
	4. Increment message counter .u.j by one
Where is it used: Executed every time a message is received from the feedhandler
Input: 2 inputs. First input: Table Name. Second input: new data
Output: None
First Example Usage (Single row update): .u.upd[`trade;(09:30:00.000;`IBM;100.3;50)]
Second Example Usage (Bulk update): .u.upd[`trade;(09:30:00.001 09:30:00.002;`IBM`MSFT;100.3 65.7 ;50 60)]
Notes: This function supports both single row and bulk (multi-row) updates
Line by line description:
/Capture the current datetime as a local variable called a.This will serve as the received time for the data
a:.z.Z
/Execute .u.ts to check if we have ust gone past midnight. If so, EOD functionality will execute
.u.ts["d"$a:.z.Z];
/Look at the type of the first element of the incoming data. The first element will either be an atom (single row update case) 
/or a homogenous list (bulk update case). (Hence the two invocations of first).
/In either case, check if it is of type time
-19=type first first x;
/IF the data does NOT contains time as the first element:
if[not -19=type first first x;		
		/Cast the local variable a from datetime to time
		a:"t"$a;
		/It's now time to prepend the received time to the data. There are 2 cases to check for.
		/Check if the first element is an atom (case 1), or a list (case 2)
		$[0>type first x]
		/Case 1 - single row update => prepend the atomic received time to the data and save as x
		x:$[true;a,x]
		/Case 2 - bulk update => 
			/calculate row count (COUNT) of incoming data
			(count first x)
			/Create COUNT copies of received time
			(count first x)#a
			/Turn into a singleton and prepend to bulk data
			(enlist(count first x)#a),x
			/save as local variable x
			x:$[false;(enlist(count first x)#a),x]
/Now the first element of the data x is time - either incoming time or else tickerplant received time
/Grab the list of column names from the schema of the incoming table name t and assign to local variable f
f:key flip value t;
/It is now time to publish the data. However, we must first transform the data x into a table. We do this
/in one of two ways depending on whether it is a single row update (Case 1) or a bulk update (Case 2)
/Check if data x is a single row update
$[0>type first x;]
	/Case 1 - single row update
	/Create dictionary by combining column names f with data x
	f!x
	/enlist to make it a list of dictionaries (table)
	enlist f!x
	/execute publish function with table name t and data table
	pub[t;enlist f!x]
	/Case 2 - bulk update
	/Create rectangular dictionary by combining column names f with data x
	f!x
	/flip rectangular dictionary to make a table
	flip f!x
	/execute publish function with table name t and data table
	pub[t;flip f!x];
	/Check if we are connected to the TP log file
if[.u.l]
/If we are connected:
	/write a message to the log file. This message will be such that a process 
	/(Real time database for example) when they reply the log file, will execute
	/a dyadic function called upd with two inputs: table name and data
	.u.l enlist (`upd;t;x)
/Increment message counter .u.j by one	
	.u.j+:1
\	
.u.upd:{[t;x]
	.u.ts["d"$a:.z.Z];
	if[not -19=type first first x;
	a:"t"$a;
	x:$[0>type first x;a,x;(enlist(count first x)#a),x]];
	f:key flip value t;
	pub[t;$[0>type first x;enlist f!x;flip f!x]];
	if[l;l enlist (`upd;t;x);i+:1];
	};
/*********************************************************************************************************	

/*********************************************************************************************************
/
Function:
Summary:
Where is it used:
Input:
Output:
Example Usage:
Line by line description:

\
/*********************************************************************************************************

	
	
	
	
	