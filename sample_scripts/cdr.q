
\c 10 160

cdr:([]
	timestamp:`datetime$();
	domain:();
	duration:`int$();
	direction:`$();
	pbx_id:();
	cost:`float$()
 );
 
n:100000; /n is number of records

f:{(5+rand 20)?.Q.A};
domains:(f each til n div 50),\:".com";
directions:`inbound`outbound`onnet
pbx_ids:{5?raze .Q.A,string til 10}each til (n div 50);

data:(.z.D+n?0t;n?domains;n?60*60;n?directions;n?pbx_ids;n?100f);

`cdr insert data
`timestamp xasc `cdr