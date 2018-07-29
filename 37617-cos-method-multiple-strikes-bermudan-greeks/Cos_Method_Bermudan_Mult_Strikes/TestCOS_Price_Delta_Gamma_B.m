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



clear;
clc;

n = (4:9)';                % choose number of grid points (applied to Bermudan only), N = 2^n
num = size(n, 1);

S0 = 100;     % price of underlying
strike = (10:1:190)';  % strike price
Nex = 10;     %number of exercise dates
Nstrike = length(strike); %number of strikes

price = zeros(num, 1+Nstrike);
price(:, 1) = n;
delta_g = price;
gamma_g = price;

r = 0.1;                    % annual risk-free rate (cc)
t = 1;                      % time to maturity
q = 0;                      % annual dividend yield (cc)

cp = -1;                     % choice of call (=1) or put (=-1)

% The Black Scholes model
type = 'BlackScholes';
sigma = 0.25;                % volatility of the share, per sqrt(unit) time
c1 = (r - q - 0.5 * sigma^2) * t;
c2 = sigma^2 * t;
c4 = 0.0;
% cosine method
Lcos = 13;     
c = [c1, c2, c4];
pricefunc_cos = @(x) FFTCOS_B(x, Nex, Lcos, c, cp, type, S0, t, r, q, strike, sigma);

% % The CGMY model
% type = 'CGMY';
% C = .5;                
% G = 3;
% M = 3;
% Y = .5;
% c1 = ( (r - q) + C*gamma(-Y)*(M^(Y-1)-G^(Y-1)) )*t;
% c2 = C*gamma(2-Y)*(M^(Y-2)+G^(Y-2))*t;
% c4 = 3 + C*gamma(4-Y)*(M^(Y-4)+G^(Y-4))*t/(C*gamma(2-Y)*(M^(Y-2)+G^(Y-2)))^2;
% % cosine method
% Lcos = 13;     
% c = [c1, c2, c4];
% pricefunc_cos = @(x) FFTCOS_B(x, Nex, Lcos, c, cp, type, S0, t, r, q, strike, C,G,M,Y);

for j = 1:num
   [price(j,2:end), delta_g(j,2:end), gamma_g(j,2:end)] = pricefunc_cos(n(j));
end


[pr, de, ga] = pricefunc_cos(15);

figure('Color', [1 1 1]); hold on;
plot(strike',price(:,2:end));
plot(strike', pr,'-o');
hold off;
legend('N=4', 'N=5', 'N=6', 'N=7', 'N=8', 'N=9');
title('Price Bermuda Option COS');
xlabel('Strike'); ylabel('Price');
figure('Color', [1 1 1]); hold on;
plot(strike',delta_g(:,2:end));
plot(strike', de,'-o');
hold off;
legend('N=4', 'N=5', 'N=6', 'N=7', 'N=8', 'N=9');
title('\Delta Bermuda Option COS');
xlabel('Strike'); ylabel('Price');
figure('Color', [1 1 1]); hold on;
plot(strike',gamma_g(:,2:end));
plot(strike', ga,'-o');
hold off;
legend('N=4', 'N=5', 'N=6', 'N=7', 'N=8', 'N=9');
title('\Gamma Bermuda Option COS');
xlabel('Strike'); ylabel('Price');



