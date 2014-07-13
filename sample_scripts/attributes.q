/
This script explores the performance of the 4 different attributes from a 
timing an memory perspective
for queries against columns of different distributions of data

column c1 - til n
this column is made up of an ascending list of distinct integers
Therefore any of the 4 attributes could be applied to this column

\
\c 10 150
n:10000000
t:([]c1:til n;c2:asc n?.Q.a;c3:n?`IBM`GS`VOD`GOOG`YHOO,-2000?`6);
/
show "TEST1 - column c1. unique data set";

/test column c1
show"no attribute";
t1:(system"t do[10;select from t where c1=1]")%10;
t2:(system"t do[10;select from t where c1=`int$n%2]")%10;
t3:(system"t do[10;select from t where c1=n-1]")%10;

show .Q.w[];

show"apply s attribute";
\ts update `s#c1 from `t;
show .Q.w[];
show"run queries";
t4:(system"t do[100000;select from t where c1=1]")%100000;
t5:(system"t do[100000;select from t where c1=`int$n%2]")%100000;
t6:(system"t do[100000;select from t where c1=n-1]")%100000;


show"apply u attribute";
update `#c1 from `t;
\ts update `u#c1 from `t;
show .Q.w[];

show"run queries";
t7:(system"t do[100000;select from t where c1=1]")%100000;
t8:(system"t do[100000;select from t where c1=`int$n%2]")%100000;
t9:(system"t do[100000;select from t where c1=n-1]")%100000;

show"apply p attribute";
\t update `p#c1 from `t;
show .Q.w[];
show"run queries";
t10:(system"t do[100000;select from t where c1=1]")%100000;
t11:(system"t do[100000;select from t where c1=`int$n%2]")%100000;
t12:(system"t do[100000;select from t where c1=n-1]")%100000;

show"apply g attribute";
\t update `g#c1 from `t;
show .Q.w[];
show"run queries";
t13:(system"t do[100000;select from t where c1=1]")%100000;
t14:(system"t do[100000;select from t where c1=`int$n%2]")%100000;
t15:(system"t do[100000;select from t where c1=n-1]")%100000;

update `#c1 from `t;

show "TEST2 - column c2";
show .Q.w[];

show"s attribute";
show"run queries";
\t do[100;select from t where c2="a"];
\t do[100;select from t where c2="n"];
\t do[100;select from t where c2="z"];

show"apply p attribute";
\t update `p#c2 from `t;
show .Q.w[];
show"run queries";
\t do[100;select from t where c2="a"];
\t do[100;select from t where c2="n"];
\t do[100;select from t where c2="z"];

show"apply g attribute";
\t update `g#c2 from `t;
show .Q.w[];
show"run queries";
\t do[100;select from t where c2="a"];
\t do[100;select from t where c2="n"];
\t do[100;select from t where c2="z"];
\

show "TEST3 - column c3";
update `#c1 from `t;
update `#c2 from `t;
show .Q.w[];
show"run queries";
\t do[100;select from t where c3=`IBM];
show"build g attribute";
\t do[10;update `g#c3 from `t];
show .Q.w[];
show"run queries";
\t do[100;select from t where c3=`IBM];






/