/Define the number of rows to have in the table
n:10000000

/Define a table, t1, full of some random data
t1:([]date:n?.z.D+til 5;sym:n?{[x]`$x} each .Q.a;price:n?100.0;size:100*n?10)

\cd DB

/Save data to disk (could use .Q.dpft here)
{[d]set[`$(":",(string d),"/t1/");.Q.en[`:.;select from t1 where date=d]]} each exec distinct date from t1

/Clear up workspace so we know that we've reloaded t1
delete t1 from `.

/Reload t1 into data
\l .

/Apply `g# attributes to the data
\t {[d]set[`$(":",(string d),"/t1/");.Q.en[`:.;update `g#sym from `sym xasc select from t1 where date=d]]} each date