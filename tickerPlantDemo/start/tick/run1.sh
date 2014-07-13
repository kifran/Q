#!/bin/bash
# run rdb demo

D=start/tick
Q="rlwrap l32/q"
#cd ~/q
cd /media/myStuff/code/Q/tickerPlantDemo

# load each q process in a new terminal
f() {
 gnome-terminal -t "$1" -e "$Q $2" &
 sleep 0.25
}

# wait for listening port
w() {
for i in `seq 1 20`; do
  S=`netstat -lnt -A inet | grep ":$1"`
  if [ -n "$S" ]; then return 0; fi; sleep 0.25
done
}

case $1 in 
 "ticker" ) f "tickerplant" "$D/ticker.q -p 5010";w 5010 ;;
 "rdb" ) f $1 "$D/cx.q $1 -p 5011" ;;
 "hlcv" ) f $1 "$D/cx.q $1 -p 5014" ;;
 "last" ) f $1 "$D/cx.q $1 -p 5015" ;;
 "tq" ) f $1 "$D/cx.q $1 -p 5016" ;;
 "vwap" ) f $1 "$D/cx.q $1 -p 5017" ;;
 "show" ) f $1 "$D/cx.q $1" ;;
 "feed" ) f "feed" "$D/feed.q localhost:5010 -t 107" ;;
esac
