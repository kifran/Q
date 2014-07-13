show"q1";
show"type of atomic int is -6h";
show type 3;
show"type of atomic float is -9h";
show type 3f;
show"type of homogeneous list of ints is 6h";
show type 3 1 2;
show"type of homogeneous list of floats is 9h";
show type 3 1 2f;
show"type of heterogeneous list is 0h";
show type (3f;1;2j);
show"type of each element of heterogeneous list is:";
show type each (3f;1;2j);

show"q2";
x:"12:30:00";
show"time";
show "T"$x;
show"minute";
/show "U"$x
show `minute$"T"$x;
show"second";
show "V"$x;
show `second$"T"$x;

show "q3";
show `real$123.23;

show "q4";
x:2007.12.25;
show"month";
show `month$x;
show `mm$x;
show"week";
show `week$x;
show floor(x-2007.01.01)%7;
show "year";
show `year$x;

show"q5";
show "Current time";
show .z.T;
show "Current Date";
show .z.D;
show "Current Minute";
show `minute$.z.T;
show `mm$.z.T;
show "Current Second";
show `second$.z.T;
show `ss$.z.T;
show "Current Hour";
show `hh$.z.T;

show "show q6";
x:"xyz";
alpha:`abc`def`ghi;
alpha,:`$x;

show "q7";
alpha[1]:`jkl;

show "q8";
show string 1234;

show "q9";
x:"hello";
show last x;
show x[-1+count x];
show first reverse x;
show x where x="o";
show x ss[x;"o"];

show "q10";
x:("abc";10 5 0;(2;33;(4 5));"blah";1 3);
show "1st, 3rd & 5th"
show x[0 2 4];

show"q11";
show x[;til 2];

show "q12";
x[2]:(4;5);

show "q13";
show (reverse r;r:(x[1];x[0;til 2]));

show "q14";
show d:`a`b`c!(til 3;"some text";3.12345);

show "q15";
show value d;
show count d;
show count each d;
show type d;
show type each d;

show "q16";
d[`c]:21.1;
d[`a;d[`a;-1+count d[`a]]]:3;

show "q17";
m:flip cut[3;1+til 9];

show "q18";
show flip m;

show "q19";
f:{[x;y;z]x[where x=y]:z;x};

m:f[;8;2] each m;








/
