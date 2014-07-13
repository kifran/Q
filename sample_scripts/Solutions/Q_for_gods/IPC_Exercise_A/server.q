/server
trade:([]time:`time$();sym:`symbol$();price:`float$());

/define stored proc
proc1:{[s]select from trade where sym=s};