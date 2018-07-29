function [S,num] = basketsim(basketstruct,T,N,n,r)
%BASKETSIM stock price simulation engine for basket options
%
% basketstruct - get from basketset
% T - maturity time
% N - number of time intervals
% n - number of replications
% Type - type of option; asian, european, american, lookback
% r - risk free interest rate
% currently testing for european options
% Num - Number of each security 1 x number of securities
% Simulate Stock prices 
num_stock = size(basketstruct.SPrice,2);
sigma = basketstruct.Sigma;
num = basketstruct.Num;
R = chol(basketstruct.Corr); % cholesky decomposition of correlation matrix
S = zeros(n,num_stock,N+1);
for l=1:n
S(l,:,1) = basketstruct.SPrice; % Assign initial values of stock prices
end
%----------------------------
% Try to vectorize it
%----------------------------
for i = 1:n
    for j=1:num_stock
        for k = 2:N+1
            S(i,j,k) = S(i,j,k-1)*exp((r - (sigma(j)^2)/2)*(T/N) + ...
                sigma(j)*R(j,:)*randn(num_stock,1)*sqrt(T/N));
        end
    end
end


