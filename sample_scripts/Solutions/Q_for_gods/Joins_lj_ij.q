show"q1";
trade:([]sym:`symbol$();price:`float$();size:`int$());
syms:`A`B`C`D;
`trade insert (10?syms;10?100f;10?100);
industry:([sym:`A`B`C`E];ind:`IT`Finance`Media`Transport);
show"q2";
res:ij[trade;industry];

show"q3";
trade2:lj[trade;industry];

show"q4";
newInd:([sym:`A`C]ind:`Transport`Healthcare;Ex:`N`P);
res:lj[trade2;newInd];

show"q5";
res:ij[trade2;newInd];

show"q6";
tab0:([]a:1 2 3 2;b:`x`y`z`x);
tab1:([]a:3 3 2 2;c:`a`b`c`d);
res1:ungroup lj[tab1;select b by a from tab0];

show"ej solution";
res2:ej[`a;tab1;tab0];

show"q7";
phoneNum:([Name:`Tom`Bob`Tom`Bob;Date:2007.06.01 2007.06.01 2008.01.01 2008.06.01]phNum:336699 123456 999999 778899);
data:([]Name:4#`Bob;Date:(2007.06.02;2008.01.01;2008.01.02;.z.D));
res1:aj[`Name`Date;data;xkey[();phoneNum]];

show"step function solution"
`Name`Date xasc `phoneNum
y:`s#phoneNum
res2:y each data
show"aj time";
\t do[10000;r1:aj[`Name`Date;data;xkey[();phoneNum]]];
show"step function time";
\t do[10000;r2:y each data];

/