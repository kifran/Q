/
/TP 
/have to initiate the log file
.[`:taq2010.03.02;();:;()]

h:hopen `:taq2010.03.02

data:(.z.t;`IBM;100f;55)

h enlist (`upd;`trade;data)
hclose h
\

/RTD replaying log
upd:{[t;x]t insert x}
/-11!`:taq2010.03.02


upd_trade:{[x]`trade insert x}
upd_quote:{[x]`quote insert x}
upd:`trade`quote!(upd_trade;upd_quote)

trade:([]time:`time$();sym:`symbol$();price:`float$();size:`int$())
quote:([]time:`time$();sym:`symbol$();bid:`float$();bsize:`int$();ask:`float$();asize:`int$())

replay:{[logfile]
	-11!logfile;
 };

\t replay[`:C:/q_work/data/TP_schema2010.03.02] 
 