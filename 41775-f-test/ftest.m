function [ p, Fstat, df1, df2 ] = ftest(n,np1,np2,chi1,chi2)
% [ p ] = ftest(n,np1,np2,chi1,chi2)
% function to test whether addition of model parameters to 
%     fit data is warranted by level of misfit improvement
%
% Inputs 
% n = # of data
% np1, np2 = number of free parameters for each fit.
% chi1 & chi2 = sum of squares of misfits for two models.
%     must be positive values
%     normalization of chis by n not required
%     (normalization divides out in Fstatistic)
%
% Outputs
% p = probability (between 0 - 1) that improvement to fit from 
%     addition of parameters is due to chance. I.e.,
%     0 means certainty that extra parameters are warranted
%     1 means improvement undoubtedly attributable to chance
% If desired, will also return F-statistic (Fstat) and
%     degrees of freedom (df1, df2) for f-distribution
%
% Written by James Conder, Southern Illinois University, Oct. 2010
% Citation:
%     Anderson, K.B. & Conder, J.A., Discussion of Multicyclic Hubbert 
% Modeling as a Method for Forecasting Future Petroleum Production, 
% Energy & Fuels, dx.doi.org/10.1021/ef1012648, 2011
%
% Update June, 2011
%   Check added for df1=1 (giving -Inf). Use MatrixLabs approximation
%   for f when df1=1. Accuracy ok, but some small differences against
%   fcdf
%
% Update May 31, 2012
%   Allow Fstat, df1, & df2 as outputs.
%   Use fcdf from matlab statistics toolbox if available (fast)
%   Some cosmetic clean up 
%
% Comments & questions should be directed to conder@siu.edu
%----------------------


%%% check ordering. np2 should be > np1 and chi2 should be < chi1
% i.e., second model should have more parameters and better fit
if np2 == np1
    disp('number of model parameters are the same in both cases!')
    p = 1;
    return
elseif np2 < np1        % np1 should be less than np2. If not, just swap.
    nptemp = np1; np1 = np2; np2 = nptemp;
    chitemp = chi1; chi1 = chi2; chi2 = chitemp;
end

if chi2 >= chi1
    disp('misfit higher for model with more parameters!')
    p = 1;
    return
end

%%% number of degrees of freedom for f-distribution
df1 = np2 - np1;		% number of degrees of freedom
df2 = n - np2 - 1;

%%% F-statistic
Fstat = df2*(chi1 - chi2)/(df1*chi2);


%%% find p by determination of cumulative f-distribution at Fstat
% first check if fcdf from matlab statistics toolbox is present (fast).
% if not, numerically integrate f-distribution.
% cdff is equivalent to result from fcdf in Matlab statistics package.

if exist('fcdf.m','file') == 2       % check for availability of fcdf from statistics toolbox
    p = 1 - fcdf(Fstat,df1,df2);
else
    if df1 ~= 1         % numerically integrate f-distribution		
        ifpt = 1000001; % large number of slices for accurate numerical integration
        dx = Fstat/(ifpt-1);
        x = 0:dx:1.2*Fstat;

        fnumgam = gammaln((df1+df2)/2);		% gamma func factors can be very large, use ln
        fdengam = gammaln(df1/2) + gammaln(df2/2);
        fgam = exp(fnumgam - fdengam);

        fnum = fgam*((df1/df2)^(df1/2)).*(x.^(0.5*df1 -1));
        fden = ((1 + df1*x/df2).^(0.5*(df1+df2)));
        f = fnum./fden;	% f distribution for df1, df2
        %fF = f(ifpt);		% f at Fstat

        cdff = cumsum(f)*dx;	% numerical integration of f distribution
        p = 1 - cdff(ifpt);
    else    % when df1=1 use F-dist approximation from MatrixLabs to avoid -Inf
        if Fstat <= 0.5    % Compute using inverse for small F-values
            s = df2;
            t = df1;
            z = 1/Fstat;
        else
            s = df1;
            t = df2;
            z = Fstat;
        end
        j = 2/(9*s);
        k = 2/(9*t); 

        % Use approximation formulas
        y = abs((1 - k)*z^(1/3) - 1 + j)/sqrt(k*z^(2/3) + j);
        if t < 4
            y = y*(1 + 0.08*y^4/t^3);
        end 

        a1 = 0.196854;
        a2 = 0.115194;
        a3 = 0.000344;
        a4 = 0.019527;
        p = 0.5/(1 + y*(a1 + y*(a2 + y*(a3 + y*a4))))^4;

        % Adjust if inverse was computed
        if Fstat <= 0.5
            p = 1 - p;
        end 
     end
end

end

