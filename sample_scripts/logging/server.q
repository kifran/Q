
if[not `trade in system"v";system"l trade.q"];
v1:`USDGBP

/checkpointing
/\l /this will create the .qdb file


upd:{[data]
	insert[`trade;data];
	show last trade;
	v1::v1+100;
	/'customerror1
 };
 
upd1:{[data]
	insert[`trade;data];
	show last trade;
	upd2[`a];
 }; 
 
upd2:{
	x+10;
 }; 
 
.ns1.trade:trade

.ns1.upd:{[data]
	insert[`.ns1.trade;data];
	show last trade;
	v1::v1+100;
	/'customerror1
 };
 
.z.pg:{show".z.pg";show x;value x};

.z.ps:{show".z.ps";show x;value x};

.z.po:{show".z.po";show x};

.z.pc:{show".z.pc";show x};

.z.exit:{show"exit";show x}

 







/