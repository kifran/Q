a:{[x;y]x+y}
b:{[x;y]x-a[y;x]}
c:{[x;y]b[x;y]+a[x;y]}
d:{[x;y]c[x;y]*b[y;x]}
e:{[x;y]d[x;y]%c[x;y]}
f:{[x;y]e[x;y]+d[x;y]}
g:{[x;y]f[x;y]-e[x;y]}
h:{[x;y]g[x;y]-f[x;y]}
i:{[x]x}
backup:([]sym:`symbol$();time:`time$();price:`float$();size:`int$())
ctrade:count trade
cbackup:count backup
f_count:{[table] count table}
/trade:i@backup
f_calcvwap:{[s;d] select vwap:wavg[size;price] by sym from trade where date=d,sym in s}


