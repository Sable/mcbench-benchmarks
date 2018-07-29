function [A_t,sig_A,D_t,s,p,R,d1] = calcMertonModel(E_t,sig_E,K,t,T,r)

% Calculates the Value of Firm Assets, Volatility of Firm Assets,
% Debt-Value, Credit-Spread, Default Probability and Recovery Rate as per
% Merton's Structural Credit Model. The value and volatility of firm assets
% are found by Bivariate Newton Root-Finding Method of the Merton
% Simultaneuous Equations. The Newton Method is carried out matrixwise
% (i.e. fully vectorised) in a 3d Jacobian so that bivariate ranges of 
% (E_t,sig_E,K,T) values may simultaneuously calculated. (See Examples)
%
%  Function requires mtimesx.m available on the Matlab File Exchange at
%  http://www.mathworks.com/matlabcentral/fileexchange/25977-mtimesx-fast-matrix-multiply-with-multi-dimensional-support
%
%
% Outputs
%   A_t:      Value of Firm's Assets   [A_t = Call(K,sig_A,A_t,t,T,r)]
%   sig_A:    Volatility of Firm's Assets
%   D_t:      Value of Firm Debt   [D_t = pv(K) - Put(K,sig_A,A_t,t,T,r)]
%   s:        Credit Spread
%   p:        Default Probability
%   R:        Expected Recovery
%   d:        Black-Scholes Parameter Anonymous Function
%
%
% Inputs
%   E_t:    Value of Equity
%   sig_E:  Equity Volatility
%   K:      Debt Barrier
%   t:      Estimation Time (Years)
%   T:      Maturity Time (Years)
%   r:      Risk-free-Rate
%
%
% Example 1
%   T = 5;
%   t = 0;
%   K = 500;
%   sig_E = 0.5;
%   r = 0.05;
%   E_t = 1200;
%   [A_t,sig_A,D_t,s,p,R,d1] = calcMertonModel(E_t,sig_E,K,t,T,r);
%
% Example 2: Variates (sig_E,E_t)
%   t = 0; r = 0.05;
%   sig_E = (0.05:0.05:0.8)'; E_t = (100:100:2000)';
%   [sig_E,E_t] = meshgrid(sig_E,E_t);
%   K = repmat(600,size(sig_E)); T = repmat(5,size(sig_E));
%   [A_t,sig_A,D_t,s,p,R,d1] = calcMertonModel(E_t,sig_E,K,t,T,r);
%
% Example 3:  Variates (K,T)
%   t = 0; r = 0.05;
%   K = (100:100:4000)'; T = (0.1:0.1:10)';
%   [K,T] = meshgrid(K,T);
%   sig_E = repmat(0.4,size(K)); E_t = repmat(1300,size(K));
%   [A_t,sig_A,D_t,s,p,R,d1] = calcMertonModel(E_t,sig_E,K,t,T,r);



%% RESHAPE VARIABLES TO 3D TO FACILITATE MATRIXWISE BIVAR NEWTON-REPHSON

[n,m] = size(E_t);
nm = n*m;

E_t = reshape(E_t,1,1,nm); sig_E = reshape(sig_E,1,1,nm); K = reshape(K,1,1,nm); T = reshape(T,1,1,nm);


%% DEFINE JACOBIAN ANONYMOUS FUNCTION FOR [A_t & sig_A] SOLUTION

d1 = @(A_t,sig_A,C)((1./(sig_A(:,:,C).*sqrt(T(:,:,C)-t))).*(log(A_t(:,:,C)./K(:,:,C)) + (r + 0.5.*sig_A(:,:,C).^2).*(T(:,:,C)-t)));
d2 = @(A_t,sig_A,C)((1./(sig_A(:,:,C).*sqrt(T(:,:,C)-t))).*(log(A_t(:,:,C)./K(:,:,C)) + (r - 0.5.*sig_A(:,:,C).^2).*(T(:,:,C)-t)));


% System of Nonlinear Equation
fcnF1 = @(A_t,sig_A,C)((A_t(:,:,C).*fcnN(d1(A_t,sig_A,C))-K(:,:,C).*exp(-r*(T(:,:,C)-t)).*fcnN(d2(A_t,sig_A,C)))-E_t(:,:,C));
fcnF2 = @(A_t,sig_A,C)(A_t(:,:,C).*sig_A(:,:,C).*fcnN(d1(A_t,sig_A,C))-sig_E(:,:,C).*E_t(:,:,C));
fcnF = @(A_t,sig_A,C)([fcnF1(A_t,sig_A,C);fcnF2(A_t,sig_A,C)]);


% Define Partial Derivative Functions of Equation Set
fcnJ11 = @(A_t,sig_A,C)(fcnN(d1(A_t,sig_A,C)));
fcnJ12 = @(A_t,sig_A,C)(A_t(:,:,C).*sqrt((T(:,:,C)-t)).*fcnn(d1(A_t,sig_A,C)));
fcnJ21 = @(A_t,sig_A,C)(fcnN(d1(A_t,sig_A,C)).*sig_A(:,:,C)+(fcnn(d1(A_t,sig_A,C))./sqrt((T(:,:,C)-t))));
fcnJ22 = @(A_t,sig_A,C)(A_t(:,:,C).*fcnN(d1(A_t,sig_A,C)) + A_t(:,:,C).*sig_A(:,:,C).*fcnn(d1(A_t,sig_A,C)).*((-log(A_t(:,:,C)./(K(:,:,C).*exp(-r.*(T(:,:,C)-t))))./((sig_A(:,:,C).^2).*sqrt(T(:,:,C)-t)))+(0.5*sqrt(T(:,:,C)-t))));


% Define Jacobian Matrix
fcnJ = @(A_t,sig_A,C)([fcnJ11(A_t,sig_A,C),fcnJ12(A_t,sig_A,C);fcnJ21(A_t,sig_A,C),fcnJ22(A_t,sig_A,C)]);


%% SOLVE FOR ASSET VALUE & VOLATILITY [A_t & sig_A]

tolMat=1e-10;
k_max = 20;
k = 1;

% Initial Estimates for A_t & sig_A
A_t = E_t+K;
sig_A = sig_E.*E_t./(E_t+K);


A_t = reshape(A_t,1,1,nm); sig_A = reshape(sig_A,1,1,nm); C = true(1,1,nm);
x = [A_t;sig_A];

while any(C) && k<=k_max
    
    dx = mtimesx(inv3d(fcnJ(x(1,:,:),x(2,:,:),C)),fcnF(x(1,:,:),x(2,:,:),C));
    x(:,:,C) = x(:,:,C) - dx;
       
    C = any(abs(fcnF(x(1,:,:),x(2,:,:),true(1,1,nm)))>tolMat,1);
    k = k + 1;
    
end

A_t = x(1,:,:); A_t = reshape(A_t,n,m);
sig_A = x(2,:,:); sig_A = reshape(sig_A,n,m);

E_t = reshape(E_t,n,m); K = reshape(K,n,m);  T = reshape(T,n,m); 

%% SOLVE FOR FIRM DEBT VALUE [D_t]

% D_t = K * exp(-r*(T-t)) - (K * exp(-r*(T-t)) * normcdf(-d(-1,A_t,sig_A,T,t,K,r),0,1) - A_t * normcdf(-d(1,A_t,sig_A,T,t,A_t,K,r),0,1));

D_t = A_t - E_t; % Balance Sheet


%% SOLVE FOR CREDIT SPREAD [s]

% D_t = K*exp(-(r+s)*(T-t))

s = -(log(D_t./K)./(T-t))-r;


%% SOLVE FOR DEFAULT PROBABILITY [p]

% Redefine Black-Scholes Functions Since Variables have been reshaped
d1 = @(A_t,sig_A,C)((1./(sig_A(:,:,C).*sqrt(T(:,:,C)-t))).*(log(A_t(:,:,C)./K(:,:,C)) + (r + 0.5.*sig_A(:,:,C).^2).*(T(:,:,C)-t)));
d2 = @(A_t,sig_A,C)((1./(sig_A(:,:,C).*sqrt(T(:,:,C)-t))).*(log(A_t(:,:,C)./K(:,:,C)) + (r - 0.5.*sig_A(:,:,C).^2).*(T(:,:,C)-t)));

p = fcnN(-d2(A_t,sig_A,true)); % P(A_t < K) = N(-d_m)


%% EXPECTED RECOVERY ON DEFAULT [R]

R = exp(r.*(T-t)) .* (A_t./K) .* (fcnN(-d1(A_t,sig_A,true))./fcnN(-d2(A_t,sig_A,true)));


end

%
%
%
%

%% SUBFUNCTIONS

function p=fcnN(x)
p=0.5*(1.+erf(x./sqrt(2)));
end
%
function p=fcnn(x)
p=exp(-0.5*x.^2)./sqrt(2*pi);
end

function Y = inv3d(X)
    Y = -X;
    Y(2,2,:) = X(1,1,:);
    Y(1,1,:) = X(2,2,:);
    detMat = 1./(X(1,1,:).*X(2,2,:) - X(1,2,:).*X(2,1,:));
    detMat = detMat(ones(1,2),ones(2,1),:);
    Y = detMat.*Y;
end
