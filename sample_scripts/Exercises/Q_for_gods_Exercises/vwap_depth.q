// Build a simplified real time quote table containing bids and bid sizes at 5 levels of depth:
/ q)meta quote
/ c     | t f a
/ ------| -----
/ time  | t
/ sym   | s
/ bid1  | f
/ bsize1| i
/ bid2  | f
/ bsize2| i
/ bid3  | f
/ bsize3| i
/ bid4  | f
/ bsize4| i
/ bid5  | f
/ bsize5| i

quote:([]
        time: `time$();
        sym:  `$();
        bids: `float$();
        sizes:`int$()  
 );

n:1000;
m: 1+n?1+5;

// Populate with random data
quote:([] 
       time:asc n?.z.T; 
       ticker:n?`MS`GS`GOOG`EDF;
       bids:{desc x?100} each m;
       sizes:{desc x?100} each m);

// For a given trade size S,
/ calculate the vwap to sell S units in the table

/ q)10 -\ til 10
/ 10 9 7 4 0 -5 -11 -18 -26 -35
/ q)where 0=(10 -\ til 10)
/ ,4
/ q)where 0>=(10 -\ til 10)
/ 4 5 6 7 8 9

sellSize: 150;
sellTick:`GOOG;



//update depth: max each where each 0 <= {150 -\ x} each quote[`sizes] from `quote;
//update vwap: ({150-\x} quote[
