function prepplot(t,x)
% 'Prettify' a downloads-history plot (Utility function)
% Example: none (Oh, the FEX code metrics..)
figure
set(gcf,'Color','w')
ylim = 1.1*max(x); 
set(gca,'XLim',[0 max(t)+1],'YLim',[0 ylim],'XTick',[])
day = {'Fr','Sa','Su','Mo','Tu','We','Th'};
for i = 1:7
    text((24*i)-16,.95*ylim,day{i})
    line([24*(i-1) 24*(i-1)],[0 ylim],'Color',[.8 .8 .8]), hold on  
end  
