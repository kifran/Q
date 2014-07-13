n:1000000
cusips: n?`8
dates:.z.D+n?1000
 
t:([]date:`date$();cusip:`symbol$())
`t insert (dates;cusips)

map:(1+til 12)!(raze string 1+til 9),"OND"

convert:{[dt] year:(string `month$dt)[2 3]; month:map[`mm$dt]; `$month,year}
\t res1:select convert each date from t

convert2:{[dts] years:(string `month$dts)[;2 3]; months:map[`mm$dts]; `$months,'years}
\t res2:select convert2[date] from t

res1~res2
