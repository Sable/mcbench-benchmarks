%% Computation of American Option Prices and the Optimal Exercise Boundary
% This demo computes and visualizes the price of an American option and the 
% corresponding optimal exercise boundary. The algorithm is based on 
% Chapter 4 from:
%
% Seydel, R., _Tools for Computational Finance_, Springer, 2nd Edition,
% 2004.
%
%% Introduction 
% In this demo, the price V of an American option is considered as a 
% function of the stock value S and time t, i.e. V = V(S,t). The financial
% parameters like strike, volatility, etc. (a complete list is given below)
% are assumed to be constants. The demo computes the option price for a 
% range of discrete stock values S(i) and a range of discrete time 
% values t(j). 
% 
% The demo also computes the optimal exercise boundary Sf as a function 
% of time, i.e. Sf = Sf(t). For each discrete time value t(j), the value 
% Sf(j) is the last (in case of a put) or the first (in case of a call) 
% contact point with the payoff. This point gives the user the information
% whether it is optimal to exercise the option at each discrete point in
% time.
%
% The results are visualized in three figures. The first figure is a graph 
% of the American option price at the initial time. For comparison reasons, 
% this figure also shows a graph of the corresponding European option 
% and a graph of the payoff. The second figure displays a surface of the 
% option price as a function of the stock value and time. Finally, the 
% third graph displays the optimal exercise boundary.
% 
% *Parameters*
%  
%    K     : Strike price.
%    T     : Time to expiration of the option, expressed in years.
%    r     : Annualized, continuously compounded risk-free rate,
%            expressed as a positive decimal number.
%    delta : Annualized, continuously compounded yield of the underlying
%            asset, expressed as a decimal number (e.g. dividend yield).
%    sigma : Volatility.
%    type  : 'call' or 'put'.
% 
%    m     : The number of discrete stock values is m+1.
%    n     : The number of discrete time values is n+1.
%
% *The Algorithm*
%
% The American option pricing problem can be formulated as a partial 
% differential inequality problem, which can be reformulated as a linear
% complementarity problem. This algorithm used in this demo implements 
% a dimensionless form of this complementarity problem using an implicit
% finite difference discretization (Crank-Nicolson) and the projected SOR
% method for solving the implicit system at each time step.
% 
% This method gives the user control over the stability of the algorithm 
% by means of one parameter, called lambda in the function AmericanOption. 
% Specifically, lambda can be controlled by the choice of m and n and in 
% order to obtain a numeical stable algorithm, the value of lambda 
% should be less than 0.5. The demo produces an error message if this 
% condition is not met.  
%
% *Numerical Results*
%
%    S  : Column array with discrete stock values. The strike price is
%         approximately in the middle of this array. If m is even, then 
%         S(m/2+1) = K, otherwise K lies between S((m+1)/2) and
%         S((m+1)/2+1).
%
%    t  : Row array with time values between 0 and T. This is an
%         equidistant array with t(1) = 0 and t(n+1) = T.
%            
%    V  : Matrix with corresponding stock values:
%         The value V(i,j) is the option price corresonding to
%         the stock price S(i) and the time value t(j), for 
%         i = 1,...,m+1 and j = 1,...,n+1.
%  
%    Sf : Row array of length n+1. The values (t(j),Sf(j)) form the optimal
%         exercise boundary.
%
% *Toolboxes*
%
% The functions AmericanOption and FreeBoundary are written in basic MATLAB
% and do not require any Toolboxes. The script below is also written in 
% basic MATLAB apart from one call of the function blsprice of the 
% Financial Toolbox in order to compute European option prices. These 
% prices are required for the first figure only.

close all
clear
clc

%% Define parameters  

% Financial parameters 

K     = 10;
T     = 1;
r     = 0.2;
delta = 0.1;
sigma = 0.5;
type  = 'put';

% Numerical parameters

m = 400;
n = 400;
%% Compute American option prices

[S,t,V] = AmericanOption(K,T,r,delta,sigma,type,m,n);

%% Compute free boundary

Sf = FreeBoundary(S,t,V,K,type);

% Compute indices for smoothing the free boundary

FreeBoundaryIndices = [1, find(abs(diff(Sf))>1e-5)+1];

%% Define plot variables

plotrange = S>=0 & S<=2*K;
Sp = S(plotrange);
Vp = V(plotrange,:);

%% Graph of American and European option values at time t=0 and payoff

figure('Color','White')

% compute correspoding European option values
[EurCall,EurPut]=blsprice(Sp,K,r,T,sigma,delta);

switch type
    case 'call'
        V_payoff = [0 0 K];
        V_euro   = EurCall;
        location = 'NorthWest';
    case 'put'
        V_payoff = [K 0 0];
        V_euro   = EurPut;
        location = 'NorthEast';
end
        
plot(Sp,Vp(:,1),'b',Sp,V_euro,'g',[0 K 2*K],V_payoff,'r')
title(['American and European ',type,' option'])
legend('American','European','Payoff','Location',location)
grid on
xlabel('Stock price')
ylabel('Option price')

%% 3-D plot of option values versus stock prices and time

figure('Color','White')

[t_grid,Sp_grid]=meshgrid(t,Sp);
surf(Sp_grid,t_grid,Vp,'LineStyle','none')
title(['American ',type,' option'])
xlabel('Stock price')
ylabel('time (years)')
zlabel('Option price')

%% Plot free boundary

figure('Color','White')

plot(t(FreeBoundaryIndices),Sf(FreeBoundaryIndices),'LineWidth',2)
title('Exercise boundary')
grid on
xlabel('Time (years)')
ylabel('Stock price')

switch type
    case 'call'
        location_hold = [0.15 0.15 0.5 0.1];
        location_ex   = [0.5  0.8  0.5 0.1 ];
    case 'put'
        location_hold = [0.15 0.8  0.5 0.1];
        location_ex   = [0.5  0.15 0.5 0.1];
end

annotation('textbox','String',{'Holding region'},...
    'FontWeight','bold',...
    'FontSize',18,...
    'FontName','Arial',...
    'FitBoxToText','off',...
    'LineStyle','none',...
    'Position',location_hold);

annotation('textbox','String',{'Exercise region'},...
    'FontWeight','bold',...
    'FontSize',18,...
    'FontName','Arial',...
    'FitBoxToText','off',...
    'LineStyle','none',...
    'Position',location_ex);
