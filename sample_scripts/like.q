/
Pick trades whose stock is like "Gxx0*"
where xx is any 2 character combination from the set "AUI"

\

\l taq.q

s:"AUI"
s2:s cross s /all 2 char combinations from s

p1:`GAA01`GAU02`GAI03`GUA04`GIA05`GIU06`GAX07`GAZ08`GAV09 /all stocks in the table

update sym:(count trade)?p1 from `trade

f1:{[stock]
	any
	{[stock;pattern]stock like "G",pattern,"0*"}[stock]
	each s2
	};

\t res1:trade where f1 each trade[`sym]


show exec distinct sym from trade;
show exec distinct sym from res1;