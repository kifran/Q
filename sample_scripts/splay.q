\l taq.q

/
As discussed, tables with symbols must first be enumerated prior to being saved to disk in splayed format.
However, if the table doesn't contain any symbol columns it can be saved to disk in splayed format directly. 
\

/Example 1
q1:delete sym,ex from quote; /table q1 has no symbol columns
set[`:db/splay1/;q1]; /save down in splayed format

/Example 2
q2:update string sym,string ex from quote; /table q2 has no symbol columns
set[`:db/splay2/;q2]; /save down in splayed format

/Enumerate columns manually

x:distinct raze value exec sym,ex from quote;

q3:update `x$sym,ex:`x$ex from quote; /table q3 has no symbol columns

set[`:db/splay3/;q3]; /save down in splayed format
set[`:db/x;x]; /save enumerations as a single binary file sitting at the top of db. This file will be loaded when db starts
\
/Use high level enumeration function .Q.en
/e:.Q.en[`:db;quote];  /Replace symbol columns with enumerations against sym file. Append new symbols to sym file as appropriate

/set[`:db/quote/;e]; /Save enumerated table to disk in splayed format
/
/set[`:db/quote/;.Q.en[`:db;quote]];

/
The following function could be used as part of the end of day job on the real time database
On day 1, there is no splayed table on disk, therefore save in memory table to disk in splayed format
On subsequent days, append in memory table to the existing splayed table on disk
\

eod_splay:{
	$[`quote in key `:db; /check for existence of splayed table on disk
	[show"append";
	upsert[`:db/quote;.Q.en[`:db;quote]];
	];
	[
	show"create";
	set[`:db/quote/;.Q.en[`:db;quote]];
	]
	];
 };
 
eod_splay[];
/
/Read

/we can load into memory individual column files if we wish
col_names:get[`:db/splay1/.d];
times:get[`:db/splay1/time];
sizes:get[`:db/splay1/size];
prices:get[`:db/splay1/price];

/Typically however, we just laod in the database and run qSQL queries against the splayed tables
\l db

/Example 1:
select bid from quote where i=4

/When this query executes, q will memory map the bid file and load into physical memory just the 5th bid.
/Therefore the memory footprint from this query is miniscule.

/Example 2:
select max bid from quote where i<100

/When this query executes, q will memory map the bid file and load into physical memory just the first 100 bids.
/Q will then aggregate this in memory list of 100 bids.

/Example 3:
select max bid from trade where sym=`IBM

/Let's assume the sym column on disk has no attributes associated with it (default behaviour).
/When this query executes, q will memory map the sym file and then load all it's contents into physical memory.
/Q then figures out the indices that correspond to `IBM. Q then maps the bid file and applies the resultant row indices
/to the bid file. The resultant bids are loaded into physical memory and aggregated.








/