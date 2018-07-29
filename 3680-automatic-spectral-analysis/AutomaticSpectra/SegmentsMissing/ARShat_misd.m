function [set_ar, varxh, klifit] = ARShat_misd(ng,xg,L,lag_max,set_ar_start);

%ARSHAT_MISD AR models of increasing order from measurements with missing data
%   [set_ar, varxh, klifit] = ARShat_misd(ng,xg,[Lmin Lmax],lag_max) estimates
%   autoregressive models from measurements containing missing data for
%   orders Lmin, ..., Lmax.
%   lag_max contains the maximum lag for the ARFIL algorithm for all orders
%   that are considered.
%
%   NOTE: The mean of the signal is NOT subtracted.
%
%   [set_ar, varxh, klifit] = ARShat_misd(ng,xg,[Lmin Lmax],set_ar_start)
%   The cell array set_ar_start contains starting models for all model
%   orders considered.
%
%   Output:
%   set_ar is a cell array containing all estimated models;
%   varxh  is the estimated signal variance;
%   klifit is the fit for each model in terms of the Kullback-Leibler Index
%          (kli) for missing data.
%   
%   See also: ARHAT_MISD, SIG2AR_MISD.

%S. de Waele, August 2001.

showwb = 0; %1 = Show waitbar

nseg = length(ng);
%-------------------------------------------------------------
%Reading input arguments
%-------------------------------------------------------------
mstart = 0;
if exist('set_ar_start'),
    mstart = 1;
else
    mstart = 0;
end

Lmin = L(1);
Lmax = L(2);
nk = Lmax-Lmin+1;

%-------------------------------------------------------------
%Estimation
%-------------------------------------------------------------
sumvars = 0;
for seg = 1:nseg
   sumvars = sumvars + std(xg{seg})^2;
end
varxh = sumvars/nseg

nobsi = length(xg);
set_ar = cell(nk,1);
klifit  = zeros(nk,1);

if showwb,
	hwb = waitbar(0/nk,[int2str(Lmin) ' to ' int2str(Lmax) ' AR models - ARSirr-tan']);
end

rch_prev_calc = 0; %Currently, no previous model has been calculated
for ik = 1:nk,
   k = Lmin+ik-1;
   if k == 0,
      %White noise estimate
      klifit(ik) = ARMLfit([],ng,xg,0,lag_max(ik));
      rch = [];
   else	%if k == 0
      %Determination starting point.
      %Option 1:	white noise estimate
      rc_00 = zeros(1,k);
      % klifit_wn = fit_cL_irr(rc_start,ng,xg,fs);
      klifit_wn = ARMLfit([],ng,xg,rc_00,lag_max(ik));
      rc_start = rc_00;
      klifit_start(1) = klifit_wn;
      %Option 2:	Append zero to previous model
      rc_old0 = [rch_prev 0];
      klifit_old0 = ARMLfit([],ng,xg,rc_old0,lag_max(ik));
      rc_start(2,:) = rc_old0;
      klifit_start(2) = klifit_old0;
      if mstart,
         %Option 3:	User-provided Starting Model.
         [dummy rc_sm] = ar2arset(set_ar_start{ik});
         rc_sm = rc_sm(2:end);
         klifit_sm = ARMLfit([],ng,xg,rc_sm,lag_max(ik));
         rc_start(3,:) = rc_sm;
         klifit_start(3) = klifit_sm;
      end
      %Selection of inition conditions with best fit.
      [klifit_start, i_min] = min(klifit_start);
      rc_start = rc_start(i_min,:)
      methods = {'allzero','previous+0','User-provided'};
      disp(['Selected starting point: ' methods{i_min}])
      %Optimization starting in selected point
      [rch,fit_temp] = ARhat_misd(ng,xg,rc_start,[],lag_max(ik));
      klifit(ik) = fit_temp;
      if klifit(ik) > klifit_start
         warning(['Optimization did not yield better model for k = ' int2str(k) '.'])
         rch = rc_start;
         klifit(ik) = klifit_start;
      end
   end %if k == 0
   set_ar{ik} = rc2arset([1 rch]);
   rch_prev = rch; %For the next round   
   rch_prev_calc = 1;
   if showwb,
      waitbar(ik/nk)
   end
end
if showwb,
	close(hwb)
end