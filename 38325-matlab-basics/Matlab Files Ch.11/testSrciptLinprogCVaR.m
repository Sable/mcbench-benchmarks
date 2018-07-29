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

%-----------------------------------------------------------------------
% This script demonstrates the use of function LINPROG on the basis of
% the C-VaR portfolio optimization problen given in:
% Uryasev, Rockafellar: Optimization of Conditional Value-at-Risk(1999)

clear
close all
clc
warning 'off'

tic

% load matrix data 
% of annualized linear stock returns
load 'LinRetMat'

% M: number of samples
% N: number of assets
[M,N] = size(data);
% sample mean
mu = mean(data)';

% confidence level
beta = 0.99;

% number portfolios
NumPorts = 50;
% target returns
Rstar = min(mu):(max(mu)-min(mu))/(NumPorts-1):max(mu);
% objective function vector
f = objfCVaR(beta, M, N);
% constraints matrices
[A, b, Aeq, beq, lb, ub] = constCVaR(data, mu, Rstar(1));

CVaR    = zeros(NumPorts,1);
weights = zeros(N,NumPorts);

for i = 1:NumPorts
    beq(1) = -Rstar(i);
    [optimvar, CVaR(i)] = linprog(f, A, b, Aeq, beq, lb, ub);
    weights(:,i) = optimvar(1:N);
end

toc
warning 'on'


% Create figure
figure1 = figure('Color',[1 1 1]);
colormap('gray');

% plot efficient frontier
plot(CVaR,Rstar,'k','LineWidth',1.5)
legend('Mean-CVaR Frontier','Location','NorthWest')
set(gca,'xlim',[0 CVaR(end)],'ylim',[0 Rstar(end)])
title('Mean-CVaR Frontier','FontSize',17)
xlabel('$\beta$-CVaR','Interpreter','latex','FontName','Helvetia','FontSize',16)
ylabel('$\mu$','Interpreter','latex','FontName','Helvetia','FontSize',16,'Rotation',0)
ticks = get(gca,'YTick');
set(gca,'YTickLabel',[num2str(ticks'*100),repmat('%',length(ticks),1)])
ticks = get(gca,'XTick');
set(gca,'XTickLabel',[num2str(ticks'*100),repmat('%',length(ticks),1)])
