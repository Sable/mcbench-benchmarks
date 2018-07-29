function lh = jonesfit(rcs,ti,xi,p);
%
% function lh = jonesfit(rcs,ti,xi,p);
% ti input missing data integer time instants
% xi input signal
% rcs = tan(.5*pi*rc), length p + q
% p AR order
%
% Computes likelihood of missing data observations
% Algorithm based on paper R.H. Jones: "Maximum Likelihood
% Fitting of ARMA Models to Time Series With Missing Obsevations",
% Technometrics vol 22, no 3, aug 1980.
%
% Robert Bos - 12 maart 2003.
% 
%   rcs = tan(.5*pi*rc)
%   In this way, the reflection coefficient [-1,+1] is mapped to
%   [-Inf,+Inf], allowing the use of unconstrained optimization.
%

rcar = 2/pi*atan(rcs(1:p));
if any(~isreal(rcar)),lh = +Inf; return; end 
if any(isnan(rcar)),lh = +Inf; return; end 
a = rc2arset([1 rcar]);
a(1)=[];
rcma = 2/pi*atan(rcs(p+1:end));
if any(~isreal(rcma)),lh = +Inf; return; end 
if any(isnan(rcma)),lh = +Inf; return; end 
b = rc2arset([1 rcma]);
b(1)=[];

ar_par = -a;
ma_par = b;
ar_order = length(ar_par);
ma_order = length(ma_par);

n = length(ti);
% look for m (2.3)
m = max(ar_order, ma_order + 1);

% parameters with nulls added
if (ar_order < m)
    for i = ar_order+1:m
        ar_par(i) = 0;
    end
end
if (ma_order < m)
    for i = ma_order+1:m
        ma_par(i) = 0;
    end
end

% Compute g (2.13)
g = zeros(m,1);
g(1) = 1;
for i = 2:m;
    g(i)  = ma_par(i-1);
    for j = 1:(i-1)
        g(i) = g(i) + ar_par(j) .* g(i-j);
    end
end

% State matrix F initialized (2.15):
F = zeros(m,m);
for i = 1:(m-1)
    F(i,i+1) = 1;
end
F(m,:) = fliplr(ar_par);

% G matrix initialized (2.15):
G = g;

% H matrix for observations:
H = zeros(1,m);
H(1,1) =1;

% no noise on data
R = 0;

% ====================================================
% ----------------- start-up matrix -------------------
% ====================================================

[C, gain] = arma2cor([1 -ar_par], [1 ma_par]);
C = C .* gain;

% compute start matrix for Kalman filter via 4.12

P = zeros(m,m);
P(1,:) = C(1:m);
P(:,1) = C(1:m)';
for i = 1:(m-1);
    for j = i:(m-1);
        P(i+1,j+1) = C(1+j-i);
        for k = 0:(i-1)
            P(i+1,j+1) = P(i+1,j+1) - g(1+k).*g(1+k+j-i);
        end
        P(j+1,i+1) = P(i+1,j+1);
    end
end

% INTERMEZZO: Scaling of P.

% State covariance of sigma = 1. Eliminates sigma from 3.2. 

% start state vector is set null:

Z = zeros(m,1);
% ---------------------- Filter -----------------------
t = ti(1);
k = 1;
Delta = zeros(m,1);

som_lh_1 = 0;
som_lh_2 = 0;

while (t<(ti(end)+1))
    % Is there an observation?
    if (t == ti(k))
        V = (P(1,1) + R); 
        % Scaling V is not important
        % has no influence on likelihood value.

        y = (xi(k) - Z(1));

        som_lh_1 = som_lh_1 + y.*y ./ V;
        som_lh_2 = som_lh_2 + log(V);
        
        Delta = P*H'./(P(1,1) + R);
        Z = Z + Delta*y;
        P = P - Delta*H*P;
        k = k + 1;
    end
    % predict state: 
    Z = F*Z;
    P = F*P*F' + G*G';
    t = t + 1;
end

% ===================================================
% ------------- compute Likelihood ----------------
% ===================================================
% Likelihood according to 3.15

lh = som_lh_2;

lh = lh + n.*log(som_lh_1);

% Exact likelihood (with constants):
lh = lh + n - n*log(n);

if isnan(lh), lh = +Inf; end
