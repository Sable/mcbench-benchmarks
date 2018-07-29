%Plottradeguide by Nagi Hatoum,Copyright March 2004
%
%%plots the results of tradeguide
%%time series must be column-wise
%%C=Close; O=open;H=High;L=Low
%%stock_name is the stock's title in string form.
function plottradeguide(C,O,H,L,stock_name);
%%%%%%%%%%%%%%harikiri%%%%%%%%%%%%%%%%%%%%%%%%%%%
P=mean([C,O,H,L],2);
[buy,sell,tp,changemarker]=tradeguide(C,O,H,L);
%%%%%%%%%%%%%%%%%%%%%%%%%%%adjust trade command%%
%tp=[tp;tp(end)];%add termination codon to signal end of time series
dtp=[diff(tp)];
ntp=find(abs(dtp)==1);
dtp=[dtp(ntp(1))*-1;dtp(1:end-1);dtp(ntp(end))*-1];
ntp=find(abs(dtp)==1);
%%%%%%%%%%%%%%%find trend lines%%%%%%%%%%%%%%%%%%
cb=1;cs=1;buys=[];sells=[];
for i=1:length(ntp)-1
    xt=[ntp(i):ntp(i+1)]';
    chx(i)=dtp(ntp(i));
    if dtp(ntp(i))==1 %uptrend
        [coef]=polyfit(xt,L(xt),1);
        bx{cb}=xt;
        buys{cb}=polyval(coef,xt);
        cb=cb+1;
    else %downtrend
        [coef]=polyfit(xt,H(xt),1);
        sx{cs}=xt;
        sells{cs}=polyval(coef,xt);
        cs=cs+1;
    end
end
%%%%%%%%%%%%%%%plot stock%%%%%%%%%%%%%%%%%%%%%%%%%
cndl(H,L,O,C)
hold on
title(stock_name)
plot(sell,P(sell),'r.')
plot(buy,P(buy),'g.')
for i=1:cb-1
    line(bx{i},buys{i},'color','b','LineWidth',4)
end
for i=1:cs-1
    line(sx{i},sells{i},'color','r','LineWidth',4)
end
zoom on
hold off
