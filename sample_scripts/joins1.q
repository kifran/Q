/single key
/
show"single key";
lookup:([col1:`a`s`d`f`g]col2:1 2 3 4 5;col3:10 20 30 40 50)
source:([]c1:20?`a`s`d`f`g;c2:20?"ABCDE")

/txf join
/The txf function gives lj behaviour but will work even if common column has a different name in the source table. 
/Like the lj, the lookup table must be keyed

res1:select c1,c2,col2:txf[`lookup;c1;`col2],col3:txf[`lookup;c1;`col3]from source

/lj with xcol
/The same result could be obtained using the lj function as follows:
res2:lj[source;xcol[`c1;lookup]]

show res1~res2;

/foreign key
/another approach would be to create an explicit foreign key on the source table mapping to the key column of the lookup table
/an important feature of the foreign key is that all entires in the common column of the source table must exist
/in the key column of the lookup table. This is not a requirement for the foreign key chase
show"add FK";
\t do[100000;update look:`lookup$c1 from `source];
res3:select c1,c2,look.col2,look.col3 from source

show res2~res3;

/foreign key chase
/another approach would be to do a foreign key chase
res4:delete look from update col2:(lookup([]col1:c1))[`col2],col3:(lookup([]col1:c1))[`col3] from source
show res1~res4;

/which is faster?
show "foreign key";
\t do[100000;res3:select c1,c2,look.col2,look.col3 from source];
show"txf";
\t do[100000;res1:select c1,c2,col2:txf[`lookup;c1;`col2],col3:txf[`lookup;c1;`col3]from source];
show"foreign key chase";
\t do[100000;res4:delete look from update col2:(lookup([]col1:c1))[`col2],col3:(lookup([]col1:c1))[`col3] from source];
show"lj with xcol";
\t do[100000;res2:lj[source;xcol[`c1;lookup]]];

\c 10 150
\
show"composite key";
/composite key
x:`a`s`d`f
y:1 2 3 4
n:100000
c:flip cross[x;y];
lookup2:([col1:`symbol$();col2:`int$()]col3:`int$();col4:`char$());
source2:([]c1:`symbol$();c2:`int$();c3:`char$())
upsert[`lookup2;flip(c[0];c[1];(count c[0])?100;(count c[0])?.Q.A)];
insert[`source2;(n?x;n?y;n?.Q.a)];

/txf join
res1:select c1,c2,c3,col3:txf[`lookup2;(c1;c2);`col3],
	col4:txf[`lookup2;(c1;c2);`col4]from source2

/lj with xcol
/The same result could be obtained using the lj function as follows:
res2:lj[source2;xcol[`c1`c2;lookup2]]

show res1~res2;

/foreign key
show"add FK";
\t do[100;update look:`lookup2$flip(c1;c2) from `source2];
res3:select c1,c2,c3,look.col3,look.col4 from source2

show res1~res3;

/foreign key chase
res4:delete look from update col3:(lookup2([]col1:c1;col2:c2))[`col3],
	col4:(lookup2([]col1:c1;col2:c2))[`col4] from source2
show res1~res4;

/which is faster?
show "foreign key";
\t do[100;res3:select c1,c2,c3,look.col3,look.col4 from source2];
show"txf";
\t do[100;res1:select c1,c2,c3,col3:txf[`lookup2;(c1;c2);`col3],col4:txf[`lookup2;(c1;c2);`col4]from source2];
show"foreign key chase";
\t do[100;res4:delete look from update col3:(lookup2([]col1:c1;col2:c2))[`col3],col4:(lookup2([]col1:c1;col2:c2))[`col4] from source2];
show"lj with xcol";
\t do[100;res2:lj[source2;xcol[`c1`c2;lookup2]]];
/


/links see kdb+ for mortals ch 1.1.5
update link1:`q!q.ticker?t.sym from `t










