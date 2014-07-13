n:1000
c:1 2 3
s:`A`B`C`D`E`F`G`H`I`J
tz:asc 09:00:00.0 + n?01:00:00.0
tz:(n?c)#'tz
p:100e
sz:10000
q:{cx:count x; (`upd;`quote;(x;cx?s;cx?p;cx?p;cx?sz;cx?sz))}
d:{cx:count x; (`upd;`depth;(x;cx?s;cx?p;cx?p;cx?p;cx?p;cx?p;cx?p;cx?p;cx?p;cx?p;cx?p;cx?sz;cx?sz;cx?sz;cx?sz;cx?sz;cx?sz;cx?sz;cx?sz;cx?sz;cx?sz))}
t:{cx:count x; (`upd;`trade;(x;cx?s;cx?p;cx?sz))}
q1:{cx:count x; (`upd;`quote;(x;cx?s;cx?p;cx?sz;cx?sz))}
b:{cx:count x; (`upd;`orders;(x;cx?s;cx?p;cx?sz;cx?sz))}

tl:{(value rand `q`d`t)x} each tz

/- log 1 is good
`:log1 set tl

/- log 2 - type error (1 column in one update is mis-typed)
`:log2 set .[tl;(101;2;3);`short$]

/- log 3 - q1 has too few columns in quote table 
`:log3 set {(value `q1)x} each tz

/- log 4 - one column is too long
`:log4 set .[tl;(16;2;2);,;12.823 581 37.03e]

/- log 5 - order table doesn't exist 
`:log5 set {(value `b)x} each tz 

/- log 6 - one value in a column has wrong type
`:log6 set .[tl;(124;2;2);:;(12.4e;198.3f;190.8)]