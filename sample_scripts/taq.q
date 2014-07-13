/
This scripts creates unkeyed tables. An unkeyed table is a table which 
does not have a primary key.
All unkeyed tables have a type of 98h 

Under the surface, an unkeyed table is a flipped dictionary.
Example 1:
d0:`c1`c2`c3`c4!(1 2 3;"ABC";`a`b`c;1.2 3.4 5.6)
t0:flip d0;
d0~flip t0

Example 2:
t1:([]c1:1 2 3;c2:`a`a`b;c3:"QWE";c4:10 20 30)

There are 3 ways of accesing data in an unkeyed table:

1. qSQL - select, exec, update and delete
2. Dictionary of lists
eg:
t1.c1
t1[`c1]
t1[`c1]+:10

3. List of dictionaries
eg:
first t1
last t1
t1[0 1 2]
2#t1
-2_t1
distinct t1
3?t1
?[t1;`c1`c2`c3`c4!(1;`a;"Q";10)]
\

/-3! is a shortcut function which transforms the input into a string
show"taq.q entered at time: ",.Q.s1[.z.T]

/set console and web browser display parameters
\c 10 100
\C 2000 2000

/define empty schema for the in memory, historical trade table
/For each column, we cast an empty list to a given datatype
/The first line should not be indented. All other lines (including the last line)must be indented at least one space
/The spacing doesn't need to be uniform
trade:([]
		date:`date$();
		time:`time$();
		sym:`$(); 
		price:`float$();
		size:`int$();
		ex:`$() 
	);

a:10; 
 
f1:{[i]
	r1:i*i;
	r2:i-10;
	show"hello";
	r3:i%10;
	::
 };
 
/define empty schema for the in memory, historical quote table
quote:([]
		date:`date$();
		time:`time$();
		sym:`symbol$();
		bid:`float$();
		bsize:`int$();
		ask:`float$();
		asize:`int$();
		ex:`$()
 ); 

/define data for the trade and quote tables
n:1000; /n is number of trades
st:09:30t; /start time
et:17t; /end time
portfolio:`IBM`MSFT`GOOG`YHOO; /list of stocks we trade
/portfolio:{`$x}each string til 21
/m:portfolio!`IBM`MSFT`GOOG`YHOO`UBS`RBC`CITI,-14?`3
exchanges:(`N;`O;`B;`L); /list of exchanges
dts:.z.D-til 10; /historical data will span the last N dates
dts:dts where not(dts mod 7)in 0 1;

/2 dimensional, column orientated list of trade data
/st+n?et-st will generate n times between st and et
tdata:(n?dts;st+?[n;et-st];n?portfolio;n?100f;n?1000;n?exchanges);
/insert the data into the trade table by reference (`trade, NOT trade)

insert[`trade;tdata];

/if the data is a table (as opposed to a list), we could insert a subset of columns
/insert[`trade;delete date,ex from trade];

n*:10; /scale n by 10 in place. We want 10 times as many quotes as trades
/2 dimensional, column orientated list of quote data
qdata:(n?dts;st+n?et-st;n?portfolio;n?100f;n?1000;n?100f;n?1000;n?exchanges);
/insert the data into the quote table by reference
insert[`quote;qdata];

/sort the trade table initally on time and then resort resultant table by date
/net result is a table which is in absolute terms, sorted by date with a sub sort on time
/Graphing the dates would result in a step function
/Graphing the times would result in a saw tooth function 
xasc[`date`time;`trade];
xasc[`date`time;`quote];

/Following 2 lines are equivalent. The backslash and key word system are equivalent
/Load script keyed.q from current working directory
\l keyed.q
/system"l keyed.q"  

/more complicated sort. Here we pass trade by value instead of by reference.
/xasc and xdesc are in built dyadic functions defined in the .q namespace.
/As such, they can be executed using in line notation
/Resultant table is saved in the variable x
x:`date xasc `sym xdesc `ex xasc `time xasc trade

/This sort is modifying trade by reference
/`date xasc `sym xdesc `size xasc `time xdesc `trade

/First stored procedure
/A stored procedure is a function with an underlying query
/Say following about qSQL
/
Any select statement produces a newtable
3 components to a qSQL select statement - where clause (constraint), by clause (grouping), aggregation clause
Only required words are select, from and table
Where clause: 
	- Where clause is first thing to execute in qSQL
	- if multiple where clauses are present, they execute from left to right
	- the comma which separates the different where clauses is logical and
	  i.e a row will only make it through the where clauses if it meets every condition
	- The left most where clause looks at all rows in a column
	-the subsequent where clauses only look at the rows in a column that need to be looked at
	based on the previous where clauses. We can imagine each clause passes a smaller list of indices 
	to the right
	- For performance reasons, the left most where clause should be the most restrictive where clause
	  This is because we want to cut down the amount of data that needs to be analysed as much as possible
	  and as quickly as possible	
	-logical or is possible, but need to wrap up constraints in parentheses
	eg: select from trade where (sym=`MSFT)or(ex=`N)or(time<11t)
	If you don't, query will fail
	eg: 
	 q)select from trade where ex=`N or time<11t
	'type 
By clause: 
	-The by cluase takes the remaining rows which survived the where clause and groups them into sub tables
	-Each of these sub tables are then passed in turn into the aggregation clause
	-We can group on as many columns as we wish
	-The resultant table will be sorted in ascending order on the grouped columns
	-The grouped columns form the primary key of the table
	-The by cluase is from a timing and memory perspective, the most expensive part of the query	
	-The more granular the grouping, the longer the query will take to run
	
Aggregation clause:
	-You can have as many aggregations as you wish
	-You can use either the built in aggregation functions or your own user defined aggregations
	eg:
	agg1:{[p](max p)-(min p)}
	select RES1:agg1[price],RES2:avg[price] by sym from trade
	-Each aggregation results in a new column in the resultant table
	-You cannot label a resultant column from an aggregation using a built in function name
	For example, the following will not succeed:
	q)select avg:avg[price] by sym from trade
	'assign
	But the next query is ok because AVG is not a built in function. Q is always case sensitive
	select AVG:avg[price] by sym from trade	
\

/
	proc1 filters on stock and time
	proc1 runs various aggregations against data grouped by date,hour combination
	The resultant table is then explicitely sorted in ascending order on hour and then saved as a local 
	variable called res1.
	res1 is then returned from the function
\

f1:{[x;y](max x),min y};

proc1:{[s]
	res:
	select MAX:f1[price;size],MIN:min[price],AVG:avg[price],VWAP:wavg[size;price],
	DEV:dev[price],VAR:var[price],OPEN:first[price],CLOSE:last[price] 
	by DATE:date,hour:`hh$time from trade 
	where sym=s,time within (10t;13t);
	:res
	};
 
\t res1:proc1[`IBM] 

/sector is a dictionnary mapping stocks to their business sectors
sector:`IBM`MSFT`GOOG`YHOO`GS`CITI`BARC!
	`IT`TECH`SEARCH`SEARCH`FINANCE`FINANCE`FINANCE;	

/function f takes 2 inputs - p is a list of prices. t is a list of times
/This function calculates the indices of the min and max times
/It then applies these indices to the price list
/This results in the opening and closing prices
/The opening and closing prices are then returned from the function	
f:{[p;t]
	i_max:last where t=max t;
	i_min:first where t=min t;
	p[(i_min;i_max)]
	};

/proc2 explanation
/
	Inputs: a list of stocks (s) and a single exchange (e)

	Where clause:
	proc2 filters on stock and exchange. It also filters out any rows with a null price
	
	By clause:
	proc2 runs various aggregations against data grouped by date,5 minute,sector combinations
	proc2 demostrates that we can use a dictionary lookup in a query to group on data not 
	actually present in the table. i.e there is no sector column in trade but we can still group on sector
	
	Aggregation clause:
	We are assuming that first[price] and last[price] return the opening and closing prices respectively
	This is only a valid assumption if 2 conditions are met:
	1. The original table had been sorted in ascending order by time
	2. The data was grouped in such a way as to maintain the sorting on time for each sub table
	Both these conditions are met in this case.
	However the function f is a way to calculate opening and closing prices in general (if above 2 conditions are not met)
	
	The resultant table is explicitely sorted in descending order on sector and then sorted ascending order on time
	This resultant table is then saved as a local variable called res1.
	res1 is then returned from the function
\
	
proc2:{[s;e]
	:select MAX:max[price],MIN:min[price],AVG:avg[price],
	VWAP:wavg[size;price],
	DEV:dev[price],VAR:var[price],COUNT:count i,OPEN:first[price],
	CLOSE:last[price],OC:f[price;time] 
	by date,time:xbar[5*60*1000;time],SECTOR:sector[sym] from trade 
	where ((sym in s)or(ex=e)),not price=0n;
 };

/inputs are first 5 stocks in portfolio (s) and `N (e) 
show"proc2";
\t res2:proc2[5 sublist portfolio;`N] 

/
	If there are no rows for a given date,5 minute,sector combination, then there will be no row
	for this group in the resultant table
	The 3 lines of code below demonstrate one way of programatically adding these null rows
	First step - build a list of all the 5 minute intervals in our trading day
	Second Step - use 2 iterations of the cartesian cross product function to get all the
	possible combinations of date,5 minute and sector
	This results in a column oritentated list which we turn into a dictionary
	This dictionary is then flipped into a table which we assign to x
	A left outer join is then performed between x and the result of proc2
	The resultant table res3 now has all the desired rows 
\

times:st+(00:05t)*til`int$(et-st)%(00:05t);
x:flip `date`time`SECTOR!flip cross[cross[dts;times];distinct value sector];
res3:lj[x;res2];


/2 different ways of achieving the same thing
/
Problem - increment the column c2 by 1 for all the rows where c1 has the value `c
Methods 1 and 2 are equivalent
Both methods have similar performance
Method 1 uses the qSQL update function to solve the problem
Method 2 is more complicated:
	-We treat the table as a dictionary of lists (where t1[`c1]=`c) to return the row indices 
	 we care about
	-We then treat the table like a list of dictionary (t1[where t1[`c1]=`c;`c2]) 
	 to modify the column c2 at particular rows
\
t1:([]c1:`a`b`c`c`b;c2:1 2 3 4 5)
/1
update c2+1 from `t1 where c1=`c 
/2
t1[where t1[`c1]=`c;`c2]+:1
/
/xcol function is used to rename the columns of a table
trade:xcol[`DATE`TIME`sym`price`SIZE;trade]

/xcols function is used to reorder the columns of a table
trade:xcols[`sym`price;trade] 

/cols function will return the list of column names in a table
c:cols trade

