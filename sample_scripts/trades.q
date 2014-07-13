trade:([]date:`date$();time:`time$();sym:`symbol$();price:`float$());

\c 10 150

n:100000
portfolio:`IBM`MSFT

`trade insert (.z.D-n?10;09:30t+n?06:30t;n?portfolio;n?100f);
`date`time xasc `trade

f:{[row]
	current_sym:row[`sym];
	current_price:row[`price];
	current_date:row[`date];
	current_time:row[`time];
	t:select from trade where 
	((date=current_date)and(sym=current_sym)and(time>current_time))
	or
	((date=1+current_date)and(sym=current_sym));
	/if[null location:first where t[`price]>1.2*current_price;
	/location:-1+count t[`price]];
	
	location:(-1+count t[`price])^first where t[`price]>1.2*current_price;
	sell_price:t[`price]@location;
	sell_date:t[`date]@location;
	sell_time:t[`time]@location;
	row[`return]:sell_price-current_price;
	row[`exit_date]:sell_date;
	row[`exit_time]:sell_time;
	row
 };
 
res:f each trade; 


