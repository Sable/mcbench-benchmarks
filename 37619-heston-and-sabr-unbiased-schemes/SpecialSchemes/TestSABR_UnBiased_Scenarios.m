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

% Select scenario
Scenario = 2;

if(Scenario==1)
S0 = 0.04; T = 5; sigma_0 = 0.2; alfa=0.3; beta = 1; rho = -.5;
elseif(Scenario==2)
S0 = 0.005; sigma_0 = 0.2; alfa = 0.3; beta = 0.7; rho = -0.3;
else
S0 = 0.07; sigma_0 = 0.4; alfa = 0.8; beta = 0.4; rho = -0.6;
end

T = 5;
NTime = 8;
NSim = 100000;
pathS = MC_SABR_U(S0, T, sigma_0, alfa, beta, rho, NTime, NSim);
K = 0.02:0.001:0.1;
y0 = zeros(length(K),1);
for jj = 1: length(K)
    y0(jj) = Price_CallPut(pathS,K(jj),1,0,T);
end

y1 = blsimpv(S0, K', 0, T, y0);
figure('Color',[1 1 1]); %plot(K,y,'-o','Color',[0 0 0],'MarkerSize',2);
[AX,H1,H2] = plotyy(K,y0,K,y1);
set(get(AX(1),'Ylabel'),'String','Call Prices','Color', [0 0 0 ]);
set(get(AX(2),'Ylabel'),'String','Implied Volatility','Color', [0 0 0 ]);
set(H1,'Color', [0 0 0], 'LineWidth',2);
set(H2,'Color', [0 0 0], 'LineStyle','-', 'Marker', 'o', 'MarkerSize', 3);
title('Call Prices and Implied Volatility Smile (SABR)');
