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
% This script demonstrates the use of function QUADPROG on the basis of
% the Markowitz mean-variance portfolio optimization problen

clear
close all
clc
warning 'off'

% load matrix data 
% of annualized linear stock returns
load 'LinRetMat'

% M: number of samples
% N: number of assets
[~,N] = size(data);
% sample mean
mu = mean(data)';
% sample covariance
Sigma = cov(data);


% Objective function 0.5*x'Hx + c'x
%---------------------------
H = 2.0*Sigma;
c = zeros(N,1);

% Constraints
%---------------------------
% weights sum to one
Aeq = ones(1,N);
beq = 1.0;
% no short-sales
A = -eye(N);
b = zeros(N,1);

% Minimum Variance Portfolio
%---------------------------
[weightsP,sigmaP2] = quadprog(H,c,A,b,Aeq,beq);
muP = weightsP'*mu;

% maximum return
muMax = max(mu);

% number portfolios
M = 50;
% stepsize of returns
delta = (muMax - muP)/(M-1);

% preallocate cache
weightsMat = zeros(N,M);    % matrix of portfolio weights
sigmaVec = zeros(M,1);      % expected volatility of portfolios
muVec = zeros(M,1);         % expected return of portfolios

% add minimum variance portfolio
weightsMat(:,1) = weightsP;
sigmaVec(1) = sqrt(sigmaP2);
muVec(1) = muP;

% compute efficient portfolios
for i = 2:M
    % set equality constraints w1 + w2 +...+ wN = 1 and w'*mu = R
    Aeq = [ones(1,N); mu'];
    beq = [1.0; muP + (i-1)*delta];
    % start optimization
    [weightsMat(:,i),sig2] = quadprog(H,c,A,b,Aeq,beq);
    
    sigmaVec(i) = sqrt(sig2);
    muVec(i) = weightsMat(:,i)'*mu;
end

weightsMat(weightsMat < 0.001) = 0.0;

% Create figure
figure1 = figure('Color',[1 1 1]);
colormap('gray');

% plot efficient frontier
subplot(1,2,1)
plot(sigmaVec,muVec,'k','LineWidth',1.5)
legend('Efficient Frontier','Location','NorthWest')
set(gca,'xlim',[0 sigmaVec(end)],'ylim',[0 muVec(end)])
title('Mean-Variance Efficient Frontier','FontSize',17)
xlabel('$\sigma$','Interpreter','latex','FontName','Helvetia','FontSize',16)
ylabel('$\mu$','Interpreter','latex','FontName','Helvetia','FontSize',16,'Rotation',0)
ticks = get(gca,'YTick');
set(gca,'YTickLabel',[num2str(ticks'*100),repmat('%',length(ticks),1)])
ticks = get(gca,'XTick');
set(gca,'XTickLabel',[num2str(ticks'*100),repmat('%',length(ticks),1)])
% plot portfolio weights
subplot(1,2,2)
Data = cumsum(weightsMat,1);
step = (0.8-0.3)/(N-1);
colMat = repmat((0.3:step:0.8)',1,3);
for k = 1:N
    hold on
    fill([sigmaVec(1);sigmaVec;sigmaVec(end)],[0,Data(N-k+1,:),0]',colMat(k,:));
end
set(gca,'xlim',[sigmaVec(1) sigmaVec(end)],'ylim',[0 max(max(Data))])
title('Weights of the Efficient Portfolios','FontSize',17)
xlabel('$\sigma$','Interpreter','latex','FontName','Helvetia','FontSize',16)
ylabel('$w$','Interpreter','latex','FontName','Helvetia','FontSize',16,'Rotation',0)
ticks = get(gca,'YTick');
set(gca,'YTickLabel',[num2str(ticks'*100),repmat('%',length(ticks),1)])
ticks = get(gca,'XTick');
set(gca,'XTickLabel',[num2str(ticks'*100),repmat('%',length(ticks),1)])
legend([repmat('w_{',N,1),num2str((1:N)'),repmat('}',N,1)])