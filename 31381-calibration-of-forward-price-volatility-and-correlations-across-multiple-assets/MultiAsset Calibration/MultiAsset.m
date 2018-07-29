%Author: Moeti Ncube
% This code uses the Schwartz-Smith model to calibrate and simulate multiple assets such that:
% 
% 1. The Calibration and simulation is consistent with the observable forward curve, adjusted for seasonality, at any given date
% 2. The Calibration and simulation is consistent with the observable ATM volatility at a given date
% 3. The Calibration and simulation is consistent with the observable correlation structure between the forward curve vectors at 
% a given date
% 
% 
% In this example, I use four assets: 5x16,2x16,7x8 PJM forward prices and ATM volatilities along with natural gas forward prices 
% and ATM volatilities
% 
% Calibration of the parameters is done in Excel. By inputing the vectors of Forward and ATM volatilites for each commodity, I 
% can compute the theoretical Schwartz Smith Forward Prices and Standard Deviations for a given maturity. I then use Excel solver 
% to minimize the difference between the observed market values and their theoretical values to obtain the Schwartz-Smith 
% parameters for each commodity. Note this methodology is drastically different from the one described in "Short Term Variation 
% and Long-Term Dynamics in Commodity Prices" in which Schwartz and Smith calibrate their model to historical futures prices. 
% Here I calibrate the model to the current forward and volatility curve as well as adjust for seasonality. This procedure is 
% much more practical pricing methodology.
% 
% The more difficult step was insuring that the correlation between and  asset(i) and asset(j) at maturity (t) was consistent 
% with the implied correlation between the forward price vectors. This was done by adjusting the correlation between the 
% short-term factors of commodities at each maturity. The matlab code factors in this adjustment and simulates the 4 commodities 
% in this example to show that the theoretical prices, volatilities, and correlations match up with the observed market data.
% 
% There is not, to my knowledge, a commodities methodology that incoporates so many market factors across multible commodities 
% into one simulation. The advantages of such a model allows for more accurate modeling of spark spreads and pricing of deals 
% that are dependent on multiple commodities prices. I have included all files, including excel, associated with this calibration 
% and simulation.


clear all; close all

filename = 'SchwartzSmithCalibration.xls';

sim=1000;
str={'Fit 5x16';'Fit 2x16';'Fit 7x8';'Fit Fuel'};
iter=length(str);

for i=1:iter
data{i} = xlsread(filename, str{i}, 'B3:M86');
fwd(:,i)=data{i}(:,1);

kappa(i)=data{i}(1,end);
sigmax(i)=data{i}(3,end);
sigmae(i)=data{i}(4,end);
pxe(i)=data{i}(7,end);
T(:,i)=data{i}(:,3);
x0(i)=data{i}(8,end);
e0(i)=data{i}(9,end);
for j=1:length(T(:,i))
ve(j,i)=sigmae(i)^2*T(j,i);  
vx(j,i)=(1-exp(-2*kappa(i)*T(j,i)))*(.5*sigmax(i)^2)/kappa(i);
covxe(j,i)=(1-exp(-kappa(i)*T(j,i)))*pxe(i)*sigmax(i)*sigmae(i)/kappa(i);
end
corxet(:,i)=covxe(:,i)./sqrt(ve(:,i).*vx(:,i));
end

%Compute Correlation matrix from observed forward curves
cmatrix=corrcoef(log(fwd));


%Find correlation structures needed to keep observed correlation structure
%during simulation
rho(:,1:1)=ones(length(T(:,1)),1);
for i=2:iter
for j=1:length(T(:,i))
atop1(j,1)=(1-exp(-(kappa(1)+kappa(i))*T(j,i)))*sigmax(1)*sigmax(i)/(kappa(1)+kappa(i));
atop2(j,1)=(1-exp(-kappa(1)*T(j,i)))*pxe(i)*sigmax(1)*sigmae(i)/kappa(1);
atop3(j,1)=(1-exp(-kappa(i)*T(j,i)))*pxe(1)*sigmax(i)*sigmae(1)/kappa(i);
atop4(j,1)=pxe(1)*pxe(i)*sigmae(1)*sigmae(i)*T(j,i);
abot1(j,1)=sqrt(vx(j,1)+ve(j,1)+2*covxe(j,1));
abot2(j,1)=sqrt(vx(j,i)+ve(j,i)+2*covxe(j,i));
acorxy(j,i)=(atop1(j,1)+atop2(j,1)+atop3(j,1)+atop4(j,1))/(abot1(j,1)*abot2(j,1));
end
rho(:,i)=cmatrix(1,i)./acorxy(:,i);
rho=min(rho,1);
end


iter2=1;
rmatrix0=randn(sim,length(data{1}(:,1)));
for j=1:iter

for k=1:length(data{1}(:,1))
    rmatrix{j}(:,k)=rho(k,j)*rmatrix0(:,k)+sqrt(1-rho(k,j)^2)*randn(sim,1);
end

[tspath,tmpath,tstdpath,tefwd,testdfwd,xpath1,epath1,r1,r2]=schwartzsmithsim(data{j}(22,end),data{j}(1:9,end),data{j}(10:21,end),data{j}(:,3),rmatrix{j},sim);
spath{j}=tspath;
mpath{j}=tmpath;
stdpath{j}=tstdpath;
efwd{j}=tefwd;
estdfwd{j}=testdfwd;
epath{j}=epath1;
xpath{j}=xpath1;
lnpath{j}=epath1+xpath1;
r1path{j}=r1;
r2path{j}=r2;


subplot(length(str),2,iter2)
title('Market Fwd (blue) vs Sim Fwd (red)')
hold on
plot(fwd(:,j))
plot(mpath{j},'r')

subplot(length(str),2,iter2+1)
title('Market Vol (blue) vs Sim Vol (red)')
hold on
plot(estdfwd{j})
plot(stdpath{j},'r')
iter2=iter2+2;
end


%Estimate empirical correlation matrix
for j=2:iter
for i=1:length(data{1}(:,1))
c(i)=corr(log(spath{1}(:,i)),log(spath{j}(:,i)));
end
empc(j)=mean(c);
end

MarketCorrelations=cmatrix(1,2:end)
SimCorrelations=empc(2:end)


