% this script plots the joint and marginal distributions of stocks dail compounded returns
% and tests for invariance across time (i.i.d.)
% see "Risk and Asset Allocation"-Springer (2005), by A. Meucci

% Code by A. Meucci, April 2009
% Most recent version available at www.symmys.com > Teaching > MATLAB


clc; clear; close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inputs

% upload sample IBM and Dell
load('db_Equities');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Start=1;
Step=5;
End=3500;
Dates=Data(Start:Step:End,1);
Prices=Data(Start:Step:End,2:3);
X = diff(log(Prices));
T=size(X,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plots series
figure
plot(Dates,Prices(:,1)/Prices(1,1),'r');
hold on
plot(Dates,Prices(:,2)/Prices(1,2),'b');
legend(Fields(2).Name,Fields(3).Name,'location','best')
xlim([Dates(1) Dates(end)])
datetick('x','mmmyy','keeplimits','keepticks');
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plots joint distribution
figure 
% marginals
NumBins=round(12*log(T));
p=.001;

xl=quantile(X(:,1),p);
xh=quantile(X(:,1),1-p);
x_lim=[xl xh];
x=[xl: (xh-xl)/100 : xh];

yl=quantile(X(:,2),p);
yh=quantile(X(:,2),1-p);
y_lim=[yl yh];
y=[yl: (yh-yl)/100 : yh];

subplot('Position',[.05 .3 .2 .6]) 
[n,D]=hist(X(:,2),NumBins);
Dlt=D(2)-D(1);
barh(D,n/(T*Dlt),1);
set(gca,'xtick',[],'ylim',y_lim);
hold on 
yx=normpdf(x,mean(X(:,1)),std(X(:,1)));
plot(yx,x,'r')
grid on

subplot('Position',[.3 .05 .6 .2]) 
[n,D]=hist(X(:,1),NumBins);
Dlt=D(2)-D(1);
bar(D,n/(T*Dlt),1);
set(gca,'ytick',[],'xlim',x_lim);
hold on 
xy=normpdf(y,mean(X(:,2)),std(X(:,2)));
plot(y,xy,'r')
grid on

% scatter plot
subplot('Position',[.3 .3 .6 .6]) 
h=plot(X(:,1),X(:,2),'.');
set(gca,'xlim',x_lim,'ylim',y_lim)
grid on
xlabel(Fields(2).Name)
ylabel(Fields(3).Name)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
IIDAnalysis(Dates(2:end),X(:,2));
