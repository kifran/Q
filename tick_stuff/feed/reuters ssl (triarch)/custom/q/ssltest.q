/ 2005.05.12  x@&"6"=x[;3] /updates (image is 340)
/ q tick/ssl.q {sym|taq|fx|dj30|sp500} [host]:port[:usr:pwd]
/ modify this file for your feeds and schemas
/ 100,000 triarch/ssl records per second

x:.z.x,count[.z.x]_("sym";":5010")
d:x 0;if[not h:neg@[hopen;`$":",x 1;0];trade:3#();quote:5#();.u.upd:{@[x;::;,;y]}]
sub:`ssl 2:(`sub;1)
ssub:`ssl 2:(`ssub;2)


syms:`$read0 `$"tick/sym.txt"
sub each syms
/if[not count@[ssub[`IDN_RDF]each;sym:`$read0`$"tick/",d,".txt";()];sub:{x};
/ x:{@[x;(where 0x1e=x),-1+count x;:;"\n"]}each read0`:/ssl/ssl.dat`:/ssl/l2.txt d~"lvl2"]

