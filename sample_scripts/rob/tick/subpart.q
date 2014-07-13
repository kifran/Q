\l schema.q

h: hopen 5010

upd: {[x;y] x insert y}
//- eg neg[h](`sub;(`tablename;syms or `)) to subscribe

neg[h](`sub;(`quote;`AUDUSD`EURUSD))

.z.ps: {show flip x 2;0N!"---";value x} //- monitor updates …
