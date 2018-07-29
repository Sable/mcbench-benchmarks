%% NET PRESENT VALUE AFTER DISCOUNTING
% Calculate the current value of the mine taking into account:
% Sales simulations
% Subtracting costs
% Applying Discounting to calculate today's value (NPV)
% Fit a distribution curve to calculate probabilites of VAR

%% Discounting
% Calculating discount factor based off the mean of interest rate
% simulations and adding mining discount factor of 7%.
r = mean(simIR,2)/100; %interest rate discount factor
c = 0.07; %mining cost discount factor
discFactor = exp(-(r+c).* (1:size(simIR,1))'/252);
discFactorY = discFactor(252:252:end);

costs = data(12:16,2:end); %extracting costs
costsT = sum(costs)'; %total costs
opprof = sales+repmat(costsT,1,NTrials); %operating profit
opprofb = salesb'+costsT;
tax = data(18,2:end)'; %extracting tax
opproftax = opprof+repmat(tax,1,NTrials); %profit after tax
opproftaxb = opprofb+tax; %profit after tax

disccashflow = opproftax.*repmat(discFactorY,1,NTrials); %discounted cashflow
disccashflowb = opproftaxb.*discFactorY; %base discounted cashflow

capex = data(21); %Capital Expenditure

NPV = sum(disccashflow)+capex; %Net Present Value
NPVb = sum(disccashflowb)+capex; %Net Present Value base case
figure
hist(NPV,20);
title('Net Present Value Distribution Analysis')
xlabel('Net Present Value')
ylabel('Distribution Count')

%% Distribution Fitting
% Distribution pre fitting using the distribution fitting tool from the 
% statistics toolbox and selecting generalised extreme value
%
% To refit type:
% >> dfittool(NPV)

pd1 = FitNPV(NPV);

%Probability Analysis
basecasenpv = 0; 
probbase_b = pd1.cdf(basecasenpv); %Probability of below 0 NPV
probbase_a = 1-probbase_b;
probbase_bm = pd1.cdf(pd1.mean); %Probability of mean NPV
probbase_am = 1-probbase_bm;
VAR = pd1.icdf(0.05); % 5% Value at RISK calculation

%% Visualization
% Plotting Probability Levels

% 5% VAR Level
hold on
yl = ylim;
hm = plot([pd1.mean,pd1.mean],yl,'g-o','LineWidth',2);
hv = plot([VAR,VAR],yl,'r-o','LineWidth',2);
legend([hm,hv],['Mean Level: ',num2str(round(pd1.mean/1000)),'mill'],...
    ['VAR 5%: ',num2str(round(VAR/1000)),'mill']);

% Case of $0 profit
basecasenpv = 0; 
probbase_b = pd1.cdf(basecasenpv); %Probability of below 0 NPV
h0 = plot([0,0],yl,'b-o','LineWidth',2);

% Base Case of $108US/tonne
hb = plot([NPVb,NPVb],yl,'m-o','LineWidth',2);

legend([hm,hv,h0,hb],['Mean Level: $',num2str(round(pd1.mean/1000)),'mill'],...
    ['VAR 5%: $',num2str(round(VAR/1000)),'mill'],...
    ['Probability <0: ',num2str(round(100*probbase_b)),'%'],...
    ['Base Case Iron Ore $108 per tonne']);


title('NPV Simulation Results')
xlabel('Profit ''000$')