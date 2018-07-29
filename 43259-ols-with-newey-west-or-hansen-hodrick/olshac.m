function [hac, varb, beta, R2, R2adj, X2] = olshac(y,X,L,w);
% PURPOSE: computes OLS with Newey-West or Hansen-Hodrick adjusted
%           heteroscedastic-serial consistent standard errors

% Inputs:
%  y = T x 1 vector, left hand variable data
%  X = T x n matrix, right hand variable data
%  L = number of lags to include in NW or HH corrected standard errors
%  w = 1 for Newey-West weighting
%      0 for Hansen-Hodrick
%
%Note: you must make one column of X a vector of ones if you want a
%   constant.
% Output:
%  beta = regression coefficients 1 x n vector of coefficients
%  hac  = corrected standard errors.
%  R2    =    unadjusted
%  R2adj = adjusted R2
%  X2(Degrees of Freedom) = : Chi-squared statistic for all coefficients
%                               jointly zero.
%Note: program checks whether first is a constant and ignores that one for
%       test.
%Note: program automatically displays outputs in a nice format. If you want
%to disable the automatic display just comment lines 64-77.

%Estimate Betas and Residuals
[T,n]   =   size(X);
beta    =   (inv(X'*X))*X'*y;
u       =   y-X*beta;
u= u*ones(1,n);
err=X.*u; %estimating residuals for each beta
V=[err'*err]/T; %first weighting matrix

%Calculate Corrected Standard Errors
for ind_i = (1:L);
    S = err(1:T-ind_i,:)'*err(1+ind_i:T,:)/T;
    V = V + (1-w*ind_i/(L+1))*(S + S');
end;
D       =   inv((X'*X)/T);
varb = 1/T*D*V*D;
seb = diag(varb);
hac = sign(seb).*(abs(seb).^0.5);


%Calculate R2
y_bar = mean(y);
R2 = (beta'*X'*X*beta-T*(y_bar^2))/(y'*y-T*(y_bar^2));
R2adj= R2'*(T-1)/(T-n);

%F test for all coeffs (except constant) zero -- actually chi2 test
if X(:,1) == ones(size(X,1),1);
    chi2val = beta(2:end,:)'*inv(varb(2:end,2:end))*beta(2:end,:);
    dof = size(beta(2:end,1),1);
    pval = 1-cdf('chi2',chi2val, dof);
    X2(:,1:3) = [chi2val dof pval];
else;
    chi2val = beta(:,:)'*inv(varb)*beta(:,:);
    dof = size(beta(:,1),1);
    pval = 1-cdf('chi2',chi2val, dof);
    X2(:,1:3) = [chi2val dof pval];
end;


%Display Information Nicely
beta =beta';
hac=hac';
beta_hac = [ beta; hac];

for i=1:size(beta_hac,2);
    a = ' B_';
    b = num2str(i-1);
    bdisp{1,i} = strcat(a,b);
end
disp(bdisp);
disp(beta_hac);
disp(sprintf('R2 = %.2f', R2));
disp(sprintf('X2(%d) = %.1f', X2(2),X2(1)));

end




