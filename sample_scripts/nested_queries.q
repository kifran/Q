/This script demonstrates that nested tables can offer superior query performance to
/standard queries but at the expense of added complexity

\c 15 150
s:`IBM`WMT`GS`LEH; 
x:`O`N`Q
n:1000000; 
nt:n; 
nq:4*n;
trade:([]
		time:asc nt?0t;
		sym:nt?s;
		price:50+0.1*nt?5000;
		size:nt?1000;
		ex:nt?x);

quote:([]
		time:asc nq?0t;
		sym:nq?s;
		bid:50+0.1*nq?5000;
		ask:50+0.1*nq?5000;
		bsize:nq?1000;
		asize:nq?1000;
		ex:nq?x);

\w
/optimise queries using nested columns
show"build nested query";
\t do[1;nested_quote: select time,sym,bid,ask,bsize,asize,ex by sym from quote];

show"build new nested table";
f:{select from quote where sym=x};
\t t1:([sym:exec distinct sym from quote]f each exec distinct sym from quote);
/
/QUERY 1: select last 5 GS quotes
show"QUERY 1: select last 5 GS quotes";

/standard query
show"standard query";
\t do[10;res1:-5#select time,sym,bid,ask from quote where sym=`GS];

/optimsed nested query
show"optimsed nested queries";

\t do[1000;res2:select #'[-5;time],#'[-5;sym],#'[-5;bid],#'[-5;ask] from nested_quote where sym=`GS]

\t do[1000;resx:select #/:[-5;time],#/:[-5;sym],#/:[-5;bid],#/:[-5;ask] from nested_quote where sym=`GS]

TAKE:{[n;c]n#raze c};

\t do[1000;res3:select TAKE[-5;time],TAKE[-5;sym],TAKE[-5;bid],TAKE[-5;ask] 
		from nested_quote where sym=`GS];

show"new approach";
\t do[1000;resy:-5#(t1[`GS])[`x]]


show (res1~ungroup res2)and(res1~res3);	

\
/QUERY 2: select avg bid by sym where sym in `IBM`GS,bsize>200
show"QUERY 2: select avg bid by sym from quote where sym in `IBM`GS,bsize>200";

/standard query
show"standard query";
\t do[10;res4:xkey[();select AVG:avg bid by sym from quote where sym in `IBM`GS,bsize>200]];

/optimsed nested query
show"optimsed nested queries";

avg_nested:{[x;y;z]avg x where y>z}

\ts do[100;res5:select sym,AVG:avg_nested[;;200]'[bid;bsize] from nested_quote where sym in `IBM`GS];

f:{[x;y;z]x:raze x;y:raze y;avg x where y>z};
\ts do[100;res6:0!select AVG:f[bid;bsize;200] by sym from nested_quote where sym in `IBM`GS];

/\t do[100;res7:0!raze{select sym:enlist x,AVG:avg bid from t1[x][`x] where bsize>200}each (flip key t1)`sym]

\ts do[100;res7:0!raze
	{select sym:enlist x,AVG:enlist avg bid from t1[x][`x] where bsize>200}
	each `IBM`GS]

show res4~res5;
show res5~res6;


	