/ use INSTEAD of an rdb to append data to disk partition during day and use that to build historical partition at day end 
/ q tick/w.q [tickerplanthost]:port[:usr:pwd] [hdbhost]:port[:usr:pwd] [-koe|keeponexit]
/ -keeponexit|koe - keep the (partial) contents of TMPSAVE directories on exit (default NO)
/ tmp storage in `:{pwd-after-logsync}/../tmp.pid.yyyy.mm.dd
/ 2009.09.04 add disksort, faster disk-table sort on slower drives
/ 2008.11.30 add .z.exit and -keeponexit

getTMPSAVE:{`$":../tmp.",(string .z.i),".",string x}  
TMPSAVE:getTMPSAVE .z.d
MAXROWS:100000
KEEPONEXIT:any`keeponexit`koe in key .Q.opt .z.x


append:{[t;data]
	t insert data;
	if[MAXROWS<count value t;
		/ append enumerated buffer to disk
		.[` sv TMPSAVE,t,`;();,;.Q.en[`:.;`. t]; 
		/ clear buffer
		@[`.;t;0#]; 
		]}
upd:append


/*********************************************************************************************************
/
Function: disksort
Summary:
Alternative disk sort function to xasc. It is generally faster than the standard xasc approach because
it doesn't automatically sort all columns - it instead makes sure that the sort is strictly necessary.

Where is it used: inside .u.end

3 inputs:
1st input: t - file descriptor to splayed table which needs to be sorted 
2nd input: c - column to sort on
3rd input: a - attribute to apply to on disk column

Output:File Descriptor of sorted on disk splayed table

Example Usage: disksort[`:db5/trade/;`sym;`p#]

\
disksort:{[t;c;a] 
	if[not`s~attr(t:hsym t)c; /check to see if the splayed table is already sorted on c. If so, don't waste time sorting again
		if[count t; /will also be true
			ii:iasc iasc flip c!t c,:(); /obtain the mappings from new sorted indices to old indices
			if[not$[(0,-1+count ii)~(first;last)@\:ii;@[{`s#x;1b};ii;0b];0b]; /Check if first and last datapoints are the same. If so, no point in sorting
				{[x;y]
					v:get y; /load in the data for the current column. Time for example
					if[not
						$[all(fv:first v)~/:256#v; /Check if the first 256 elements in the column are the same
							all fv~/:v; /If so, check f all elements in the column are the same ->no need to sort
							0b];
						v[x]:v;y set v]; /important part - re assigning column's data using sorted indices
					}[ii]each` sv't,'get` sv t,`.d]];
						@[t;first c;a]]; /Apply `p attribute to sorting column
						t /return fiel descriptor to splayed table
			};
/*********************************************************************************************************

/ get the ticker plant and history ports, defaults are 5010,5012
.u.x:.z.x,(count .z.x)_(":5010";":5012")

.u.end:{ / end of day: save, clear, sort on disk, move, hdb reload
	t:tables`.;t@:where 11h=type each t@\:`sym;
	/ append enumerated buffer to disk
	{.[` sv TMPSAVE,x,`;();,;.Q.en[`:.]`. x]}each t;
	/ clear buffer
	@[`.;t;0#];
	/ sort on disk by sym and set `p#
	{@[`sym xasc` sv TMPSAVE,x,`;`sym;`p#]}each t;
	/{disksort[` sv TMPSAVE,x,`;`sym;`p#]}each t;
	/ move the complete partition to final home, use <mv> instead of built-in <r> if filesystem whines
	system"r ",(1_string TMPSAVE)," ",-1_1_string .Q.par[`:.;x;`];
	/ reset TMPSAVE for new day
	TMPSAVE::getTMPSAVE .z.d;	
	/ and notify hdb to reload and pick up new partition
	if[h:@[hopen;`$":",.u.x 1;0];h"\\l .";hclose h];	
	}

.z.exit:{ / unexpected exit: clear, wipe TMPSAVE contents (doesn't rm the directory itself)
	if[not KEEPONEXIT;
		t:tables`.;t@:where 11h=type each t@\:`sym;
		/ clear buffer                          
		@[`.;t;0#];
		/ overwrite written-so-far-today data with empty
		{.[` sv TMPSAVE,x,`;();:;.Q.en[`:.]`. x]}each t;
		]}

/ init schema and sync up from log file;cd to hdb (so client save can run)
.u.rep:{(.[;();:;].)each x;if[null first y;:()];system "cd ",1_-10_string first reverse y;-11!y;}
/ HARDCODE \cd if other than logdir/db

/ connect to ticker plant for (schema;(logcount;log))
.u.rep .(hopen `$":",.u.x 0)"(.u.sub[`;`];`.u `i`L)"
