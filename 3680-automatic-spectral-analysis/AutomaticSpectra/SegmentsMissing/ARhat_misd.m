function [rc,fval,it] = ARhat_misd(ng,xg,rcinit,rc0,lag_max)

%ARHAT_MISD AR model from measurements with missing data
%  [rc,fval,it] = ARhat_misd(ng,xg,rcinit,rc0,lag_max) estimates
%  reflection coefficients from missing data (ng,xg). ng contains
%  measurement times and xg the corresponding measurements.
%  
%  The starting value for the reflection coefficients is given by
%  rc_start = [1 rc0 rcinit]
%  An AR model is estimated using approximate Maximum Likelihood (ML)
%  estimation, where rc0 is fixed and the ML is sought over the last
%  reflection coefficients, starting in rcinit.
%
%  See also ARMLFIT, ARHAT_MISD.

nseg = length(ng);
n_obs = 0;
for seg = 1:nseg
   n_obs = n_obs+length(ng{seg});
end

opties = optimset('Display','iter','TolX',.001/sqrt(n_obs),'TolFun',.0001);

[rc_tan,fval,exitflag,output]= fminunc('ARMLfit',tan(.5*pi*rcinit),opties,ng,xg,rc0,lag_max);
rc = 2/pi*atan(rc_tan);
it = output.iterations;
