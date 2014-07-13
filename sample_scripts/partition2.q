/partition by sym,5 minute block
/this will be an integer partitioned database

\l taq.q

minutes:(`minute$st)+00:05u*til `int$(`minute$et-st)%5;

a:cross[minutes;portfolio];
b:a!til count a;

trade_all:trade;
quote_all:quote;

f:{[ip]
	show b[ip];
	m:ip[0];
	s:ip[1];
	trade::select from trade_all where sym=s,time within(m;m+00:05);
	quote::select from quote_all where sym=s,time within(m;m+00:05);
	/show select MIN:min time,MAX:max time from d;
	/slow down by 63 ms
	/{asc desc asc x?100}[10000000];
	/.Q.dpft[`:C:/q_work/db3;b[ip];`date;`trade];
	/.Q.dpft[`:C:/q_work/db3;b[ip];`date;`quote];
	set[`$":C:/q_work/db3/",(string b[ip]),"/trade/";.Q.en[`:C:/q_work/db3;trade]];
	set[`$":C:/q_work/db3/",(string b[ip]),"/quote/";.Q.en[`:C:/q_work/db3;quote]];
 };
 
/x:09:50
/y:`IBM
/a[(x;y)]
 
f each a 
set[`:C:/q_work/db3/b;b];

delete from `.
\l C:/q_work/db3
/
/{[i]show i;.[`:.;(i;`trade;`ex);`g#];}each(key `:.)except `b`sym

delete_column:{[t;c;p]

	system"del ",1_ssr[string sv[`;(hsym p;t;c)];"/";"\\"];
	d:get sv[`;(hsym p;t;`.d)];
	d:d where not d=c;
	set[sv[`;(hsym p;t;`.d)];d];
	};
	
/delete_column[`quote;`ex;]each(key hsym`.)except `b`sym
\l C:/q_work/db3


f:{[x]r1:x*x;r2:x%x;};

access1:{[s;m]
	p:b[(m;s)];
	/res:select MAX:max price,MIN:min price from trade where int=p;
	res:delete int from select from trade where int=p;
	res
 };
RES1:access1[`IBM;09:30]; 

access2:{[s;t]
	m:(`minute$t)-mod[`minute$t;5];
	p:b[(m;s)];
	res:delete int from select MAX:max price,MIN:min price from trade where int=p;
	res
 };
RES2:access2[`IBM;.z.T]; 
 
access3:{[s;t;d]
	m:(`minute$t)-mod[`minute$t;5];
	p:b[(m;s)];
	res:delete int from select MAX:max price,MIN:min price from trade where int=p,date=d;
	res
 };
 
RES3:access3[`IBM;.z.T;.z.D-2];  
