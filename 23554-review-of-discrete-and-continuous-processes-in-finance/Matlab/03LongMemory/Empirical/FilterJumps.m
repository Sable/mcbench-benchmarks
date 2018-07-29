function Data=FilterJumps(Dates,Data,Name)
Chgs=diff(Data);
DatesChgs=Dates(2:end);
ChgsNoJumps=Chgs;
DatesChgsNoJumps=DatesChgs;

Reject=find(abs(Chgs)>7*median(abs(Chgs)));  % reject outliers
ChgsNoJumps(Reject)=[];
DatesChgsNoJumps(Reject)=[];

ChgsJumps=0*DatesChgs;
ChgsJumps(Reject)=Chgs(Reject);

PlotSeries(DatesChgs,Chgs,DatesChgsNoJumps,ChgsNoJumps,ChgsJumps,Name)

Data=cumsum([ChgsNoJumps]);               % reconstruct series

