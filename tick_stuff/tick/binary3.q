/\l taq.q

single_save:{[db;tbl]
	set[hsym `$(string db),"/",(string tbl);value tbl];
 };

splayed_save:{[db;tbl]
	set[hsym `$(string db),"/",(string tbl),"/";.Q.en[hsym db;value tbl]];
 };
 
splayed_append:{[db;tbl]
	.[{[db;tbl]show"try to append";insert[db;tbl]};
	(hsym `$(string db),"/",(string tbl),"/";.Q.en[hsym db;value tbl]);
	{[db;tbl;error]show "initialise";splayed_save[db;tbl]}[db;tbl;]];
 }; 

 
partitioned_save:{[d;p;f;t;source]
	show"p is: ",(string p)," and t is: ",(string t);
	set[t;value"delete date from select from ",
	(string source)," where date=",(string p)];
	.Q.dpft[d;p;f;t];
 };

partitioned_append:{[t;p;d;s]
	set[t;value"delete date from select from ",(string s)," where date=",(string p)];
	splayed_append[hsym `$(string d),"/",(string p);t];
	value"delete ",(string t)," from `.";	
	};  

/	
/splayed_save[`:db2;`trade] 
splayed_append[`:db2;`quote] 

trade_all:select from trade
quote_all:select from quote 
 
partitioned_save[`:db4;;`sym;`trade;`trade_all]each exec distinct date from trade_all;
partitioned_save[`:db4;;`sym;`quote;`quote_all]each exec distinct date from quote_all;

trade:trade_all
quote:quote_all
delete trade_all,quote_all from `. 

trade_all:select from trade;

partitioned_append[`trade;2010.05.23;`:db3;`trade_all];

trade:trade_all;
delete trade_all from `.  
 