function [NPV,pd1] = discounting(data,capex,NTrials,sales,discFactorY,salesb)

%discFactorY
costs = data(12:16,2:end);
costsT = sum(costs)';

opprof = sales+repmat(costsT,1,NTrials);
opprofb = salesb'+costsT;

tax = data(18,2:end)'; 
opproftax = opprof+repmat(tax,1,NTrials);
opproftaxb = opprofb+tax; %profit after tax

disccashflow = opproftax.*repmat(discFactorY,1,NTrials);
disccashflowb = opproftaxb.*discFactorY; %discounted cashflow

NPV = sum(disccashflow)+capex;
NPVb = sum(disccashflowb)+capex; %Net Present Value base case

figure('visible','off')
hist(NPV,20);
title(['NPV of ',num2str(NTrials)])

%show dfittool and log normal fit
pd1 = FitNPV(NPV);
title(['NPV of ',num2str(NTrials),' simulations'])
xlabel('10''s millions')
VAR = pd1.icdf(0.05);
% Plotting Probability Levels
hold on
yl = ylim;
hm = plot([pd1.mean,pd1.mean],yl,'g-o','LineWidth',2);
hv = plot([VAR,VAR],yl,'r-o','LineWidth',2);


%Probability Analysis
basecasenpv = 0; 
probbase_b = pd1.cdf(basecasenpv); %Probability of below 0 NPV
h0 = plot([0,0],yl,'b-o','LineWidth',2);

hb = plot([NPVb,NPVb],yl,'m-o','LineWidth',2);
legend([hm,hv,h0,hb],['Mean Level: $',num2str(round(pd1.mean/1000)),'mill'],...
    ['VAR 5%: $',num2str(round(VAR/1000)),'mill'],...
    ['Probability <0: ',num2str(round(100*probbase_b)),'%'],...
    ['Base Case Iron Ore $108 per tonne']);

if isdeployed
    print -dmeta
    close(gcf)
end