
/`s#tbl provides asof join like behaviour (hard look up and soft lookup columns)

\c 20 160

t1:([]sym:`A`A`A`B`B`B`C;ex:`N`N`P`N`P`Q`Q;
	date:(.z.D;.z.D+2;.z.D+3;.z.D;.z.D+1;.z.D+3;.z.D);price:7?100);

x1:`s#select by sym,ex,date from t1


d:((`A;`N;.z.D-1);
	(`A;`N;.z.D);
	(`A;`N;.z.D+1);
	(`A;`P;.z.D+2);
	(`A;`P;.z.D+3);
	(`A;`P;.z.D+4));
	
r0:x1 each d;	

/s attribute appied to a dictionary changes the dictionary into a step function:
/we can use this behaviour to build irregulaly spaced buckets
\l taq.q

/Example 1

buckets:09:30 09:45 10:30 12 13 15 16:30t
buckets:buckets!buckets
/buckets!:buckets
/.[`buckets;();`s#];
buckets:`s#buckets;	

show"count price";	
\ts do[200;res1:select OPEN_TIME:min time,CLOSE_TIME:max time,
	COUNT:count i by sym,buckets[time] from trade];
		
show"count 1";	
\ts do[200;res2:select OPEN_TIME:min time,CLOSE_TIME:max time,
	COUNT:count 1 by sym,buckets[time] from trade];

show res1~res2;
/
/Example 2
/Make the bucket widths be dependent on sym

ref4:asc([]sym:();time:())upsert portfolio cross 9 10 12 15t;

update c1:til(count ref4),c2:(neg count ref4)?.Q.A from `ref4

xkey[`sym`time;`ref4];

data:((`GOOG;9t);(`GOOG;09:30t);(`IBM;12t);(`IBM;12:30t);(`AAA;10t));

r1:ref4 each data;

/Transform Keyed table into a step function
ref5:`s#ref4
r2:ref5 each data;

r3:update res1:ref4[flip(sym;time)],res2:ref5[flip(sym;time)] from trade 

\ts r4:select SYM:distinct sym, 
	TIME_RANGE:@\:[(first;last;max;min;avg;{`time$dev `int$x});time] 
	by G:(ref5[flip(sym;time)])[`c1]
	from trade
		
/

t:09:30 09:45 11 11:01 11:02 14 15 15:30 16t
t!:t
step1:`s#asc t
\ts do[10;r1:select open:first time,close:last time by step1[time]from trade]
\ts do[10;r2:select open:first time,close:last time by (key step1)@(key step1) bin time from trade]	
 


