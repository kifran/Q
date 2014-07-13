\l taq.q

c:dts cross portfolio

f:{[x]select from trade where date=x[0],sym=x[1]};

res:raze f each c