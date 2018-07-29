function AnalyzePersistence(Data,AggregationPersistence,LagsSamplAutCorr,Name)

for n=1:length(AggregationPersistence)
    Series_Changes(n).Lag=AggregationPersistence(n);
    SamplAutoCorrs=[];
    
    for s=1:AggregationPersistence(n)
        
        Sparse=Data(s:AggregationPersistence(n):end);
        Changes=diff(Sparse);
        SamplAutoCorrs = autocorr(Changes, LagsSamplAutCorr);
        SamplAutoCorrs(1)=[];
    end
    Series_Changes(n).SampleAutocorrelation=mean(SamplAutoCorrs,2);
end

SampleAutocorrelations=[];
for n=1:length(AggregationPersistence)
    SampleAutocorrelations=[SampleAutocorrelations Series_Changes(n).SampleAutocorrelation];
end

figure
bar3(SampleAutocorrelations,'detached')
set(gca,'xlim',[AggregationPersistence(1) AggregationPersistence(end)],'ylim',[1 LagsSamplAutCorr],...
    'zlim',[-.2 .4])
xlabel('aggregation size (days)')
ylabel('lag')
zlabel('autocorrelation')
colormap(.5*(1+gray));
set(gcf,'Name',['        persistence properties of ' Name ' par swap rate'])

