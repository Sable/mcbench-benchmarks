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

% Different methods for construction a SABR density (see book)

a = zeros(1,2); b = a; n = a; r = a; f = a; % init
% model 1 (good parameters) 2 (ugly parameters)
b(1) = 0.5; b(2)=0.5;           % CEV coefficient
f(1) = 0.0495; f(2) = 0.03;     % forward    
a(1) = 0.1339 * f(1)^(1-b(1)); a(2)=0.9*f(2)^(1-b(2));
n(1) = 0.3843; n(2)=0.2;        % nu
r(1) = -0.1595; r(2)=-0.2;      % correlation

t=5;                            % maturity
k = 0.0001:0.0001:0.3;          % strike range
y1 = zeros(5,length(k));         % init output
y = y1;
 
for i =1:2
    y1(1,:) = psabr(a(i),b(i),r(i),n(i),f(i),k,t);
                                % standard method
    y1(2,:) = psabr_1(a(i),b(i),r(i),n(i),f(i),k,t,...
        2, 3, .5*f(i), 3*f(i));          % Kainth method
    y1(3,:) = psabr_flat(a(i),b(i),r(i),n(i),f(i),k,t,...
        .75,5);                 % flat extrapolation
    y1(4,:) = psabr_regime(a(i),b(i),r(i),n(i),f(i),k,t,...
        .75,2);                  % regimes
    y1(5,:) = psabr_4_2(a(i),b(i),r(i),n(i),f(i),k,t,...
        2,2,2,.25,10);           % extrapolation       

    ymax = max(y1(5,:));
    figure('Color', [1 1 1]); hold on;
    plot(k(2:4:end),y1(1,2:4:end),':','Color',[0 0 0]); plot(k(2:4:end),y1(2,2:4:end),'-','Color',[0 0 0]);
    plot(k(2:4:end),y1(3,2:4:end),'--','Color',[0 0 0]); plot(k(2:4:end),y1(4,2:4:end),'-.','Color',[0 0 0]);
    plot(k(2:4:end),y1(5,2:4:end),'-x','Color',[0 0 0], 'MarkerSize', 3);
    xlim([0 0.2]);
    ylim([-2 ymax+.5]);
    title('Densities');
    legend('Hagan', 'Kainth', 'Flat', 'Regime', 'Kienitz')
    hold off;
    
    y(1,:) = sprice(a(i),b(i),r(i),n(i),f(i),k,t,1);
    y(2,:) = sprice_1(a(i),b(i),r(i),n(i),f(i),k,t,2, 3, .5*f(i), 3*f(i),1);
    y(3,:) = sprice_flat(a(i),b(i),r(i),n(i),f(i),k,t,.75,5,1);
    y(4,:) = sprice_regime(a(i),b(i),r(i),n(i),f(i),k,t,.75,2,1);
    y(5,:) = sprice_4_2_fast(a(i),b(i),r(i),n(i),f(i),k,t,2,2,2,.25,10,1);

    figure('Color', [1 1 1]); hold on;
    plot(k(2:4:end),y(1,2:4:end),':','Color',[0 0 0]); plot(k(2:4:end),y(2,2:4:end),'-','Color',[0 0 0]);
    plot(k(2:4:end),y(3,2:4:end),'--','Color',[0 0 0]); plot(k(2:4:end),y(4,2:4:end),'-.','Color',[0 0 0]);
    plot(k(2:4:end),y(5,2:4:end),'-x','Color',[0 0 0], 'MarkerSize', 3);
    xlim([0 0.2]);
    title('Call Option Prices');
    legend('Hagan', 'Kainth', 'Flat', 'Regime', 'Kienitz');
    hold off;
end
