\c 10 100
\C 2000 2000

trade:([]
		time:`time$();
		sym:`symbol$();
		price:`float$();
		size:`int$();
		ex:`symbol$()
 );

quote:([]
		time:`time$();
		sym:`symbol$();
		bid:`float$();
		bsize:`int$();
		ask:`float$();
		asize:`int$();
		ex:`symbol$()
 ); 

/define data 
n:1000000; /n is number of trades
st:09:30t;
et:17t;
portfolio:`IBM`MSFT`GOOG`YHOO
exchanges:(`N;`O;`B;`L);

tdata:(st+n?et-st;n?portfolio;n?100f;n?1000;n?exchanges);
insert[`trade;tdata];

n*:10;
qdata:(st+n?et-st;n?portfolio;n?100f;n?1000;n?100f;n?1000;n?exchanges);
insert[`quote;qdata];

/show"sort trade";
xasc[`time;`trade];
/show"sort quote";
xasc[`time;`quote];


/
Stored procs

There is one important schema difference between the RDB and HDB processes - the HDB tables have a virtual date
column at the start of their schemas. We need to add a date column containing today's date to the RDB tables
before combining the result sets from the 2 DBs.

\

/return all trades for stock s in the last h hours
proc0:{[s;h]
	start_datetime:.z.Z-`datetime$h%24; /calculate the initial datatime based on the current datatime and the value of h
	res:select from 
	(update date:.z.D,datetime:.z.D+time from /add date and datetime columns to the table
	select from trade where sym=s)where
	datetime>=start_datetime;
	res
 } 

/return max price today for input stock s  
proc1:{[s]
	res:() xkey select MAX:max price by sym from trade where sym=s;
	res	
 };

/return max price for input stock s today if the input ed value is today 
proc2:{[s;sd;ed]
	res:0!select MAX:max price by date,sym from 
	(update date:.z.D from 	/add date column to the table
	select from trade where sym=s) where date<=ed;
	res
 };  

/
return the vwap for stock s in the last h hours  
VWAP is sum[price*size]%sum[size]
We will calculate these 2 values and return as a dictionary
\
proc3:{[s;h]
	start_datetime:.z.Z-`datetime$h%24; /calculate the initial datatime based on the current datatime and the value of h
	res:exec NUM:sum price*size,DEN:sum size from 
	(update datetime:.z.D+time from  	/add datetime column to the table
	select from trade where sym=s)where
	datetime>=start_datetime;
	res
 } 
 
 