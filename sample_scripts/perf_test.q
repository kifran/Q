\c 10 150
\C 2000 2000

d:10 /set d

quote:([]
		time:`time$();
		sym:`symbol$();
		bid0:`float$();
		bsize0:`float$();
		bid1:`float$();
		bsize1:`float$();
		bid2:`float$();
		bsize2:`float$();
		bidn:();
		bsizen:();
		ex:`symbol$();
		location:`symbol$()
 ); 

/define data 
n:1000000; /n is number of trades
st:09:30t;
et:17t;
portfolio:`IBM`MSFT`GOOG`YHOO,-6?`3
exchanges:(`N;`O;`B;`L);
locations:`NY`LN`TK;
x:(cross[portfolio;exchanges])cross locations;
y:x!til count x;


left_price:((enlist 1f);(1 2f);(1 2 3f);(1 2 3 4f));

left_prices:left_sizes:n?left_price;

qdata:(st+n?et-st;n?portfolio;
		n?100f;n?1000f;
		n?100f;n?1000f;
		n?100f;n?1000f;
		left_prices;left_sizes;n?exchanges;n?locations);
insert[`quote;qdata];

f:{[s;e;l]res1:flip(s;e;l);y res1};
update id:f[sym;ex;location] from `quote;

/show"sort quote";
xasc[`time;`quote];

/update `g#id from `quote;
/update `g#sym from `quote;

show"test1";
\t do[100;r1:select max bid0 by sym from quote]
\t do[100;r2:select max bidn[;0] by sym from quote]

show"test2";
\t do[100;res1:select from quote where sym=`GOOG,ex=`N,location=`TK]
\t do[100;res2:select from quote where id=y[`GOOG`N`TK]]

