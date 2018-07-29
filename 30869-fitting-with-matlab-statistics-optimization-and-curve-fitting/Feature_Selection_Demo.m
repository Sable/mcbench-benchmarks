%%  Generate a sample data set
%Copyright (c) 2011, The MathWorks, Inc.

clear all
clc

n = 100;
m = 10;
X = rand(n,m);
b = [1 0 0 2 .5 0 0 0.1 0 1];
Xb = X*b';

mu = @(x) 1./(1+exp(-x));

y = mu(Xb);

N = 50;
Noisy_Y = binornd(N,y);

%%  Generate a model using all 10 predictors

Y = [Noisy_Y N*ones(size(Noisy_Y))];
[b0,dev0,stats0] = glmfit(X,Y,'binomial');
model0 = [b0 stats0.se]

%% Display the deviance of the fit:
dev0

%%  Apply Sequential Feature Selection

maxdev = chi2inv(.95,1);     
opt = statset('display','iter',...
              'TolFun',maxdev,...
              'TolTypeFun','abs');

inmodel = sequentialfs(@critfun,X,Y,...
                       'cv','none',...
                       'nullmodel',true,...
                       'options',opt,...
                       'direction','forward');

inmodel 
b                   
%%

[b,dev,stats] = glmfit(X(:,inmodel),Y,'binomial');

model = [b stats.se]

dev

%%  ReliefF example

clear all
clc
load ionosphere;

%%
[Feature_Rank,Feature_Weight] = relieff(X,Y,10);

Feature_Rank = Feature_Rank';
Feature_Weight = Feature_Weight';

[Feature_Rank Feature_Weight(Feature_Rank)]




          







