show"q1";
London_Stations:`Waterloo`Paddington`Euston;
Directions:`South`West`North;

Trains:([]Station:London_Stations;Direction:Directions);

Companies:`Southwest`GNER`Virgin;
Colors:`Blue`Green`Red;

Management:([]Company:Companies;TrainColor:Colors);
show"q2";
Transport:Trains,'Management;
show"q3";
xkey[`Station;`Transport];
show"q4";
Journeys:([]Start:`symbol$();End:`symbol$();Price:`float$());
n:10;
Destinations:-10?`3;
`Journeys insert (10?London_Stations;Destinations;60+10?20f);
/
show"q5";
res5:delete Direction,TrainColor from lj[Journeys;xcol[`Start;Transport]];

show"q6";
NewJourneys:delete from res5;
`NewJourneys insert (2#`Euston;`Glasgow`Bristol;21.1 3.14;2#`Southwest);
res5,NewJourneys;







/