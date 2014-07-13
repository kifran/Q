/load the on disk database

/\l C:/q_work/db1
\l db1

\c 10 150

/return all trades for stock s in the last h hours
proc0:{[s;h]
	start_datetime:.z.Z-`datetime$h%24; /calculate the initial datatime based on the current datatime and the value of h
	start_date:`date$start_datetime; /From this, extract the start date
	res:select from
	(update datetime:date+time from 
	select from trade where date>=start_date,sym=s)where
	datetime>=start_datetime;
	res
 }  

/return max price throughout history for input stock s   
proc1:{[s]
	res:0!select MAX:max price by sym from trade where sym=s;
	res
 };
 
/return max daily price within date range sd to ed for input stock s  
proc2:{[s;sd;ed]
	res:0!select MAX:max price by date,sym from trade 
	where date within (sd;ed),sym=s;
	res
 }; 

/
return the vwap for stock s in the last h hours  
VWAP is sum[price*size]%sum[size]
We will calculate these 2 values and return as a dictionary
\
 
proc3:{[s;h]
	start_datetime:.z.Z-`datetime$h%24; /calculate the initial datatime based on the current datatime and the value of h
	start_date:`date$start_datetime; /From this, extract the start date
	res:exec NUM:sum price*size,DEN:sum size from 
	(update datetime:date+time from 
	select from trade where date>=start_date,sym=s)where
	datetime>=start_datetime;
	res
 }  
