% Moeti Ncube: Markov Chain model for regime switching time series
% 
% This model was build for data that tends to fluctuate between different regimes. The data I used in this example is assumed to come from three regimes: 1-full generation, 2-partial generation, 3-little to no generation. The
% %model works as follows:
% 1) I split the observable data into three partitions as determined by vector 'perc', (any number of partitions can be assigned here). 
% 2) I compute an empirical markove chain based on the observable data and my partition space. For example I find the percentage of all observation in my dataset that are at full generation at time t and remain there at time t+1, this gives me p(1,1). I then find the percentage of all observations that are at full generation at time t and go the partial generation at time t+1, this gives me p(1,2)... I continue in this way until i have a 3x3 transition matrix for the data
% 3) I can now generate simulated states [1,2,3] from my empirical transition matrix, the next step is given I am in a particular state, to generate a sample from that state. I do this by computing empirical discrete probability distribution of each regime with a precision 'dt'.
% 
% This model can now be used to simulate the observed process dynamics, the results show that the sample paths as well has histograms match quite well. The general mechanism can be applied a wide array of dataset for nonparametric simulations.

clear all; close all
load data.mat

odata=data;

m=max(odata);

%Percentiles to partition data
perc=[.4,.8];
%Precision of discrete Density estimation
dt=.01;

%Number of simulations
lsim=1;


vperc=perc*m;



state=[0,5,10];

d=data;
%Find data in each percentile group
pdata{1}=d(d<vperc(1))';
pdata{2}=d(d>=vperc(1) & d<vperc(2))';
pdata{3}=d(d>vperc(2))';

%Label data by states
d(d<vperc(1))=state(1);
d(d>=vperc(1) & d<vperc(2))=state(2);
d(d>vperc(2))=state(3);
data=d;

%Create Markov Chain empirical probability of going to state(j) being in state (i)
for i=1:length(state)
   for j=1:length(state)
   p(i,j)=length(find(data(1:end-1)==state(i) & data(2:end)==state(j)))/length(find(data(1:end-1)==state(i)));
   end
   sp1(i)=length(find(data==state(i)))/length(data);
   
end

p0=p;
for sim=1:lsim
    p=p0;

%Generate sample state path from emperical probability
x(1)=state(3);
for k=2:length(data)
p1=p(state==x(k-1),:);
temp=discretesample(p1, 1);
x(k)=state(temp);
temp2(k,:)=p1;
end

%verifying simulated markov prob matches empirical
for i=1:length(state)
   for j=1:length(state)
   xp(i,j)=length(find(x(1:end-1)==state(i) & x(2:end)==state(j)))/length(find(x(1:end-1)==state(i)));
   end
   sp2(i)=length(find(x==state(i)))/length(x);
end

clear temp

%Terminal Probabilities
sprob=[0,0,1]*p^length(odata);

%Create empirical discrete distributions (dt interval size) for each category
for i=1:length(pdata)
temp{i}=min(pdata{i}):dt:max(pdata{i});
temp{i}(end)=max(pdata{i});
for j=1:length(temp{i})-1
    emprob(i,j)=length(find(pdata{i}>=temp{i}(j) & pdata{i}<=temp{i}(j+1)))/length(pdata{i});   
    emdata(i,j)=temp{i}(j);
    ijprob(i,j)=sprob(i)*emprob(i,j);
end
end

%Simulate discrete distribution when in a particular state
for j=1:length(data)
p1=emprob(state==x(j),:);
temp=discretesample(p1, 1);
y(j)=emdata(state==x(j),temp);

end

hold on
subplot(2,2,1)
plot(odata); 
title('real data');
subplot(2,2,2); 
plot(y)
title('simulated data');
subplot(2,2,3); 
hist(odata,100)
title('real data histogram');
subplot(2,2,4); 
hist(y,100)
title('simulated data histogram');


end



