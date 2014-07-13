/mas contains the mappings through history of cusips to symbols
/the underlying assumption is that a companys cusip remains the same but its symbol changes.
/Therefore its cusip can be used as a unique identifier
/rows can be in any order
mas:([]cusip:`1`2`1`2`3`3;sym:`A`B`C`B`IBM`LEN;date:2000.10.27 2000.07.19 2000.04.10 2000.01.01 2002.02.14 2009.03.08)
/smd is a keyed table mapping cusip and date to the symbol for that cusip on that date

/when you group by columns, the result set is automatically sorted in ascending order by those columns
smd:select first sym by cusip,date from mas

/we are only interested in the rows of smd where the sym changes
smd:select from smd where differ sym,(cusip=prev cusip)|cusip=next cusip

/define a new column called mas which will contain the most recent symbol for each cusip
/we dont need the cusip column any more at that point
smd:delete cusip from update mas:last sym by cusip from smd

/dxy is a utility function
dxy:{[d;x;y]first$[0>type x;d(x;y);flip d flip(keys d)!(x;y)]} / util
/redefine smd and define a table msd. These tables will serve as lookups
msd:`s#select by sym,date from smd; /mapping each sym/date pair to a mas
smd:`s#select by mas,date from smd; /mapping each mas/date pair to a sym
/\
/SMD is a function that will return the symbol for a given mas on a given date
/example usage: SMD[`A;2000.05.28]

SMD:{x^first each dxy[smd;x;y]} / sym from mas and date
/MSD is a function that will return the mas for a given sym on a given date (not as useful as SMD)
MSD:{x^first each dxy[msd;x;y]} / mas from sym
/First Derivatives plc
/102 Kx Technology Training Courses
trade:([]date:
	(2000.04.09;2000.04.10;2000.04.11;2000.05.19;2000.10.26;2000.10.27;2000.10.28;2001.07.25;2002.06.01;2009.03.07;2009.03.09;2010.02.15);
	sym:`C`C`C`B`C`A`A`B`IBM`IBM`LEN`LEN;time:12?17:00:00.000;price:12?100.0;size:12?10000)
date:exec date from trade

/the function numtrades will return all trades for the master symbol on or after the first date in the
/mas table.
numtrades:{[m]raze{[s;d]
	select n:count i by date,sym:MSD[sym;first date]from trade where
	date=d,sym=s}
	'[SMD[count[date]#m;date];date]}

res1:numtrades[`LEN];
/	
/example usage: numtrades[`A]
/This function is designed to return the total volume of trades per symbol in 5 minute bars across
/all dates in the trade table. It expects to receive as input the most up to date symbol name for a
/company’s stock (mas)
five_minute_bars:{[m]raze{[s;d]select sum size by date,sym:MSD[sym;first date],5 xbar
	time.minute from trade where date=d,sym in s}'[SMD[count[date]#m;date];date]}
/example usage: five_minute_bars[`A]