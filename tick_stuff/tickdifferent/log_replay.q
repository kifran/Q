/USE THIS .U.REP INSTEAD IF THE USER WANTS THE SUBSCRIBER TO SAVE HDB TO THE DIRECTORY IN THE INPUT PARAMETER .Z.X 2
.u.rep:{(.[;();:;].)each x;if[null first y;:()];-11!y;system "cd ",.z.x 2};


upd_quote_replay:{[x]
	`TP_ALL_QUOTES insert x;
	z:(select last time,last bid_price,last ask_price,last bid_yield,last ask_yield,last bid_sz,last ask_sz by sym,offer_id,feed from TP_ALL_QUOTES where not 0=ask_sz,not 0N=ask_sz,not `P=status);
	`CURRENT_QUOTES upsert z;  
 };
 
upd_security_replay:{[x]
	`TP_SECURITY insert x;
	`SECURITY upsert select last position by sym from TP_SECURITY;
	delete from `TP_SECURITY;
	/`SECURITY upsert get_security_java[exec sym from SECURITY];
 };

upd_book_replay:{[x]
	 `TP_BOOK insert x;
	`BOOK upsert select last book by sym from TP_BOOK;
	delete from `TP_BOOK;
 };

regenerate_best_quotes:{
	show "regenerate_best_quotes";
	`BEST_QUOTES upsert select best_bid:max bid_price, best_ask:min ask_price,
		bb_yield:max `real$(bid_price=max bid_price)*bid_yield, ba_yield:max `real$(ask_price=min ask_price)*ask_yield,
		bb_size:max(bid_price=max bid_price)*bid_sz, ba_size:max(ask_price=min ask_price)*ask_sz
		by sym from CURRENT_QUOTES; 
 };

/remove quotes from CURRENT_QUOTES if a bad quote arrived later
remove_bad_quotes:{
	show "remove_bad_quotes";
	bad_quotes:(select bad_time:last time by sym,offer_id,feed from TP_ALL_QUOTES where (status=`P)or(ask_sz=0)or(ask_sz=0N));
	test_quotes:CURRENT_QUOTES lj bad_quotes;
	CURRENT_QUOTES::delete bad_time from(delete from test_quotes where time<bad_time);
	delete from `TP_ALL_QUOTES;
 };

upd:`TP_ALL_QUOTES`TP_BOOK`TP_SECURITY!(upd_quote_replay;upd_book_replay;upd_security_replay);

/ connect to ticker plant for (schema;(logcount;log))
.u.rep .(hopen `$":",.u.x 0)"(.u.sub[`;`];`.u `i`L)";

remove_bad_quotes[];
regenerate_best_quotes[];
