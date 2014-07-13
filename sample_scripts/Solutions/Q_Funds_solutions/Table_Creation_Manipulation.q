
\c 20 200

show"q1";
t1:([]sym:`a`b`c`d;price:1 2 3 4f);

/show select from t1
/show distinct t1

n:3
data:({`$x}each`char$(til n)+`int$first string `e;5f+til n);
/
insert[`t1;data];

show"q2";
t1,:flip(cols t1)!data;

show"q3";
r1:select from t1 where i=2;
r2:t1[2];
show type each `r1`r2!(r1;r2);

show"q4";
show distinct t1;
show select distinct from t1

show"q5";
t2:update size:0N from distinct t1;
/t2:update size:(count t2)#0N from distinct t1;

show"q6";
xkey[`sym;`t1];

show"q7";
.[{upsert[x;y]};
	(`t2;flip(`a`g;1 2;3 5));
	{show "error was: ",x," because column price is of type float and data is of type int"}
	];

upsert[`t2;flip(`a`g;1 2f;3 5)];

show"q8";

t3:([]sym:`a`b`c`d;price:1 2 3 4f;size:100 200 300 400);
t4:([]sym:`a`c`f;price:11 3 11f;size:100 300 1000);

/
show"a";
r1:inter[t3;t4];
r2:t3 where t3 in t4;
r3:t4 where t4 in t3;
show (r1~r2)&(r2~r3);

show"b";
where t3 in t4;

show"c";
show union[t3;t4];
show ,[t3;t4];

show"d";
r1:except[t3;t4];
r2:t3 where not t3 in t4;
r3:t4 where not t4 in t3;
show (r1~r2)&(r2~r3);
/
show"q9";
t3:1!t3;
xkey[`sym;`t4];

show exec sym from t3=t4 where size=1b;
show exec sym from t3=t4 where size;







/