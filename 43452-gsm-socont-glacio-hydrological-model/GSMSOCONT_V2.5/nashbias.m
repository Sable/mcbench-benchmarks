function [nash,nashlog,bias]=nashbias(obs,sim,writeoff)

% function to compute the Nash-Sutcliffe index and bias, see
% Nash, J. E., and Sutcliffe, J. V.: River flow forecasting through 
% conceptual models. Part I, a discussion of principles, Journal of 
% Hydrology, 10, 282-290, 10.1016/0022-1694(70)90255-6 1970.
% see also:
% Schaefli, B., and Gupta, H.: Do Nash values have value?, Hydrological 
% Processes, 21, 2075-2080, 10.1002/hyp.6825, 2007.


if nargin<3
    writeoff=0;
end
ktest=find(obs<0);
if isempty(ktest)
else
    if writeoff==0
        'Series contains neg. values'
    end
    
end
ksim=find(sim<=0);
simlog=sim;
simlog(ksim)=0.0001;

ym=mean(obs);                         % Nash classic
vome=sum((obs-ym).^2);                % Nash classic
vomo=sum((sim-obs).^2);               % Nash classic



k=find(obs>0);                                  
lym=mean(log(obs(k)));                          % Nash log
vomle=sum((log(obs(k))-lym).^2);                % Nash log
vomlo=sum((log(simlog(k))-log(obs(k))).^2);     

nash=1-(vomo/vome);
nashlog=1-(vomlo/vomle);
bias=(sum(obs-sim)./sum(obs)); %
