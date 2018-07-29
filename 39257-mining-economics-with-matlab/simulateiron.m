years = 8;
steps = 252;
[Date,SYear,Ssim] =  ironoreprice(years,NTrials,steps,model,start);

data = xlsread('demomining.xlsm','B3:K31');
[sales,salesb] = cashflow(data,NTrials,SYear);
[simIR,discFactorY] = interest(years,NTrials,steps);
capex = data(21,1);
[NPV,pd1] = discounting(data,capex,NTrials,sales,discFactorY,salesb);
value = pd1.mean;
% [pabove,pbelow] = probNPV(pd1,value);

pricem = mean(SYear,2)';
salesm = mean(sales,2)';
discFactorY = discFactorY';
NPVm = mean(NPV);