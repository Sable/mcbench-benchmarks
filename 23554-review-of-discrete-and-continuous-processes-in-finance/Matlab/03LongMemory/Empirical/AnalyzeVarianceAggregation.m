function AnalyzeVarianceAggregation(Dates,Data,AggregationVariance,Annualize_Lag,NumSimulations,Name)

Keep=[]; 
PivotSeries=Data(1:Annualize_Lag:end); PivotChanges=PivotSeries(2:end)-PivotSeries(1:end-1);
s_2=PivotChanges'*PivotChanges/length(PivotChanges)/Annualize_Lag;
for n=1:length(AggregationVariance)
    
    Series_Changes(n).Lag=AggregationVariance(n);
    Means=[]; Stdvs=[]; SecMoms=[];
    Drop=1;
    for s=1:AggregationVariance(n)
        Sparse=Data(s:AggregationVariance(n):end);
        Changes=(Sparse(2:end)-Sparse(1:end-1));
        
        if (length(Changes)>20)  % analysis only if data is sufficient
            Drop=Drop*0;    
            Means=[Means mean(Changes)];
            Stdvs=[Stdvs std(Changes)];
            SecMoms=[SecMoms var(Changes)];
        end
    end
    
    if ~Drop
        Keep=[Keep n];
        Series_Changes(n).Mean=mean(Means);
        Series_Changes(n).Sd=mean(Stdvs);
        Series_Changes(n).SecMom=mean(SecMoms);
        
    end
end

% generate simulated AR(1) normal shocks processes
T=length(Dates); 
Phi=0; 
Shocks=sqrt(s_2)*normrnd(0,1,T,NumSimulations); 
Dc=Shocks; 
for t=1:T-2   
   Dc(t+1,:)=Phi*Dc(t,:)+Shocks(t+1,:); 
end    
SimulProcess=cumsum(Dc);

AggregationVariance=AggregationVariance(Keep);
PickAnnualize_Lag=find(AggregationVariance==Annualize_Lag);
Means_Empirical=[];
StDevs_Empirical=[];
SecMom_Empirical=[];
SimulSecMoms=[];
for n=1:length(Keep)
    Means_Empirical=[Means_Empirical Series_Changes(Keep(n)).Mean];
    StDevs_Empirical=[StDevs_Empirical Series_Changes(Keep(n)).Sd];
    SecMom_Empirical=[SecMom_Empirical Series_Changes(Keep(n)).SecMom];
    SimulSparse=SimulProcess(1:AggregationVariance(Keep(n)):end,:);
    SimulChanges=(SimulSparse(2:end,:)-SimulSparse(1:end-1,:));
    
    SimulSecMoms=[SimulSecMoms % analyze second moment of generated process
        var(SimulChanges)];
    
    
end
StDevs_Annualized=StDevs_Empirical(PickAnnualize_Lag)/sqrt(Annualize_Lag)*sqrt(AggregationVariance);
SecMom_Annualized=SecMom_Empirical(PickAnnualize_Lag)/Annualize_Lag*AggregationVariance;

% estimate Hurst coefficient
yyy=log(SecMom_Empirical(1:50)');
XXX=[ones(50,1) log(AggregationVariance(1:50)')];
b = regress(yyy,XXX);
H=b(2)/2;

PlotAggregationVariance(AggregationVariance,SimulSecMoms,SecMom_Empirical,...
    SecMom_Annualized,NumSimulations,b,s_2,Name)
