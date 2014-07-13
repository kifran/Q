/EXAMPLE SCRIPT TO CREATE TRADE AND QUOTE DATE PARTITIONED TABLES.
/q table_gen.q -dir mydbparroot -perday 1000000 -startday 2009.01.01 -noday 5

/Read command line arguments into dictionary args

args:.Q.opt .z.x

/Assign the command line argument perday to pd and noday to nd. 
/Use "I"$ to cast to an integer - `int$ or "i"$ return ascii values
pd:"I"$first args[`perday]
nd:"I"$first args[`noday]

/Assign the command line argument startday to sd.
/Use "D"$ to cast to a date - `date$ or "d"$ operate on individual characters
sd:"D"$first args[`startday]

/Assign the command line argument, dir to dir. Cast to symbol
/Use hsym to ensure there is a ":" at the front
dir:hsym[`$first args[`dir]]

/Define trade and quote empty tables. Use casting to prevent incorrect value entry 

trade:([]time:`time$();sym:`symbol$();price:`float$();size:`int$())

/Insert pd rows into each table. Use pd?(time/int/float/symbol list) or ?[pd;time/int/float/symbol list] to
/generate pd random entries. Insert can insert one at a time or in-bulk
/We will insert records in time order using the asc command
insert[`trade;(asc ?[pd;23:59:59.999];?[pd;`a`b`c`d`e`f`g`h`i`j];?[pd;100.0];?[pd;1000])]

/Write trade and quote to disk. Add a date partition for a choice of dates
/dpft takes 4 inputs: 	directory to write to (input parameter "-dir")
/			partition to write to (the date in this case)
/			field to sort on
/			table to write to disc
/we can use each to pass multiple items into a function one at a time
/to generate a list of dates we can use til - til n generates the list of integers from 0 to n
dates:sd + til nd
.Q.dpft[dir;;`sym;`trade] each dates
