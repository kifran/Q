
/pass in name of log file as command line arguement eg:
/q loadlog.q -log log1

args:.Q.opt[.z.x];
args[`log]:hsym `$first args[`log];

badmsgs:();

trade:([]time:`time$();sym:`symbol$();price:`real$();size:`int$())
quote:([]time:`time$();sym:`symbol$();bid:`real$();ask:`real$();bsize:`int$();asize:`int$())
depth:([]time:`time$();sym:`symbol$();
    bid1:`real$();bid2:`real$();bid3:`real$();bid4:`real$();bid5:`real$();
    ask1:`real$();ask2:`real$();ask3:`real$();ask4:`real$();ask5:`real$();
    bsize1:`int$();bsize2:`int$();bsize3:`int$();bsize4:`int$();bsize5:`int$();
    asize1:`int$();asize2:`int$();asize3:`int$();asize4:`int$();asize5:`int$())

upd:insert

upd:{[t;x]current_t::t;current_x::x;.[{[tbl_name;data]tbl_name insert data};(t;x);{[error]show "error is: ",(error);badmsgs,:enlist(error;current_t;current_x)}]}; 

-11!args[`log]
