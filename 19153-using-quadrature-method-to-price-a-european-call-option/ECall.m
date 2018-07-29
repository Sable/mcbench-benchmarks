% JFE 2003 Universal option valuation using quadrature methods
% Example: an European call option 
%
% To use the program to files are needed : ECall_QUAD.m
%
clear all;
% option's contract parameters
 T = 0.5;                     % Maturity
 S0 = 100;                    % Initial stock price
 E = 105;                      % Strike price
 r = 0.06;                    % risk free interest rate
 sig = 0.2;                   % volatility
 D = 0;                       % continuous dividend yield
%%%%%%%%%%%%%%%%%
[OptionValue] = ECall_QUAD(S0,T,E,r,sig,D)
%Black_Scholes_call = blsprice(S0, E, r, T, sig)