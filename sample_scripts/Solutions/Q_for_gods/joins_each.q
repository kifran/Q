/1)

/i)
1 2 3,'4
/result is: (1 4;2 4;3 4)

/ii)
1 2 3 ,' 4 5 6
/result is: (1 4;2 5;3 6)

/iii)
"abc",'"def"
/result is: ("ad";"be";"cf")

/iv)
t:([]a:("one";"three");b:("two";"four"))
show update c:(a,'b)from t;
/
result is: 
a       b      c
--------------------------
"one"   "two"  "onetwo"
"three" "four" "threefour"
\
/v)
t1:([]a:1 2)
t2:([]b:`one`two)
show t1,'t2;
/
result is: 
a b
-----
1 one
2 two
\