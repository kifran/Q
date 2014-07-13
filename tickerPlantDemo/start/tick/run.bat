rem run all rdb

c:
cd \q\start\tick\win
for %%f in (ticker rdb hlcv last tq vwap show feed) do start "%%f" %%f.bat

