function [lh_AR, varx] = ARMLfit(rcs,ng,xg,rc0,lag_max)

% The conditional-likelihood fit.
%
%   rcs = tan(.5*pi*rc)
%   In this way, the reflection coefficient [-1,+1] is mapped to
%   [-Inf,+Inf], allowing the use of unconstrained optimization.

%   S. de Waele, August 2001.

rc = 2/pi*atan(rcs);
if any(~isreal(rc)),lh_AR = +Inf; return; end 
nseg = length(xg);
npre = length(rcs)+length(rc0);
a = rc2arset([1 rc0 rc]);
%cor = par2cor(a,lag_max+1);
cor = arma2cor(a,1,lag_max);

sum_s = 0;     %The squared error in the exponent of the normal distribution
     		   %without varx and the factor -.5;
sum_lnd = 0;   %contribution of the log of the determinant without varx and the factor .5;
nobs_used = 0;

for seg = 1:nseg,
    nc = ng{seg};
    if any(floor(nc)~=nc), error('Times must contain only integers.'), end
    xc = xg{seg};
    nobsc = length(nc);
    nobs_used = nobs_used + nobsc;
    
    obs_start = 1;
    if obs_start == 1,
        obs = 1;
        sum_s = sum_s+xc(1)^2;
        sum_lnd= sum_lnd+log(1);
    end
    for obs = max(2,obs_start):nobsc
        nprev_a = min(obs-1,lag_max); %nprev_a = available previous observations
        it=find(nc(obs)-nc(obs-1:-1:obs-nprev_a)<lag_max+1);
        nprev_a=length(it);
        if nprev_a
            n1 = nc(obs:-1:obs-nprev_a)*ones(1,nprev_a+1);
            n2 = ones(nprev_a+1,1)*nc(obs:-1:obs-nprev_a)';
            lags = abs(n1-n2);
            Rn = cor(1+lags);   
            %Notations as in Random signals, K.S. Shanmugan and A.M. Breipohl, p.51.
            x1 = xc(obs);
            x2 = xc(obs-1:-1:obs-nprev_a);
            Rn11 = 1;
            Rn12 = Rn(1,2:end);
            Rn21 = Rn(2:end,1);
            Rn22 = Rn(2:end,2:end);
            muc = Rn12*(Rn22\x2);       % = Conditional mean of x1 given x2
            Rnc = 1-Rn12*(Rn22\Rn21);   % = scaled Conditional variance of x1.
            sum_s = sum_s + (x1-muc)^2/Rnc;
            sum_lnd = sum_lnd + log(Rnc);
        else
            sum_s = sum_s+xc(obs)^2;
            sum_lnd= sum_lnd+log(1);
        end      
    end  %for obs = 
end      %for seg = 1:nseg

varx = sum_s/nobs_used;

lh_AR = -nobs_used/2*log(varx)-sum_lnd/2 - sum_s/2/varx;

%Turning the Likelihood in an estimate of the K-L discrepancy:
lh_AR = -2*lh_AR;

if isnan(lh_AR), lh_AR = +Inf; end
