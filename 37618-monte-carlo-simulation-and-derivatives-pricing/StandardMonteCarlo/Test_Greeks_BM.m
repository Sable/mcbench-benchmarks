% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



S0 = 100;       % spot price of stock index
r =  0.03;      % risk free rate
d =  0.00;      % dividend yield

sigma = 0.3;    % volatility

T = 3;          % Maturity

NTime = 1;      % Number of time steps    
NSim = 100000;   % Number of simulations

% Black Scholes model
% European Call / Put option
pathS = MC_B_PW(S0,r,d,T,sigma,NTime,NSim);
PW_Delta_CallPut(pathS,100,1,r,T)
blsdelta(S0, 100, r, T, sigma, 0)
PW_Vega_CallPut(pathS,100,1,r,sigma,T)
blsvega(S0, 100, r, T, sigma, 0)
% European Arithmetic Asian Call/Put
NTime = 24;
pathS = MC_B_PW(S0,r,d,T,sigma,NTime,NSim);
PW_Delta_AA_CallPut(pathS,100,1,r,T)
PW_Vega_AA_CallPut(pathS,100,1,r,sigma,T)




