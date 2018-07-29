%% Classic Monte Carlo simualtion
% Vincent Leclercq, The MathWorks, 2007, vincent.leclercq@mathworks.fr
%

clear all;
close all;


NbTrials = 10000;

%RunMode = 'LogNomrality';

RunMode = 'OptionPricing';
%% Load Data (retrieved originally from Thomson Datastream)

load Equities.mat
PastDate = today()-1 * 365;

%% Retrieve the dates in a numeric format

Dates   = cellfun(@(x)(datenum(x,'yyyy-mm-ddTHH:MM:SS')),Equities.DATE);
AssetPrices = cellfun(@(x) (str2double(x)),Equities.P );
    
%% Plot the Series

plot(Dates,AssetPrices);set(gcf,'WindowStyle','Docked');
legend(Equities.DISPNAME);
datetick('x','mmmyy');
xlim([PastDate, today()]);
grid on;


%% Compute the returns
% We can compute the returns for one or many stocks at the same time using
% matrix computation and matlab easy syntax

Suez_Returns = tick2ret(AssetPrices);
DailyVol = std(Suez_Returns);
AnnualVol = DailyVol * sqrt(252);

SpotPrice = AssetPrices(end);

InterestRate = 0.0375;

%% Portfolio simulation (Monte Carlo) using the Financial toolbox function
% For help, one can use the doc portsim function
% We call the portfolio simulation using Financial toolbox to
% simulate 10000 scenarios. Of course, correlation are preserved
% We assume an horizon of 6 * 22 trading days, ie 6 month maturity

%% Using Annual statistics


SimulatedRetsAnnual = portsim(InterestRate,AnnualVol^2, 12, 1/12, NbTrials,'Expected'); % NbStep * TimeStep = 1 (in years !!!)

%% Using Daily statistics
NumberOfSimulationSteps = 12;
SimulatedRetsDaily = portsim(InterestRate./252, DailyVol^2, 12, 252./12, NbTrials,'Expected');% NbStep * TimeStep = 252 (in days!!!)




%% Generate the Prices and plot them

SimulatedPricesAnnual = ret2tick(squeeze(SimulatedRetsAnnual) ,SpotPrice);
SimulatedPricesDaily  = ret2tick(squeeze(SimulatedRetsDaily)  ,SpotPrice );

figure;hist(SimulatedPricesAnnual(end,:),40);title('Prices, annual timestep used');set(gcf,'WindowStyle','Docked');
figure;hist(SimulatedPricesDaily(end,:),40);title('Prices, daily timestep used');set(gcf,'WindowStyle','Docked');

%% Check For LogNormality of the Price series

ExpectedVariance = (SpotPrice^2)  * (exp(AnnualVol^2) - 1)* exp(2*InterestRate);

disp(['Mean Price (Annual Parameters) -> ', num2str(mean(SimulatedPricesAnnual(end,:))) ' , Theoric value (Hull) :' num2str(SpotPrice * exp(InterestRate))]);
disp(['Mean Price (Daily Parameters) -> ', num2str(mean(SimulatedPricesDaily(end,:))) ' , Theoric value (Hull) :' num2str(SpotPrice * exp(InterestRate))]);

disp(['Expected Variance (Annual Parameters) -> ', num2str(var(SimulatedPricesAnnual(end,:))) ' , Theoric value (Hull) :' num2str(ExpectedVariance)]);
disp(['Expected Variance (Daily Parameters) -> ', num2str(var(SimulatedPricesDaily(end,:))) ' , Theoric value (Hull) :' num2str(ExpectedVariance)]);


%% Parameter sweep
% Now that we have done this, we can ccompute the same thing for different
% Exercise prices
if strcmp(RunMode,'OptionPricing')
    k = 1;
    NumberOfSteps = 400;
    ExercisePrices= linspace(0.8 * SpotPrice,1.2 * SpotPrice,NumberOfSteps);


    VanillaPriceAnnual    = zeros(NumberOfSteps,1);
    VanillaPriceDaily    = zeros(NumberOfSteps,1);

    ProbabilityITMAnnual  = zeros(NumberOfSteps,1);
    ProbabilityITMDaily  = zeros(NumberOfSteps,1);
    CIAnnual    =     zeros(NumberOfSteps,2);
    CIDaily     =     zeros(NumberOfSteps,2);
    BLSPrices       = zeros(NumberOfSteps,1);

    %%
    TimeInYear = 1;
    for i = 1 : NumberOfSteps
        [BLSPrices(i),dummy]   = blsprice(SpotPrice, ExercisePrices(i), InterestRate, TimeInYear, AnnualVol, 0);
        [VanillaPriceAnnual(i), ProbabilityITMAnnual(i) ,CIAnnual(i,:)] = GetOptionPrice(SimulatedPricesAnnual,ExercisePrices(i),TimeInYear,InterestRate,'Vanilla');
        [VanillaPriceDaily(i), ProbabilityITMDaily(i) ,  CIDaily(i,:)] = GetOptionPrice(SimulatedPricesDaily,ExercisePrices(i),TimeInYear,InterestRate,'Vanilla');

    end;

%% 
    
    h =    figure;
    [AX,H1,H2] = plotyy(ExercisePrices,[VanillaPriceAnnual BLSPrices CIAnnual] , ExercisePrices,ProbabilityITMAnnual);


    xlabel('Exercise Price');
    title('Option prices for a Vanilla option using a 1 year - Annual volatility');
    Axes_YLabels = get(AX,'Ylabel');
    set(Axes_YLabels{1},'String','Option Price') ;

    set(H1(1),'LineStyle','-');
    set(H1(1),'Color','r');
    set(H1(1),'LineWidth',2);


    set(H1(2),'LineStyle','-');
    set(H1(2),'Color','b');
    set(H1(2),'LineWidth',2);

    set(H1(3),'LineStyle','--');
    set(H1(3),'Color','r');
    set(H1(3),'LineWidth',1);

    set(H1(4),'LineStyle',':');
    set(H1(4),'Color','r');
    set(H1(4),'LineWidth',1);


    set(H2,'LineStyle','-');
    set(H2,'Color','g');
    set(H2,'LineWidth',2);

    set(get(AX(2),'Ylabel'),'String','Probability of being In the Money');
    legend(H1,{['Option Price (Monte Carlo)'], ['Option Price (Black Scholes)'], ['99% Confidence interval (Lower)'],['99% Confidence interval (Upper)']},'Location','NorthEast');
    legend(H1(2),{'Option Price (Black Shcoles)'},'Location','NorthEast');
    legend(H2,{'Probability'},'Location','SouthWest');
    grid on;
set(h,'WindowStyle','Docked');

%%
h=     figure;
    [AX,H1,H2] = plotyy(ExercisePrices,[VanillaPriceDaily BLSPrices CIDaily] , ExercisePrices,ProbabilityITMDaily);


    xlabel('Exercise Price');
    title('Option prices for a Vanilla option using a 1 year - Daily volatility');
    Axes_YLabels = get(AX,'Ylabel');
    set(Axes_YLabels{1},'String','Option Price') ;

    set(H1(1),'LineStyle','-');
    set(H1(1),'Color','r');
    set(H1(1),'LineWidth',2);


    set(H1(2),'LineStyle','-');
    set(H1(2),'Color','b');
    set(H1(2),'LineWidth',2);


    set(H1(3),'LineStyle','--');
    set(H1(3),'Color','r');
    set(H1(3),'LineWidth',1);

    set(H1(4),'LineStyle',':');
    set(H1(4),'Color','r');
    set(H1(4),'LineWidth',1);
    

    set(H2,'LineStyle','-');
    set(H2,'Color','g');
    set(H2,'LineWidth',2);

    set(get(AX(2),'Ylabel'),'String','Probability of being In the Money');
    legend(H1,{['Option Price (Monte Carlo)'], ['Option Price (Black Scholes)'], ['99% Confidence interval (Lower)'],['99% Confidence interval (Upper)']},'Location','NorthEast');
    legend(H2,{'Probability'},'Location','SouthWest');
    grid on;
    set(h,'WindowStyle','Docked');
 end;