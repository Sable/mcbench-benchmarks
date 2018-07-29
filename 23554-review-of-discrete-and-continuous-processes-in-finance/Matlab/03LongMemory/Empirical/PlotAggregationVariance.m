function PlotAggregationVariance(AggregationVariance,SimulSecMoms,SecMom_Empirical,...
    SecMom_Annualized,NumSimulations,b,s_2,Name)
figure
for n=1:NumSimulations
    hold on
    h=plot(AggregationVariance,SimulSecMoms(:,n),'.');
    set(h,'color','k','markersize',1)
end
hold on
h=plot(AggregationVariance,SecMom_Empirical);
set(h,'color','r','linewidth',2);
hold on
h=plot(AggregationVariance,SecMom_Annualized);
set(h,'color','k','linewidth',2);
set(gca,'ytick',[],'xlim',[AggregationVariance(1) AggregationVariance(end)])
grid on
xlabel('aggregation size (days)')
ylabel('aggregated variance')
set(gcf,'Name',['               long memory of ' Name ' par swap rate'])


figure 
h2=plot(log(AggregationVariance),log(SecMom_Empirical),'.');
%set(h,'color','k');
hold on 
%h2=plot(log(AggregationVariance),b(1)+b(2)*log(AggregationVariance),'r');
hold on 
y_norm=log(s_2)+log(AggregationVariance);
h3=plot(log(AggregationVariance),y_norm,'k');
grid on
legend([h2 h3],['frac. B. m.: H=' num2str(b(2)/2)],'B. m.: H=0.5','location','northwest')
xlabel('log-aggregation size (days)')
ylabel('log-aggregated variance')
set(gcf,'Name',['               long memory of ' Name ' par swap rate'])
