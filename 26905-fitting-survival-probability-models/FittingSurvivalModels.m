%% Companion Code for ``Fitting Survival Probability Models''
%
% This is a MATLAB(R) implementation of the ideas discussed in
%
%   Lopez-Calva, G. and K. Shea, "Fitting Survival Probability Models," 
%     WILMOTT Magazine, issue 45, pp. 16-22.
%
% We estimate the parameters of three different survival probability models
% based on credit default swap (CDS) spreads. The parameters of the models
% are fitted using a nonlinear least-squares solver. For the standard
% model, a bootstrapping technique is also implemented, for comparisons.
% The mark-to-market (MtM) of an existing CDS contract is also calculated
% under the three alternative survival models. Code for a general survival
% model is provided, though it is not used in the main demo.
%
% Dependencies: This demo uses functionality from the Financial
% Toolbox(TM), Fixed-Income Toolbox(TM) and Optimization Toolbox(TM).
%
% Authors: Gabo Lopez-Calva and Kevin Shea, The MathWorks, Inc.
%

%% Market data
%
% We assume two different market scenarios for the CDS spread term
% structure, namely, a "normal" term structure with increasing values for
% the spreads, and an "inverted" term structure with decreasing spread
% values. (The scenarios can be run one at a time, by choosing the desired
% term structure below.) We assume a flat recovery rate of 40%, and use an
% Act / 360 basis. The assumption is that the CDS contract pays quarterly
% premiums, and we use a "granularity" of one month to valuate the
% protection leg. Most of the functions come from MATLAB or from the
% Financial Toolbox. For the discount curve, we take LIBOR quotes and fit
% an interest rate curve object from the Fixed-Income Toolbox. All the data
% are ficticious.

% Valuation date
Settle = datenum('17-Jul-2009');
% Maturity of the longest contract in the data
Maturity = datenum('17-Jul-2016');

% Maturities for the CDS quotes, in years
Term = [1 2 3 5 7]';
% Normal spread term structure
Spread = [140 175 210 265 310]'/10000;
% Inverted spread term structure
%Spread = [800 675 450 330 300]'/10000;

% Recovery rate, 40% flat
Recovery = .40;
% Basis: 2 (Act/360)
Basis = 2;

% Quarterly payment dates for the CDS contract
PremiumDates = cfdates(Settle,Maturity,4,Basis)';
PremiumDates(~isbusday(PremiumDates)) = busdate(PremiumDates(~isbusday(PremiumDates)));

% Granularity of one month for the valuation of the protection leg
ProtectDates = cfdates(Settle,Maturity,12,Basis);

% LIBOR Curve
LIBOR_Time = [.5 1 2 3 4 5]';
LIBOR_Rate = [1.35 1.43 1.9 2.47 2.936 3.311]'/100;
LIBOR_Dates = daysadd(Settle,360*LIBOR_Time,Basis);
LIBOR = IRDataCurve('Zero',Settle,LIBOR_Dates,LIBOR_Rate,'Basis',Basis);

%% Set up survival probability models
%
% The methodology and the models that we use here are described in more
% detail in the article. We only summarize the main formulas here.
%
% A CDS spread is computed with the following formula
%
% $$ Spread = \frac{(1-R) \sum_{i=1}^{M} Z(\tau_i) (Q(\tau_{i-1}) - Q(\tau_i))}
%   {\frac{1}{2} \sum_{j=1}^{N} Z(t_j) \Delta(t_{j-1},t_j,B) (Q(t_{j-1}) + Q(t_j))}$$
%
% where
%
% * _R_ is the recovery rate
%
% * _Q(t)_ is the survival probability at time _t_; _Q_ is determined by a vector
% of parameters _b_, and it is the vector _b_ what we want to estimate
%
% * _Z(t)_ is a discount factor for a cash flow occurring at time _t_
%
% * $\Delta$ is a day count between two dates corresponding to a
% basis B
%
% * There is a protection leg granularity with _M_ points (the subindexed
% tau's), and a list of _N_ premium dates (the subindexed t's)
%
% The method consists in varying the "guesses" of the vector of
% parameters b, for a given model (one model at a time), until the CDS
% spreads predicted using the formula above match the spreads observed in
% the market. We use a nonlinear least-squares solver to do this. The
% different models are described in the article, and implemented as
% separate functions. We only ran the experiments for the standard, the
% Weibull, and the Nelson-Siegel models. Code to fit a general hazard
% function model of your choice is prototyped, but not used for the
% experiments reported in the article.
%
% Each model is defined using a |struct|, and we put them all together in a
% cell array called |models|. Each |struct| has the following fields:
%
% * |name|: A descriptive name of the model
%
% * |survProb|: A function handle to the survival probability model; it
% takes two arguments, time and the vector of parameters b of the model
%
% * |b0|: An initial guess for the parameters values
%
% * |b|: The values of the parameters estimated by the solver
%
% * |lb|: Lower bounds for the parameters
%


% Change this according to the number of models you are fitting
numModels = 3;

% Define a model using a |struct|
models = cell(numModels,1);
models{1} = struct('name','standard',...
                   'survProb',@(t,b)survProbStdModel(t,b,Term),...
                   'b0',0.2*ones(size(Term)),...
                   'b',NaN(size(Term)),...
                   'lb',zeros(size(Term)));
models{2} = struct('name','weibull',...
                   'survProb',@(t,b)survProbWeibull(t,b),...
                   'b0',ones(2,1),...
                   'b',NaN(2,1),...
                   'lb',zeros(2,1));
models{3} = struct('name','nelson-siegel',...
                   'survProb',@(t,b)survProbNelsonSiegel(t,b),...
                   'b0',ones(2,1),...
                   'b',NaN(2,1),...
                   'lb',zeros(2,1));
% % This is how the general hazard function model could be defined:
% models{3} = struct('name','gen-haz-fun',...
%                    'survProb',@(t,b)survProbGenHazFun(t,b,@(t,b)genHazFun(t,b)),...
%                    'b0',[0.1;1;10],...
%                    'b',NaN(3,1),...
%                    'lb',zeros(3,1));

%% Fit survival probability models
%
% We use the nonlinear least-squares solver |lsqnonlin| from the
% Optimization Toolbox to estimate the parameters of the alternative
% survival models.
%
% The function handle |predSpread| implements the spread equation above.
% The target or error function |errorFun| is the difference between the
% predicted spreads and the observed spreads, which is a function of the
% vector of parameters |b|. The solver, internally, squares the errors.
% The |lsqnonlin| solver only accepts bounds on the parameters. For models
% with more complex constraints on the parameters, one can use other
% solvers, such as |fmincon|, though one would have to define the
% constraints and the objective function (the "two-norm" squared of the
% function |errorFun|).

options = optimset('lsqnonlin');
options = optimset(options,'TolFun',1e-12,'TolX',1e-12);

for i=1:numModels
   predSpread = @(b) protectLeg(Term,Settle,ProtectDates,Basis,LIBOR,Recovery,...
      models{i}.survProb,b)./ rpv01(Term,Settle,PremiumDates,Basis,LIBOR,...
      models{i}.survProb,b);
   errorFun = @(b) Spread - predSpread(b);
   [models{i}.b resnorm,residual,exitflag,output,lambda] = lsqnonlin(errorFun,models{i}.b0,models{i}.lb,[],options);
end

%% Compare the fitted survival distributions
%
% Here we visualize the different survival models. We explicitly shade the
% "extrapolation" section, the time values beyond the longest contract
% observed in the market.
%

% Create a cell array with the names of the models, to display a legend
legend_labels = cell(numModels+1,1);
for i=1:numModels
   legend_labels{i} = models{i}.name;
end
legend_labels{numModels+1} = 'market';

% This needs to be adjusted if plotting more than three models
LineTypes = {'-b','--r',':k'};

% This is the time window that will be plotted
plotTime = 0.0:0.1:12;

% Some reference values used below
a0 = 100;
a1 = max(Term);
a2 = max(plotTime);

% Plot the estimated default probability
figure;
hold on;
for i=1:numModels
   SurvProb = models{i}.survProb(plotTime,models{i}.b)*100;
   plot(plotTime,SurvProb,LineTypes{i},'LineWidth',2);
   a0 = min(a0,min(SurvProb));
end
legend(legend_labels(1:numModels));
title('Fitted Survival Probability Models')
xlabel('Time (years)')
ylabel('Survival Probability')
patch([a1 a1 a2 a2],[get(gca,'YLim') fliplr(get(gca,'YLim'))],'y',...
                    'FaceAlpha',.25,'EdgeColor','none');
text(a1+1,a0+5,'Extrapolated') 
hold off;


%% Compare the predicted spreads
%
% Here we visualize the predicted spreads under each model.
%

% This needs to be adjusted if plotting more than three models
MarkerTypes = {'+b','xr','dg'};

figure;
hold on;
for i=1:numModels
   PredSpread = protectLeg(Term,Settle,ProtectDates,Basis,LIBOR,Recovery,...
      models{i}.survProb,models{i}.b)./ rpv01(Term,Settle,PremiumDates,...
      Basis,LIBOR,models{i}.survProb,models{i}.b);
   scatter(Term,PredSpread*10000,MarkerTypes{i});
end
plot(Term,Spread*10000,'ko');
legend(legend_labels);
xlabel('Maturity (years)')
ylabel('Spread (Basis Points)')
title('Market and Predicted Spreads for Fitted Survival Probability Models')
hold off;

%% Fit standard survival probability model by bootstrapping
%
% Here we fit the parameters of the standard model by bootstrapping, to
% compare against the values obtained with the least-squares method. For
% the normal term structure, we get an exact match. For the inverted term
% structure, the estimates do not match exactly, but they show the same
% non-monotone pattern: very high at first, go all the way down to zero for
% the third time interval, then rise to small positive values at the end.

bKnown = [];
for i=1:length(Term)
   b = 0.01;
   Term_i = Term(1:i);
   Spread_i = Spread(1:i);
   survProb = @(t,b)survProbStdModel(t,[bKnown;b],Term_i);
   predSpread = @(b) protectLeg(Term_i,Settle,ProtectDates,Basis,LIBOR,Recovery,...
      survProb,b)./ rpv01(Term_i,Settle,PremiumDates,Basis,LIBOR,...
      survProb,b);
   errorFun = @(b) Spread_i - predSpread(b);
   b = lsqnonlin(errorFun,b,0,[],options);
   bKnown = [bKnown;b];
end
bStdBootstr = bKnown;

disp('Parameters for the standard model:')
disp('  Bootstr    Least Sq')
disp([bStdBootstr models{1}.b])

%% Mark-to-market existing CDS
%
% Last, we compute the mark-to-market (MtM) of a hypothetical existing
% 3-year contract closed a year earlier at a spread of 190 bp. We compute
% the MtM under each of the alternative models and compare the difference
% against the standard model, as a percentage of the notional amount.
%

SettleMtM = datenum('17-Jul-2008');
MaturityMtM = datenum('17-Sep-2011');
ContractSpread = 0.0190;
Notional = 10000000;
% We are valuating the same day (Settle) we estimated the survival models
ValuationMtM = Settle;
TermMtM = yearfrac(ValuationMtM,MaturityMtM,Basis);

PremiumDatesMtM = cfdates(SettleMtM,MaturityMtM,4,Basis)';
PremiumDatesMtM(~isbusday(PremiumDatesMtM)) = ...
   busdate(PremiumDatesMtM(~isbusday(PremiumDatesMtM)));

ProtectDatesMtM = cfdates(SettleMtM,MaturityMtM,12,Basis);

RPV01MtM = zeros(numModels,1);
CurrSpreadMtM = zeros(numModels,1);
MtM = zeros(numModels,1);
DiffMtMByNotional = zeros(1,numModels);
for i=1:numModels
   RPV01MtM(i) = rpv01(TermMtM,SettleMtM,PremiumDatesMtM,Basis,LIBOR,...
      models{i}.survProb,models{i}.b);
   CurrSpreadMtM(i) = protectLeg(TermMtM,SettleMtM,ProtectDatesMtM,Basis,...
       LIBOR,Recovery,models{i}.survProb,models{i}.b)./ RPV01MtM(i);
   MtM(i) = Notional * (ContractSpread - CurrSpreadMtM(i)) * RPV01MtM(i);
   DiffMtMByNotional(i) = (MtM(i) - MtM(1)) / Notional;
end

% Display differences (as % of notional) against the first model
disp('Difference against standard model, as % of notional:')
disp(legend_labels(2:end-1)')
disp(DiffMtMByNotional(2:end)*100)

%%
displayEndOfDemoMessage(mfilename)