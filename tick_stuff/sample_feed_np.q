h:neg hopen `:localhost:5000
/h(".u.upd";`trade;(.z.T;`A;100f;1000))

syms:`MSFT.O`IBM.N`GS.N`BA.N`VOD.L
cities:(`$"New York";`London;`Tokyo;`Chicago;`Boston;`$"San Francisco");

n:50

/.z.ts:{h(".u.upd";`trade;(n#.z.T;n?syms;n?100f;n?1000))}

flag:1

/with time as first field -> time column on real time subscribers will be feedhandler time
.z.ts:{
	$[0<flag mod 10;
	h(".u.upd";`quote;(n#.z.T;n?syms;n?100f;n?1000;n?100f;n?1000));
	[h(".u.upd";`trade;(n#.z.T;n?syms;n?100f;n?1000));
	 h(".u.upd";`kt1;(.z.T;rand syms;rand cities;rand 100000000j*til 20))]];
	flag+:1;
 };
/
/without time as first field -> time column on real time subscribers will be TP local time 
.z.ts:{
	$[0<flag mod 10;
	h(".u.upd";`quote;(n?syms;n?100f;n?1000;n?100f;n?1000));
	[h(".u.upd";`trade;(n?syms;n?100f;n?1000));
	 h(".u.upd";`kt1;(rand syms;rand cities;rand 100000000j*til 20))]];
	flag+:1;
 };


 
/\t 200