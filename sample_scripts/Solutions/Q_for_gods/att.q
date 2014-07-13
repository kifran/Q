/- supply a function call as param 1 and .z.z as param 2 to get the timing value
timeit:{86400000*.z.z - y}
print_times:{[x;y;z;t;i]
	-1"*******";
	-1 z;
	-1"Averaging over ",(string i)," iterations";
	-1 x," is ",(("SLOWER";"FASTER")t<0)," than ",y;
	-1"by ",(string abs t)," milliseconds";}

iterations:1000
printq:{-1"\n\n Question ",(string x)," \n";}

/sample trade table
trade:([]
	date:10000000#2008.08.05;
	time:10000000?.z.T;
	sym:10000000?`VOD.L`BARC.L`ENI.MI`RBS.L`HBOS.L`LHAG.DE;
	price:10000000?100f;
	size:10000000?1000);


/1)
fmb:{	-1"*** FMB ****";
	{-1"Average time in ms to find ",(string z)," over ",(string y)," searches : ",
	string timeit[do[y;x?z];.z.z]%y}[x;y] 
	each x(0;`int$c%2;c:-1+count x);
	}

printq 1
fmb[til 200000;iterations]
fmb[-200000?`7;iterations]

/2)
printq 2
fmb[`s#til 200000;iterations]
fmb[asc -200000?`7;iterations]

/3)
printq 3
fmb[`u#til 200000;iterations]
fmb[`u#-200000?`7;iterations]

/- Work out the search times for different attributes
/- n is length of list, i is number of iterations, a1 is attribute1, a2 is attribute 2
search_times:{[n;i;a1;a2]
        s:i?l:asc (neg n)?`7;   /- l=list to search; s=items to search for
        l1:a1#l; l2:a2#l;	/- apply the attributes
        (timeit[l1?/:s;.z.z] - timeit[l2?/:s;.z.z])%i}

whens_the_change:{[n;i;a1;a2;d]
	$[d<r:search_times[n;i;a1;a2];
		print_times["attribute ",string a1;"attribute ",string a2;"For list length ",string n;r;i];	whens_the_change[`int$n*1.2;i;a1;a2;d]]}

/4)
printq 4
whens_the_change[10;iterations;`;`u;.001]

/5)
printq 5
whens_the_change[10;iterations;`s;`u;.001]

time_grouped:{[n;i;d]	/- n=length of table, i=number of iterations, d=number of distincts
	t:([]sym:n?(neg d)?`7;price:n?100e);
	g:update `g#sym from t;
	x:first t`sym;	/- item to select
	(timeit[do[i;select from t where sym=first t`sym];.z.z] - timeit[do[i;select from g where sym=first t`sym];.z.z])%i}
run_q6:{[n;i;d] print_times["non grouped table";"grouped table";"For table of length ",string n;time_grouped[n;i;d];i]};


/6)
printq 6
run_q6[100000;iterations] each 10 100 1000 10000;

run_q7:{
	-1"******";
	-1"Byte overhead for list of ",(string count x)," items of type ",(string type x)," containing ",(string count distinct x)," distincts is ";
	-1 string (hcount (`:qfgaq6g set `g#x)) - hcount (`:qfgaq6 set x);
	hdel each `:qfgaq6g`:qfgaq6;}

/7)
printq 7
run_q7 til 10000
run_q7 `long$til 10000
run_q7 10000?3

/8)
printq 8
time_d:{[n;i]	/- n=length of dict, i=iterations
	d:((neg n)?`7)!til n;
	u:(`u#key d)!til n;
	s:i?key d;	
	(timeit[do[i;d@/:s];.z.z] - timeit[do[i;u@/:s];.z.z])%i}
run_q8:{[n;i]print_times["non-unique dict";"unique dict";"For dict of length ",string n;time_d[n;i];i]}
run_q8[;iterations] each 10 100 1000 10000;

/9)
/
Static table or guaranteed that all inserts preserve the sort.  
If this condition is met there is no point not having it – no downside, 
even if the sort is preserved infrequently.  For example, the time column of the trade table 
in the standard tick configuration, provided all the timestamps come from a single tickerplant 
(time monotonicity is preserved)
\

/10)
printq 10
table_time_sorted:{[i]
	s:`time xasc trade;
	t:update `#time from s;
	(timeit[do[i;select from t where time within 12:00 13:00];.z.z] - 
	timeit[do[i;select from s where time within 12:00 13:00];.z.z])%i}
run_q10:{[i]print_times["non sorted table";"sorted table";"";table_time_sorted[i];i]}
run_q10[iterations];


/11)
/
U Attribute -
Either a static table where the uniqueness of the column is preserved, 
or a single keyed table where uniqueness is automatically enforced.  
Query performance should improve with the unique attribute if a table has length > 100 (approx).  
For example, a keyed table containing instrument information on a per stock basis. 
The downside to applying the unique attribute is an increased memory footprint due to the hashmap behind the u attribute
\

/12)
printq 12
table_unique:{[i]
	t:select count i by size from trade;
        u:update `u#size from t;
	s:i?exec size from t;
        (timeit[do[i;t@/:s];.z.z] - timeit[do[i;u@/:s];.z.z])%i}
run_q12:{[i]print_times["non unique table";"unique table";"";table_time_sorted[i];i]}
run_q12[iterations];

/13)
/
G Attribute -
Any column with a large number of entries but a much smaller number of distinct items which is regularly searched.  
The downside is extra memory usage.  For example, the sym column of the trade table in the RTD of a standard tick db. 
\

/14)
printq 14
table_grouped:{[i]
        t:update `#sym from `sym xasc trade;
        g:update `g#sym from t;
        (timeit[do[i;select from t where sym=`VOD.L];.z.z] - timeit[do[i;select from g where sym=`VOD.L];.z.z])%i}
run_q12:{[i]print_times["non grouped table";"grouped table";"";table_grouped[i];i]}
run_q12[iterations];


