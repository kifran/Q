h1:hopen 5001

show"Question 2";
(neg h1)"`trade insert ([]time:enlist .z.T;sym:enlist `IBM;price:enlist 100f)"

show"Question 3";
n:2
(neg h1)(insert;`trade;(n?.z.T;n?`1;n?100f;n?1000))

show"Question 4";
t1:h1"select from trade";

show"Question 5";
(neg h1)"quote:([]time:`time$();sym:`symbol$();bid:`float$();ask:`float$())"

(neg h1)(set;`quote;([]time:`time$();sym:`symbol$();bid:`float$();ask:`float$()))

h1("f1";12;2)








/
