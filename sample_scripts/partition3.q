\l taq.q

trade_all:trade;
quote_all:quote;

/3 directories - db4,db5,db6

part:{[dt]
	show dt;
	trade::delete date from select from trade_all where date=dt;
	quote::delete date from select from quote_all where date=dt;
	{[dt;x].Q.dpft[`:db4;dt;`sym;x]}[dt;]each `trade`quote;
 };
 
part each exec distinct date from trade_all; 
 
 