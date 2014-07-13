
\l taq2.q
\c 10 150

/string approach

ip:`agg_col`agg_func`cond_col`cond`tbl!(`price;`max;`sym;`$"=`GBPJPY";`trade);
	
string_func:{[ip]
	agg_col:ip[`agg_col];
	agg_func:ip[`agg_func];
	cond_col:ip[`cond_col];
	cond:ip[`cond];
	tbl:ip[`tbl];
	s:"select AGG:",(string agg_func)," ",(string agg_col)," from ",(string tbl)
		," where ",(string cond_col)," ",(string cond);
	res:value s;
	res
	};
	
res1:string_func[ip];


/\t do[1000;res1:string_func[ip]];
/\t do[1000;res2:select AGG:max price from trade where sym=`GBPJPY];


/dc:`sym`price!((=;`sym;`GBPUSD);(>;`price;10));


x:parse"select CCY:sym,PRICE:price from trade where sym=`EURGBP,price>10";

/?[trade;raze constraint;0b;`CCY`PRICE!`sym`price]

/select MAX:max price,VWAP:size wavg price by CCY:sym,TIME:300000 xbar time from trade where sym=`EURGBP,price>10

dagg:`MAX`VWAP!((max;`price);(wavg;`size;`price));

dby:`CCY`TIME!(`sym;(xbar;300000;`time));

friendly_names:((`CCY;`EURGBP);(`PRICE;10));

constraint:
	{[x]
	(`CCY`PRICE!((=;`sym;enlist x[1]);
	(>;`price;x[1])))[x[0]]
	}each friendly_names;

res1:?[trade;();dby;dagg];
res2:?[trade;constraint;dby;dagg];

functional_query:{[tbl;constraint;dagg;dby]
	res:?[tbl;constraint;dby;dagg];
	res
 };
 
\t do[1000;RES2:functional_query[trade;constraint;dagg;dby]];

\t do[1000;RES3:select MAX:max price, VWAP:size wavg price by CCY:sym,TIME:xbar[300000;time] from trade where sym=`EURGBP,price>10];
 
























/