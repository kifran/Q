int1:100; /define var int1
/sarthty
/
snsdn
sdfxnjt
srtn
\

bool1:1b;
bool2:0b;
bools1:(1b;1b;0b);
bools2:(110b);
bools3:110b;


int2:100i;
ints1:(1;2;3;4;5);
ints2:(1 2 3 4 5);
inst3:1 2 3 4 5;

h1:(100;23.4;"g";1b);

short1:100h;
shorts1:(100h;200h;300h);
shorts2:(100 200 300h);
shorts3:100 200 300h;

long1:1000000000j;
longs1:(100000j;2000000j;3000000000j);
longs2:100000 2000000 3000000000j;
longs2:(100000 2000000 3000000000j);

real1:100e;
reals1:(100.3e;200.4e;300.5e);
reals2:(100.3 200.4 300.5e);
reals3:100.3 200.4 300.5e;

float1:23.5;
float2:23.5f;
floats1:(12.3;45.6;67.8);
floats2:(12.3f;45.6f;67.8f);
floats3:12.3 45.6 67.8f;
floats4:12.3 45.6 67.8;

x:(10 20 30;40 50 60;70 80 90);
res:all not 1_differ count each x;

res1:all 
	not 
	1_differ 
	count 
	each x;


char1:"A";
char2:"4";
chars1:("A";"B";"C");
chars2:"ABC";
chars3:"Hello World!";
show chars3;

sym1:`ABC;
syms2:(`ABC;`DEF;`GHI);
syms3:(`ABC`DEF`GHI);
syms4:`ABC`DEF`GHI;

f1:{[a]res:a*a;:res};

g1:100;

ff:{[a]
	g1::0;
	r1:a+1;
	r2:a+2;
	break;
	show"hello";
	r2
  };

f0:{[a;b;c]
	res1:a*b;
    res2:c%a;
	res1-res2
 };

t1:([]
	c1:1 2 3;
	c2:`a`b`c;
	c3:3?.z.D
	)

f1:{[a]
	show"1";
	v1::a*a;
	show"2";
	res2:res1-10;
	res2
 };

f2:{[a;b]
	res1:a*b;
	show"hello";
	res2:a*100;
	show"world";
	:res2;
 };

/
res1:f1[100];

f2:{[a]a*a;};
r2:f2[77];

f3:{x*x};

f4:{[a;b]a-b};

f5:{x-y};

f6:{x-y+2*z};

f7:{x-z};

p1:f7[10;;8];

p2:f6[10];

p3:f6[;;8];

p4:f6[;7;8];

.ns1.f8:{[x;y]
	res1::x+y;
	show"92";
	res2:x-4*y;
	res3:xexp[res2;2];
	res3
 };
 
/f8[10;7]; 
a:100;

f1:{[v]c+10};

f2:{[b;c]f1[c]}















/
