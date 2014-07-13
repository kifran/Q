/casting
/
You can cast kdb+ datatypes in various equivalent ways:
Method 1: specify datatype by it's symbol name 
Method 2: specify datatype by it's character equivalent  
Method 3: specify datatype by it's short equivalent
\

/casting to booleans
show"casting to booleans";
/Method 1
b1:`boolean$(10;-10;0); /returns 110b

/Method 2
b2:"b"$(10;-10;0); /returns 110b

/Method 3
b3:1h$(10;-10;0); /returns 110b
show (b1~b2)&(b2~b3);

/casting to shorts
show"casting to shorts";
/Method 1
h1:`short$(100;10000000000j;100.25;100.75);

/Method 2
h2:"h"$(100;10000000000j;100.25;100.75);

/Method 2
h3:5h$(100;10000000000j;100.25;100.75);
show (h1~h2)&(h2~h3);

/casting to ints
show"casting to ints";
/Method 1
i1:`int$(100h;10000000000j;100.25;100.75);

/Method 2
i2:"i"$(100h;10000000000j;100.25;100.75);

/Method 3
i3:6h$(100h;10000000000j;100.25;100.75);
show (i1~i2)&(i2~i3);

/casting to longs
show"casting to longs";
/Method 1
j1:`long$(100h;100000;100.25;100.75);

/Method 2
j2:"j"$(100h;100000;100.25;100.75);

/Method 3
j3:7h$(100h;100000;100.25;100.75);
show (j1~j2)&(j2~j3);

/casting to reals
show"casting to reals";
/Method 1
e1:`real$(100h;100000;100.25;100.75);

/Method 2
e2:"e"$(100h;100000;100.25;100.75);

/Method 3
e3:8h$(100h;100000;100.25;100.75);
show (e1~e2)&(e2~e3);

/casting to floats
show"casting to floats";
/Method 1
f1:`float$(100h;100000;100000000000j;100.25e;100.75e);

/Method 1
f2:"f"$(100h;100000;100000000000j;100.25e;100.75e);

/Method 1
f3:9h$(100h;100000;100000000000j;100.25e;100.75e);
show (f1~f2)&(f2~f3);

/casting to chars
show"casting to chars";
/Method 1
c1:`char$(first string`N;78h;78;78j;78.4;78.6);

/Method 2
c2:"c"$(first string`N;78h;78;78j;78.4;78.6);

/Method 3
c3:10h$(first string`N;78h;78;78j;78.4;78.6);
show (c1~c2)&(c2~c3);

sym1:`IBM;
string1:string `IBM;
sym2:`IBM`MSFT`VOD;
string2:string sym2;
string3:sv["`";string2];
x:vs["`";string3];

/casting to symbols
show"casting to symbols";
s:{`$x}each ("IBM";("IBM";"MSFT";"VOD"));

/casting to dates"
show"casting to dates";
/Method 1
d1:`date$(4070h;4070;4070j;4070.4;4070.6;2011.02.22T09:30:10.500);

/Method 2
d2:"d"$(4070h;4070;4070j;4070.4;4070.6;2011.02.22T09:30:10.500);

/Method 3
d3:14h$(4070h;4070;4070j;4070.4;4070.6;2011.02.22T09:30:10.500);
show (d1~d2)&(d2~d3);

/casting to months
show"casting to months";
/Method 1
m1:`month$(2011.02.22;133;2011.02.22T09:30:10.500);
m2:"m"$(2011.02.22;133;2011.02.22T09:30:10.500);
m3:13h$(2011.02.22;133;2011.02.22T09:30:10.500);
show (m1~m2)&(m2~m3);

/casting to time
show"casting to time";
/Method 1
t1:`time$(34210500;34210500j;09:30u;09:30:10v;2011.02.22T09:30:10.500);

/Method 2
t2:"t"$(34210500;34210500j;09:30u;09:30:10v;2011.02.22T09:30:10.500);

/Method 3
t3:19h$(34210500;34210500j;09:30u;09:30:10v;2011.02.22T09:30:10.500);
show (t1~t2)&(t2~t3);

/casting to minute
show"casting to minute";
/Method 1
u1:`minute$(570;09:30:10.500;09:30:10v;2011.02.22T09:30:10.500);

/Method 2
u2:"u"$(570;09:30:10.500;09:30:10v;2011.02.22T09:30:10.500);

/Method 3
u3:17h$(570;09:30:10.500;09:30:10v;2011.02.22T09:30:10.500);
show (u1~u2)&(u2~u3);

/casting to second
show"casting to second";
/Method 1
v1:`second$(34210;09:30:10.500;09:30:10v;2011.02.22T09:30:10.500);

/Method 2
v2:"v"$(34210;09:30:10.500;09:30:10v;2011.02.22T09:30:10.500);

/Method 3
v3:18h$(34210;09:30:10.500;09:30:10v;2011.02.22T09:30:10.500);
show (v1~v2)&(v2~v3);

/casting to datetime
show"casting to datetime";
/Method 1
z1:`datetime$(2011.02.22;4070);

/Method 2
z2:`datetime$(2011.02.22;4070);

/Method 3
z3:`datetime$(2011.02.22;4070);

show (z1~z2)&(z2~z3);

/casting from strings - use upper case letter representing the datatype we wish to cast to
show"Casting from strings";

/cast to Integer
x:"1000"; /cast this to the singe atomic interger 1000
"I"$x;
/cast to Date
y:"2010.02.21"
"D"$y;
f:"ID"$
z:("1000";"2011.02.22");
res:f[z];