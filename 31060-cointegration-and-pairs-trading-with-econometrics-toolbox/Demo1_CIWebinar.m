%% Demo 1: Cointegration
% Demo from the April 14, 2011 webinar titled "Cointegration and
% Pairs Trading with Econometrics Toolbox."
%
% See also <Demo2_Pairs_Trading.html Demo 2>

%%
%   Copyright 2011, The MathWorks, Inc.
%   All rights reserved.
clear; close all; clc

%% Interest Rate Data

load Data_Canada
Y = Data(:,3:end);

figure
plot(dates,Y,'LineWidth',2)
xlabel('Year')
ylabel('Percent')
names = series(3:end);
legend(names,'location','NW')
title('{\bf Canadian Interest Rates, 1954-1994}')
axis tight
grid on

%% Pretest for the Order of Integration

y1 = Y(:,1); % Short-term rate

% Levels data:
fprintf('=== Test y1 for a unit root ===\n\n')
[h1,pVal1] = adftest(y1,'model','ARD') % Left-tail probability

fprintf('\n=== Test y1 for stationarity ===\n\n')
[h0,pVal0] = kpsstest(y1,'trend',false) % Right-tail probability

% Differenced data:
fprintf('\n=== Test (1-L)y1 for a unit root ===\n\n')
[h1D,pVal1D] = adftest(diff(y1),'model','ARD') % Left-tail probability

fprintf('\n=== Test (1-L)y1 for stationarity ===\n\n')
[h0D,pVal0D] = kpsstest(diff(y1),'trend',false) % Right-tail probability

figure
plot(dates(2:end),diff(Y),'LineWidth',2)
names = series(3:end);
legend(names,'location','NW')
title('{\bf Differenced Data}')
axis tight
grid on

%% Engle-Granger Test for Cointegration

% Run the test with both "tau" (t1) and "z" (t2) statistics:
fprintf('\n=== Engle-Granger tests for cointegration ===\n\n')
[hEG,pValEG] = egcitest(Y,'test',{'t1','t2'})

%% Identify the Cointegrating Relation

% Return the results of the cointegrating regression:
[~,~,~,~,reg] = egcitest(Y,'test','t2');
 
c0 = reg.coeff(1);
b = reg.coeff(2:3);
figure
C = get(gca,'ColorOrder');
set(gca,'NextPlot','ReplaceChildren','ColorOrder',circshift(C,3))
plot(dates,Y*[1;-b]-c0,'LineWidth',2)
title('{\bf Cointegrating Relation}')
axis tight
grid on

%% VEC Model Estimation, Simulation, Forecasting

% See Documentation:
%
%   Econometrics Toolbox\User's Guide
%   \Mulivariate Time Series Models
%   \Cointegration and Error Correction
%   \Identifying Single Cointegrating Relations
%   \Estimating VEC Model Parameters

%% Multiple Cointegrating Relations

% Permutations of the data variables:
P0 = perms([1 2 3]);
[~,idx] = unique(P0(:,1)); % Rows of P0 with unique regressand y1
P = P0(idx,:); % Unique regressions
numPerms = size(P,1);
 
% Preallocate:
T0 = size(Y,1);
HEG = zeros(1,numPerms);
PValEG = zeros(1,numPerms);
CIR = zeros(T0,numPerms);
 
% Run all tests:
for i = 1:numPerms
    
    YPerm = Y(:,P(i,:));
    [h,pVal,~,~,reg] = egcitest(YPerm,'test','t2');
    HEG(i) = h;
    PValEG(i) = pVal;
    c0i = reg.coeff(1);
    bi = reg.coeff(2:3);
    CIR(:,i) = YPerm*[1;-bi]-c0i;
    
end

fprintf('\n=== Different Engle-Granger tests, same data ===\n\n')
HEG,PValEG

% Plot the cointegrating relations:
figure
C = get(gca,'ColorOrder');
set(gca,'NextPlot','ReplaceChildren','ColorOrder',circshift(C,3))
plot(dates,CIR,'LineWidth',2)
title('{\bf Multiple Cointegrating Relations}')
legend(strcat({'Cointegrating relation  '}, ...
     num2str((1:numPerms)')),'location','NW');
axis tight
grid on

%% Johansen Test for Cointegration

fprintf('\n=== Johansen tests for cointegration ===\n')
[hJ,pValJ] = jcitest(Y,'model','H1','lags',1:2);

%% VEC Model Estimation

[~,~,~,~,mles] = jcitest(Y,'model','H1','lags',2,'display','params');

B = mles.r2.paramVals.B % Cointegrating relations with rank = 2 restriction

%% Testing Cointegrating Vectors

fprintf('\n=== Test y1, y2,y3 for stationarity ===\n\n') 
[h0J,pVal0J] = jcontest(Y,1,'BVec',{[1 0 0]',[0 1 0]',[0 0 1]'})