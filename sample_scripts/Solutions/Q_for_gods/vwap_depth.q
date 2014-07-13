
\c 12 110
/this quote table contains depth data
quote:([]
		time:`time$();
		sym:`symbol$();
		bid1:`float$();
		bsize1:`int$();
		bid2:`float$();
		bsize2:`int$();
		bid3:`float$();
		bsize3:`int$();
		bid4:`float$();
		bsize4:`int$();
		bid5:`float$();
		bsize5:`int$();
		bid6:`float$();
		bsize6:`int$();
		bid7:`float$();
		bsize7:`int$();
		bid8:`float$();
		bsize8:`int$();
		bid9:`float$();
		bsize9:`int$();
		bid10:`float$();
		bsize10:`int$()
		);

vsize:800		/volume we want to sell			
depth:10	/depth we are willing to go to to sell vsize units

	
quote1:flip({[x]`$"bsize",string x}each 1+til depth)!
	depth#enlist `int$()	
	
n:600000
syms:`IBM`MSFT`GOOG;

`quote insert (9t+n?8t;n?syms;
				90+n?10f;n?1000;
				80+n?10f;n?1000;
				70+n?10f;n?1000;
				60+n?10f;n?1000;
				50+n?10f;n?1000;
				40+n?10f;n?1000;
				30+n?10f;n?1000;
				20+n?10f;n?1000;
				10+n?10f;n?1000;
				n?10f;n?1000
				);

/add a column vwap which will give the moving vwap 
/for a certain desired trade size
/use up all the size from the top level bid 
/and then take the appropriate size from
/the next levels

approach1_inner:{[row;vsize;bid_names;bsize_names;depth]
	/yyy;
	bsizes:row[bsize_names];	
	bids:row[bid_names];
	/yyy;
	$[(first bsizes)>=vsize;:vwap:first bids;
	[
	sums_bsizes:sums bsizes;
	/yyy;
	remaining_bsize:vsize-last 
	sums_bsizes[where sums_bsizes<vsize];
	desired_bsizes:bsizes[where sums_bsizes<vsize],
	remaining_bsize;
	/yyy;
	desired_bids:bids[til count desired_bsizes];
	vwap:(sum desired_bids*desired_bsizes)%(sum desired_bsizes where not null desired_bids);
	vwap1:wavg[desired_bsizes;desired_bids];
	]];
	vwap
 };	

approach1_outer:{[vsize;depth]
	bsize_names:{[x]`$"bsize",string x}each 1+til depth; 
	bid_names:{[x]`$"bid",string x}each 1+til depth;
	/break;
	calc_vwap:approach1_inner[;vsize;bid_names;bsize_names;depth] peach quote;
	update vwap:calc_vwap from `quote;
	quote::xcols[`time`sym`vwap;quote];
	};
	
show"1 column per level approach";	
\t approach1_outer[vsize;depth];

/1 column with all depth data
nested_quote:select time,sym,
			bid:flip[(bid1;bid2;bid3;bid4;bid5;bid6;bid7;bid8;bid9;bid10)],
			bsize:flip[(bsize1;bsize2;bsize3;bsize4;bsize5;bsize6;bsize7;bsize8;bsize9;bsize10)]
			from quote;

approach2_inner:{[row;vsize;depth]
	bsizes:depth sublist row[`bsize];	
	bids:depth sublist row[`bid];
	$[(first bsizes)>=vsize;:vwap:first bids;
	[
	sums_bsizes:sums bsizes;
	remaining_bsize:vsize-last sums_bsizes[where sums_bsizes<vsize];
	desired_bsizes:bsizes[where sums_bsizes<vsize],remaining_bsize;
	desired_bids:bids[til count desired_bsizes];
	vwap:(sum desired_bids*desired_bsizes)%(sum desired_bsizes where not null desired_bids);
	vwap1:wavg[desired_bsizes;desired_bids];
	/if[not vwap~vwap1;yyy]
	]];
	vwap
 };
show"One nested column with all levels approach";

approach2_outer:{[vsize;depth]
	calc_vwap:approach2_inner[;vsize;depth] peach nested_quote; 
	update vwap:calc_vwap from `nested_quote;
	nested_quote::xcols[`time`sym`vwap;nested_quote];
 };

\t approach2_outer[vsize;depth];

show "check";
show (quote[`vwap])~(nested_quote[`vwap]);

			
			




/(quote[`vwap])[3]
/((619*3.873427)+(181*19.7224))%800	;