show"q1";
a:10?20j;
/a:`long$10?20
show type a;

show"q2";
b:10?20j;

show"q3";
c:a,b;

show"q4";
d:(2#a),1_b;

show"q5";
r1:sum c>5;
r2:count c where c>5;
show r1=r2;
\t do[100000;sum c>5];
\t do[100000;count c where c>5];

show"q6";
show c where c>5;

show"q7";
show sum[c[where[>[c;5]]]];
sum c where c>5

show"q8";
show c[where c>5]:0Nj;

show"q9";
show a:5?20h;
show b:10?20h;

show"q10";
\ts do[100000;r1:asc inter[a;b]];
\ts do[100000;r2:asc a[where[in[a;b]]]];
\ts do[100000;r3:asc b where b in a];
show(r1=r2)and(r2=r3);

show"q11";
show union[a;b];

show"q12";
show asc distinct a,b;

show"q13";
show where b in a;

show"q14";
show sum b where b in a;
show"type b";
show type b;
show "type sum b where b in a";
show type sum b where b in a;

show"q15";
b except a;
b where not b in a;













