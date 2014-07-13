/trades
tcol_names:`ticker`ubstime`extime`shares`price`ex

data:0:[("SII   IFC";"|");`:C:/q_work/UBS_CT_Feb2011/data/kdb_sample.cts.reduced/kdb_sample.cts.reduced];

trades:flip tcol_names!data;
update `time$ubstime,`time$extime from `trades

/QUOTES
qcol_names:`ticker`ubstime`extime`bsize`bid`asize`ask`ex

data:0:[("SII   IFIFC";"|");`:C:/q_work/UBS_CT_Feb2011/data/kdb_sample.cqs.reduced/kdb_sample.cqs.reduced];
quotes:flip qcol_names!data;
update `time$ubstime,`time$extime from `quotes

portfolio:exec distinct ticker from quotes;
times:exec stime:min ubstime,etime:max ubstime from quotes;

/st:times[`stime]
/et:times[`etime]

st:09:28t
et:16t

times:`minute$st+(00:01t)*til`int$(et-st)%(00:01t);

empty:flip `ubstime`ticker!flip cross[times;portfolio];

res1:select by ubstime:ubstime.minute,ticker from quotes;
res2:lj[empty;res1];
update fills extime,fills bsize by ticker from `res2;
res3:update fills extime,fills bsize by ticker from res2;





/