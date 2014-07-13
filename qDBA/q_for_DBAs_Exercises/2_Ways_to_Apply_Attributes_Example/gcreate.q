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

/\t {[d]show "func1 entered!";`sym xasc .Q.par[`:.;d;`t1]} each date 			/Sort will apply the s attribute

\t {[d]show "func2 entered!";@[`sym xasc .Q.par[`:.;d;`t1];`sym;`g#]} each date		/Apply `g# attributes to the data - use .Q.par to find each table 