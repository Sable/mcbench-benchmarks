function [pred, covpred] = arma2pred(a,b,sig,Lpred);
%
% function [pred covpred] = arma2pred(a,b,sig,lpred);
% 
% a        AR parameter vector used to predict, starting with 1
% b        MA parameter vector used to predict, starting with 1
% sig      input signal, the future of which must be predicted
% Lpred    length of predicted signal
%
% pred     vector of predictions
% covpred  vector of relative prediction accuracies 
%          (relative with respect to innovation variance)
%
% prediction is optimal for: true a and b 
%                            no knowledge before the interval of sig
%                            driving noise is zero mean
%
% Algorithm from
% R.H. Jones: 
% "Maximum Likelihood Fitting of ARMA Models to
%         Time Series With Missing Obsevations",
% Technometrics vol 22, no 3, aug 1980.
%
% Robert Bos - 12 maart 2003.
% Robert Bos - 17 dec   2003.

sig=sig-mean(sig);

ar_par = -a;
ma_par = b;
% remove constant 1 from parameter vectors
ar_par(1)=[];
ma_par(1)=[];
ar_order = length(ar_par);
ma_order = length(ma_par);

n = length(sig);
% determine m with (2.3)
m = max(ar_order, ma_order + 1);

% fill up parameter vectors with zeros
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

% compute g oefficients (2.13)
g = zeros(m,1);
g(1) = 1;
for i = 2:m;
    g(i)  = ma_par(i-1);
    for j = 1:(i-1)
        g(i) = g(i) + ar_par(j) .* g(i-j);
    end
end

% State matrix F (2.15) and (2.16):
F = zeros(m,m);
for i = 1:(m-1)
    F(i,i+1) = 1;
end
F(m,:) = fliplr(ar_par);

% G matrix (2.15) and (2.16):
G = g;

% H matrix for observation matrix in (2.17):
H = zeros(1,m);
H(1,1) =1;

% No noise on observations;
R = 0;

% ====================================================
% ----------------- Starting matrix -------------------
% ====================================================

[C, gain] = arma2cor([1 -ar_par], [1 ma_par]);
C = C .* gain;

% startmatrix for Kalmanfilter via 4.12

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
% This program gives the covariance of the state for sigma=1; 
% sigma can be omitted in (3.2) then. 

% startvalue state vector is zero vector:

Z = zeros(m,1);
% ---------------------- Filter -----------------------
t = 1;
k = 1;
Delta = zeros(m,1);

while t <= n + Lpred
    if  t <= n
        V = (P(1,1) + R); 
        y = (sig(k) - Z(1));
        Delta = P*H'./(P(1,1) + R);
        Z = Z + Delta*y;
        P = P - Delta*H*P;
        k = k + 1;
    else
        pred(t-n)=Z(1);
        covpred(t-n)=P(1,1);
    end
    % predict state 
    Z = F*Z;
    P = F*P*F' + G*G';
    t = t + 1;
end

