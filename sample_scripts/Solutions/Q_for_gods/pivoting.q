/1)
/Clue: First get the set of values that you need:

tab:([] c0:`a`b`c`a`b`c;c1:`b`a`a`c`c`b;c2:1 2 3 4 5 6)
myvals:asc distinct tab.c1

/Next, try to use a dictionary type construction to obtain the value of c2 for each of myvals.

exec (c1!c2)myvals from tab
/2 1 4

/Now, from this, build a dictionary with respect to myvals and then get a grid of values with respect to c0 
/and see what happens.

exec myvals!(c1!c2)myvals by corner:c0 from tab 
/
corner| a b c
------| -----
a     |   1 4
b     | 2   5
c     | 3 6
\

/Nearly there, how is the table “filled” out…..


/0^exec myvals!(c1!c2)myvals by corner:c0 from tab
/
corner| a b c
------| -----
a     | 0 1 4
b     | 2 0 5
c     | 3 6 0
\

/Of course, depending on what you are pivoting, you can fill it out with whatever you like. 
/(As long as the type is ok!)

/2)
/As before, first get the distinct, sorted values for our rows & columns

/Then, use the same construction to get:
/Notice anything strange about this? There are only 5 non-zero values as there were 2 transfers from ManU to Real.

/3)
/We could aggregate the amounts using the sum function and then use the same construction. 

/Where the 2 transfers mentioned earlier are now aggregated. 
/It is now a simple matter to obtain the previous pivot table, but with all info contained in it.



 
