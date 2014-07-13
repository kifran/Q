//*************************************************
/
this script demonstrates how data can be adjusted on the fly to retrieve a
historical data series for a stock smoothed for today's prices
\

// ** Set up Data **

/define trade table schema
trade:([]date:`date$();sym:`$();time:`time$();price:`float$();size:`int$());

/number of records for each bulk insert
n:10000;
/n:1000000;

/insert data for VOD.L for days between 60 and 30 days ago, where price fluctuates between 50/55
`trade insert (n?(.z.D-til 30)-30;n#`VOD.L;n?0t;50+n?5.;n?10000);

/
We now insert data for VOD.L for the last 30 days, where price has dropped / undergone a correction.  
This could be an example of a 20% stock dividend.  For every 5 shares that a shareholder owns, the company issues an additional share.
As the value of the company has not fundamentally changed, its marketcap should remain constant, and therefore the value of the shares is diluted
by ~16.7% to account for the increase in the amount of shares in circulation.
We also observe a volume inrease - more shares in circulation, more liquidity.

e.g. 
company XYZ has 100 shares in circulation worth $10 each.  Marketcap therefore is $1,000.
It issues a 20% share dividend.  There are now 120 shares in circulation.
Marketcap remains unchanged at $1,000.  Therefore value of shares is now (1000/120) = 8.333.
This is approx a 16.7% reduction in share price.
\
`trade insert (n?.z.D-til 30;n#`VOD.L;n?0t;0.8333*50+n?5.;n?12000);

/delete from trade where day is saturday or sunday
delete from `trade where (date mod 7) in 0 1;
`date`time xasc `trade;

/
the data we have inserted into the trade table above indicates that there was a corporate action 30 days ago
define an adjustment factors table to reflect this.  This data would typically be retrieved from a vendor, e.g. Bloomberg, each morning.
\
adjFactors:`s#select by sym, date from ([]sym:2#`VOD.L;date:(0Nd;.z.D-30);af:0.8333 1);


// ** Define util functions **

/retrieve the adjustment factor needed to scale a stock on a given date

.util.getAdjFactor:{[res]
    :1^(adjFactors([]sym:res`sym;date:res`date))[`af];
	}
	
/function to adjust price and size columns

.util.adjustCorpActions:{[res]
	af:.util.getAdjFactor[res];
    pricecols:(cols res) inter `price`meanprice`vwap`bid`ask;
	sizecols:(cols res) inter `size`volume`bsize`asize;
	if[count pricecols;
	    res[pricecols]:res[pricecols]*\:af;
	   ];
	if[count sizecols;
	    res[sizecols]:res[sizecols]%\:af;
	   ];
	:res
	};



//** Usage **
/
.util.adjustCorpActions expects an unkeyed table with date and sym columns
could probably do a check at top of the function along the lines of
if[(not 98=type res)& (not all `date`sym in cols res);-1"wrong input format for this function..";:0b];
\

/apply to raw data
/show "Adjusting raw data";
res1:.util.adjustCorpActions[trade];

/apply to pre-aggregated data
/show "Adjusting pre-aggregated data";
res2:0!select avg price by date, sym from trade;
res3:.util.adjustCorpActions[res2];  

/make sure it works for adjusting multiple price columns
res4:0!select meanprice:avg price, vwap:wavg[size;price] by date, sym from trade;
res5:.util.adjustCorpActions[res4];  

/make sure it works for adjusting size columns as well
res6:0!select meanprice:avg price, vwap:wavg[size;price], volume:sum size by date, sym from trade;
res7:.util.adjustCorpActions[res6];



\
// ** Performance Analysis**

q)\t do[1000;0!select avg price, vwap:wavg[size;price] by date, sym from trade]
781
q)
q)\t do[1000;.util.adjustCorpActions 0!select avg price, vwap:wavg[size;price] by date, sym from trade]
812


/Seems to scale pretty well
/run script again but for n=1000000
q)\t do[100;0!select avg price, vwap:wavg[size;price] by date, sym from trade]
10625
q)
q)\t do[100;.util.adjustCorpActions 0!select avg price, vwap:wavg[size;price] by
 date, sym from trade]
10531
q)//looks like applying the function was quicker than naked aggregation? results probably due to caching?
q)
q)\\


C:\scripts>C:/q/w32/q corp_actions_james.q
KDB+ 2.7 2011.07.28 Copyright (C) 1993-2011 Kx Systems
w32/ 2()core 2038MB jcorcoran wks121 10.18.10.143 EXPIRE 2012.03.16 firstderivat
ives.com INTERNAL #44031

q)\t do[100;.util.adjustCorpActions 0!select avg price, vwap:wavg[size;price] by date, sym from trade]
10593
q)\t do[100;0!select avg price, vwap:wavg[size;price] by date, sym from trade]
10514