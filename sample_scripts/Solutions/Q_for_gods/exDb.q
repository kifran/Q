/build the TAQ data partitioned database on disk

hdb_builder:{[dt]
	show"build hdb for ",-3!dt;
	trade::([]
			time:`time$();
			sym:`symbol$();
			price:`float$();
			size:`int$();
			ex:`symbol$()
		);

	quote::([]
			time:`time$();
			sym:`symbol$();
			bid:`float$();
			bsize:`int$();
			ask:`float$();
			asize:`int$();
			ex:`symbol$()
		); 

	/define data 
	n:100000; /n is number of trades
	st:09:30t;
	et:17t;
	portfolio:`IBM`MSFT`GOOG`YHOO;
	exchanges:(`N;`O;`B;`L);
	tdata:(st+n?et-st;n?portfolio;n?100f;n?1000;n?exchanges);
	insert[`trade;tdata];
	n*:10;
	qdata:(st+n?et-st;n?portfolio;n?100f;n?1000;n?100f;n?1000;n?exchanges);
	insert[`quote;qdata];

	/show"sort trade";
	xasc[`time;`trade];
	/show"sort quote";
	xasc[`time;`quote];
	
	.Q.dpft[`:exDb;dt;`sym;`trade];
	.Q.dpft[`:exDb;dt;`sym;`quote];	
 };
 
hdb_builder each .z.D-1+til 3;

/build the static table productInfo which will be saved as a single binary file
productInfo:([sym:`IBM`MSFT`GOOG`YHOO]
	name:("IBM";"Microsoft";"Google";"YAHOO");
	cusip:`ABC123`DEF456`GHI789`JKL012;
	city:(`Armonk;`Redmond;`Sunnyvale;`$"San Francisco");
	MC:10000000000j*1+4?10
 );

`:exDb/productInfo set productInfo














/