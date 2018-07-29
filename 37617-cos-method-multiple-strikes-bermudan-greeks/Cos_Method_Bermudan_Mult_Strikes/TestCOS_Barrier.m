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



% TestCOS_Barrier
% We consider the COS method
% The test considers discretely monitored Barrier options
clear; clc;
close all;

n = 8;%(7:15)';                % N = 2^n
num = size(n, 1);

S0 = 100;            % spot price of underlying
strike = (80:1:120)';  % strike price
Nex = 12;            % number of observation dates
Hl = 80;             % lower barrier
Hu = 120;            % upper barrier
Rb = 0;              % rebate

Nstrike = length(strike); %number of strikes

priceDOC = zeros(num, 1 + Nstrike); % down and out
priceDOC(:, 1) = n;                 % down and out Call
priceDOP = priceDOC;                % down and out Put
priceUOC = priceDOC;                % up and out Call
priceUOP = priceDOC;                % up and out Put

r = 0.05;                           % risk-free rate
t = 1;                              % time to maturity
q = 0.02;                           % dividend yield

model = 'BlackScholes';             % name of model
switch model
    case 'BlackScholes'
        sigma = 0.2;                % volatility
        c1 = (r - q - 0.5 * sigma^2) * t;
        c2 = sigma^2 * t;
        c4 = 0.0;
        c = [c1, c2, c4];
        Lcos = 20;
        % pricing functions
        pricefunc_DownAndOut = @(x, cp) FFTCOS_DownAndOut(x, Nex, Hl, Rb, Lcos, c, cp, model, S0, t, r, q, strike, sigma);
        pricefunc_UpAndOut = @(x,cp) FFTCOS_UpAndOut(x, Nex, Hu, Rb, Lcos, c, cp, model, S0, t, r, q, strike, sigma);
    case 'CGMY'
        C = 4; G = 50;M = 60; Y = 0.7;
        c1 = ( (r - q) + C*gamma(1-Y)*(M^(Y-1)-G^(Y-1)) )*t;
        c2 = C*gamma(2-Y)*(M^(Y-2)+G^(Y-2))*t;
        c4 = C*gamma(4-Y)*(M^(Y-4)+G^(Y-4))*t;
        c = [c1, c2, c4];
        Lcos = 20;     
        % pricing functions
        pricefunc_DownAndOut = @(x,cp) FFTCOS_DownAndOut(x, Nex, Hl, Rb, Lcos, c, cp, model, S0, t, r, q, strike, C,G,M,Y);
        pricefunc_UpAndOut = @(x,cp) FFTCOS_UpAndOut(x, Nex, Hu, Rb, Lcos, c, cp, model, S0, t, r, q, strike, C,G,M,Y);
end
for j = 1:num
    priceDOC(j,2:end) = pricefunc_DownAndOut(n(j),1);
    priceDOP(j,2:end) = pricefunc_DownAndOut(n(j),-1);
    priceUOC(j,2:end) = pricefunc_UpAndOut(n(j),1);
    priceUOP(j,2:end) = pricefunc_UpAndOut(n(j),-1);
end

DOC = priceDOC(end,2:end)
DOP = priceDOP(end,2:end)
UOC = priceUOC(end,2:end)
UOP = priceUOP(end,2:end)

if Nstrike > 1
    figure('Color', [1 1 1]); hold on;
    plot(strike',priceDOC(:,2:end), '-','Color', [0 0 0]);
    plot(strike',priceDOP(:,2:end), '--','Color', [0 0 0]);
    plot(strike',priceUOC(:,2:end), ':','Color', [0 0 0]);
    plot(strike',priceUOP(:,2:end), '.-','Color', [0 0 0]);
    hold off;
    title('Prices of Discretely Monitored Barrier Options');
    xlabel('Strike');
    ylabel('Option Value');
    legend('DOC', 'DOP', 'UOC', 'UOP');
end
if num > 1
    figure; plot(n, log10(abs(repmat(priceDOC(end,2:end),num,1)-priceDOC(:,2:end))));
end