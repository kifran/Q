/\P 5

\c 20 90
\C 2000 2000

daily_returns:([]
				date:`date$();
				ticker:`$();
				usd_return:`float$()
				); 
 
/define data 
portfolio:`IBM`MSFT`GOOG`YHOO`VOD`BARC`CITI`GS`BA`BP`BOI`AIB;
dts:.z.D-til 20000;

c:`date`ticker!flip(dts cross portfolio);

c[`usd_return]:(count c[`date])?100f;
@[`c;`usd_return;-;70];

daily_returns,:flip c;

`date`ticker xasc `daily_returns;

show"SOLUTION1";

/x is the current element of daily_returns
/we build up the global vector called LIST with elements from daily_returns 
/Once we reach N elements, we remove the first element from the LIST each iteration 
/the aggregation is calculated on each iteration 

inner1:{[x;N;agg]
	LIST,:x;
	if[(count LIST)>N;LIST _:0];
	agg LIST
	};

outer1:{[n;data;agg]
	LIST::();
	r:inner1[;n;agg]each data;
	r
 }; 
\w
\ts res2:ungroup res0:select date,MDEV:outer1[1000;usd_return;dev] 
	by ticker from daily_returns;
\w 

show""; 
show"SOLUTION2";
/solution 2 differs from solution 1 in the following respect:
/We never remove elements from the front of LIST. Instead, once N is reached, 
/we calculate aggregation
/against the last N elements in LIST   
 
inner2:{[x;N;agg]
	LIST,:x;
	$[(count LIST)>N;res:agg(neg N)#LIST;res:agg LIST];
	res
	}; 

outer2:{[n;data;agg]
	LIST::();
	r:inner2[;n;agg]each data;
	r
 };  

\w 
\ts res3:ungroup res0:select date,MDEV:outer2[1000;usd_return;dev] 
	by ticker from daily_returns; 
\w 
show"";

show"SOLUTION3";
/This solution is the most general but also the most memory intensive 
/and the most time consuming
/It explicitely builds out a vector of vectors per day 
/and then calculates the aggregation for each 
/sub vector
/f1 is responsible for building up the moving lists of daily returns per stock
/N is the user specified window size
/for the first few days (until number of iternations equals N), we keep appending 
/the current daily_return to the list
/after that, we append the current daily_return and remove the oldest daily_return

/input x is the previous output
/input y is the current element in daily_returns vector
inner3:{[x;y;N]
	$[(count x)>=N;
	:(1_x),y;
	:x,y
	]};

/select usd_return by ticker from daily_returns
/n is number of previous days to look back on
outer3:{[n;data;agg]
	y:scan[inner3[;;n];data];
	/break;
	r:agg each y;
	r
 };
\w
\ts res1:ungroup res0:select date,MDEV:outer3[1000;usd_return;dev] 
	by ticker from daily_returns;
\w
 
show"";

show"";
show"SOLUTION 4 - USING BUILT IN MDEV FUNCTION";
/bult in mdev function is faster because it's approach is specific to the deviation analytic
/It utilizes the mavg function
\w
\ts res4:ungroup select date,MDEV:mdev[1000;usd_return] by ticker from daily_returns
\w
/
show"";
show"Check Solutions";

/if N is larger than the number of dates in the hdb, then the last MDEV value for
/each stock should match the simple atomic dev for each stock over all daily_returns
check:(select last MDEV by ticker from res1)
	lj select DEV:dev usd_return by ticker from daily_returns;
/show select ticker,check:MDEV=DEV from check;

/segment the moving deviations into quartiles, deciles etc
RES1:select MAX:max MDEV,MIN:min MDEV,AVG:avg MDEV,COUNT:count MDEV by ticker,xrank[4;MDEV] from res2
RES2:select MAX:max MDEV,MIN:min MDEV,AVG:avg MDEV,COUNT:count MDEV by ticker,xrank[10;MDEV] from res2
RES3:select MDEV,date,ticker by xrank[100;MDEV] from res2

show"";
\

