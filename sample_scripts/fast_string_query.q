\c 10 150

n:10000000
portfolio:-300000?`7
p:string portfolio
trade:([]time:n?.z.T;order_id:n?p;price:n?100f;size:n?1000)

/\t select from trade where order_id like "eebklja"

show"Vanilla";
show .Q.w[];
\t r1:select from trade where order_id like "eebklja"

build1:{[]
	/'yyy
	x:distinct trade[`order_id];
	z::(10+til count x)!x;
	/break;
	update k:?[z;order_id]from `trade;
	};
	
show"build1 lookup";
\ts build1[];

show"Integer lookup approach";
show .Q.w[];

\t r2:delete k from select from trade where k=?[z;"eebklja"]

r1~r2

update `g#k from `trade

show"Grouped attribute lookup approach";
show .Q.w[];
\t r3:delete k from select from trade where k=?[z;"eebklja"]

(r1~r2)&(r1~r3)
/

build2:{[]
	x:distinct trade.order_id;
	z::x!(til count x);
	/break;
	update k:z[order_id] from `trade;
	};
show"build2 lookup";
\ts build2[];
	
\t r4:delete k from select from trade where k=z["eebklja"];

r1~r4
