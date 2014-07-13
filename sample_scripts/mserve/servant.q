
trade:([]time:`time$();sym:`symbol$();price:`float$();size:`int$())
n:3000000
st:09:00:00.000
et:16:00:00.000
portfolio:`GS`AAPL`BA`VOD`MSFT`GOOG`YHOO`IBM
`trade insert (st+n?et-st;n?portfolio;n?100f;n?10000)

proc1:{[s]do[200;
		res:select SYM:enlist s,MAX:max price,MIN:min price,OPEN:first price,CLOSE:last price,
		AVG:avg price,VWAP:size wavg price,DEV:dev price,VAR:var price
		from trade where sym=s;];
		res
	}

