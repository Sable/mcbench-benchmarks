% This script illustrates popular dynamic strategies
% - CPPI - constant proportion portfolio insurance 
% - delta-based option replication 
% - constant exposures/weights
% - buy & hold

% see Meucci, A. (2010) "Review of Dynamic Allocation Strategies - Convex versus Concave Management"
% available at http://ssrn.com/abstract=1635982


clear; clc; close all; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input parameters

Initial_Investment = 1000;
Time_Horizon = 6/12; % in years
Time_Step = 1/252; % in years
Strategy = 2; % 1=Constant exposures; 2=Buy&Hold; 3=CPPI; 4=Delta Hedging

m=0.2;  % yearly expected return on the underlying
s=0.40; % yearly expected percentage volatility on the stock index
r=0.04; % risk-free (money market) interest rate

NumSimul=30000;

%%%%%%%%%%%%%%%%%%%%%%%%%%
if Strategy==1 % Constant exposures
    % amount to be invested in the underlying? e.g.: 50
    Prct = 50 ;
end
if Strategy==2 % Buy&Hold
    % proportion of underlying you want to hold in the beginning, e.g.: 50
    Prct = 50 ;
end
if Strategy==3 % CPPI
    % floor today (will evolve at the risk-free rate), e.g.: 950
    Floor = 980; 
    % leverage on the cushion between your money and the floor, e.g. 3
    Multiple_CPPI = 5; 
end
if Strategy==4 % Delta Hedging
    % level of aggressivness bw 0 and 1
    Aggressivness = .2;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialize values
Underlying_Index=Initial_Investment;  % value of the underlyting at starting time, normalzed to equal investment
Start=Underlying_Index;
Elapsed_Time=0;
Portfolio_Value=Initial_Investment;

if Strategy==1 % Constant Weights
    Underlying_in_Portfolio_Percent = Prct/100;
end
if Strategy==2 % Constant Weights
    Underlying_in_Portfolio_Percent = Prct/100;
end
if Strategy==3 % CPPI
    Cushion=max(0,Portfolio_Value-Floor);
    Underlyings_in_Portfolio=min(Portfolio_Value,max(0,Multiple_CPPI*Cushion));
    Cash_in_Portfolio=Portfolio_Value-Underlyings_in_Portfolio;
    Underlying_in_Portfolio_Percent = Underlyings_in_Portfolio./Portfolio_Value;
end
if Strategy==4 % Delta Hedging
    options=[];
    Strike = fsolve('Solve4Strike',Start,options,Time_Horizon,Underlying_Index,s,r,Initial_Investment,Aggressivness*Initial_Investment/3);
    Underlying_in_Portfolio_Percent = Delta(Time_Horizon-Elapsed_Time,Underlying_Index,s,Strike,r);
end


Underlyings_in_Portfolio=Portfolio_Value*Underlying_in_Portfolio_Percent;
Cash_in_Portfolio=Portfolio_Value-Underlyings_in_Portfolio;

% initialize parameters for the plot (no theory in this)
close all;
Portfolio_Series=Portfolio_Value;
Market_Series=Underlying_Index;
Percentage_Series=Underlying_in_Portfolio_Percent;

% asset evolution and portfolio rebalancing
while Elapsed_Time < Time_Horizon -10^(-5)  % add this term to avoid errors
    % time elapses...
    Elapsed_Time=Elapsed_Time+Time_Step;

    % ...asset prices evolve and portfolio takes on new value...
    Multiplicator = exp((m-s^2/2)*Time_Step+s*sqrt(Time_Step)*randn(NumSimul,1));
    Underlying_Index = Underlying_Index.*Multiplicator;
    Underlyings_in_Portfolio = Underlyings_in_Portfolio.*Multiplicator;
    Cash_in_Portfolio = Cash_in_Portfolio*exp(r*Time_Step);
    Portfolio_Value = Underlyings_in_Portfolio+Cash_in_Portfolio;
        
    % ...and we rebalance our portfolio 
    if Strategy==1 % Constant Weights
        Underlying_in_Portfolio_Percent = Underlying_in_Portfolio_Percent; 
        Underlyings_in_Portfolio=Portfolio_Value.*Underlying_in_Portfolio_Percent;
        Cash_in_Portfolio=Portfolio_Value-Underlyings_in_Portfolio;
    end
    if Strategy==2 % Buy&Hold
        Underlying_in_Portfolio_Percent = Underlyings_in_Portfolio./Portfolio_Value;
    end
    if Strategy==3 % CPPI
        Floor=Floor*exp(r*Time_Step);
        Cushion=max(0,Portfolio_Value-Floor);
        Underlyings_in_Portfolio=min(Portfolio_Value,max(0,Multiple_CPPI*Cushion));
        Cash_in_Portfolio=Portfolio_Value-Underlyings_in_Portfolio;
        Underlying_in_Portfolio_Percent = Underlyings_in_Portfolio./Portfolio_Value;
    end
    if Strategy==4 % Delta Hedging
        Underlying_in_Portfolio_Percent = Delta(Time_Horizon-Elapsed_Time,Underlying_Index,s,Strike,r);
        Underlyings_in_Portfolio=Portfolio_Value.*Underlying_in_Portfolio_Percent;
        Cash_in_Portfolio=Portfolio_Value-Underlyings_in_Portfolio;
    end
    
    
    % store one path for the movie (no theory in this)
    Portfolio_Series = [Portfolio_Series Portfolio_Value(1)];
    Market_Series=[Market_Series Underlying_Index(1)];
    Percentage_Series=[Percentage_Series Underlying_in_Portfolio_Percent(1)];
end

% play the movie for one path
Time=[0:Time_Step:Time_Horizon];
y_max=max([Portfolio_Series Market_Series])*1.2;
for i=1:length(Time)
    subplot(2,1,1);
    plot(Time(1:i),Portfolio_Series(1:i),'linewidth',2.5,'color','b');
    hold on;
    plot(Time(1:i),Market_Series(1:i),'linewidth',2,'color','r');
    axis([0 Time_Horizon 0 y_max]);
    grid on;
    ylabel('value','fontsize',12,'fontweight','bold');
    title('investment (blue) vs underlying (red) value','fontsize',12,'fontweight','bold')
    
    subplot(2,1,2);    
    bar(Time(1:i),Percentage_Series(1:i),'stack','r');
    axis([0 Time_Horizon 0 1]);
    grid on;
    xlabel('time','fontsize',12,'fontweight','bold');
    ylabel('%','fontsize',12,'fontweight','bold');
    title('percentage of underlying in portfolio','fontsize',12,'fontweight','bold')
    

    set(gcf,'Units','normalized','Position', [0.1, 0.1, .8, .8]);
    F(i) = getframe;
end
%break
% plot the scatterplot
figure

% marginals
NumBins=round(10*log(NumSimul));

subplot('Position',[.05 .3 .18 .6]) 
[n,D]=hist(Portfolio_Value,NumBins);
barh(D,n,1);
[y_lim]=get(gca,'ylim');
set(gca,'xtick',[])
grid on

subplot('Position',[.3 .05 .6 .2]) 
[n,D]=hist(Underlying_Index,NumBins);
bar(D,n,1);
[x_lim]=get(gca,'xlim');
set(gca,'ytick',[])
grid on

% joint scatter plot
subplot('Position',[.3 .3 .6 .6]) 
plot(Underlying_Index,Portfolio_Value,'LineStyle','none','marker','.');
hold on;
so=sort(Underlying_Index);
plot(so,so,'r');
set(gca,'xlim',x_lim,'ylim',y_lim)
grid on;
xlabel('underlying at horizon (~ buy & hold )','fontweight','bold');
ylabel('investment at horizon','fontweight','bold');

set(gcf,'Units','normalized','Position', [0.1, 0.1, .8, .8]);