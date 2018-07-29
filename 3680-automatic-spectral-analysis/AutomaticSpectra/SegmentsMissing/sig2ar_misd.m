function [ar, sellog] = sig2ar_misd(ng,xg,L,varargin);

%SIG2AR_MISD Estimation of AR models from measurements with missing data.
%[ar, sellog] = sig2ar_misd(ng,xg,L)
%   Estimates AR models from measurements (ng,xg) with missing data.
%   L:		Either Lmax = maximum order
%           or [Lmin Lmax] = [minimum order maximum order].
%
%   [ar, sellog] = sig2ar_misd(tg,xg,L,model_start)
%   model_start: a cell containing starting models for the models to
%                be calculated. The starting models are reflection
%                coefficients at interval Tm including the leading 1.
%
%   Additional settings are:
%   mean_adj:    0: mean not subtracted / 1: mean subtracted; [default = 1].
%   pengic:      penalty factor for order selection; [default = 6].
%
%   Example:
%   [ar, sellog] = sig2ar_misd(ti,xi,Tg,Tm,[3 6],set_ar_start,'mean_adj',0,'pengic',8)
%
%   See also: SIG2AR.

%S. de Waele, March 2003.

if ~iscell(ng),
  ng = {ng}
  xg = {xg}
end
nseg = length(ng);
%n and x in the correct vertical orientation
for seg = 1:nseg
    ng{seg} = ng{seg}(:);
    xg{seg} = xg{seg}(:);
end

%-------------------------------------------------------------
%Standard fit-settings plus user-settings
%-------------------------------------------------------------
s.mean_adj = 1;
s.pengic = 6;
s.do_extended = 1;

dsset = 0;
mstart = 0;
if ~isempty(varargin),
   if iscell(varargin{1})
      set_ar_start = varargin{1};
      mstart = 1;
      if length(varargin)-1,
         dsset = 1;
      end
   else
      dsset = 1;
   end
   if dsset,
      s = setfields(s,varargin{mstart+1:end}); %Add user-settings
   end   
end

%Check shape of order setting.
switch length(L)
case 1
   Lmin = 0;
   Lmax = L;
case 2
   Lmin = L(1);
   Lmax = L(2);
otherwise
   error('Order should be [Lmin Lmax] or Lmax')
end
nk = Lmax-Lmin+1;

%-------------------------------------------------------------
%Estimation
%-------------------------------------------------------------
tic
if s.mean_adj
    for seg = 1:nseg
        xg{seg} = xg{seg}-mean(xg{seg});
    end
end
%Determination of maximum lags in fit criterion
n_obs = 0; %Number of obeservations present
tm = 0;    %Total measurement time
for seg = 1:nseg
   n_obs = n_obs+length(ng{seg});
   tm = tm + ng{seg}(end)-ng{seg}(1)+1;
end
pm = (tm-n_obs)/tm
lag_max = ceil(2*(Lmin:Lmax)/(1-pm)) %see Thesis, p. 154

%parameter estimation
if ~mstart
    [set_ar, varxh, klifit] = ARShat_misd(ng,xg,[Lmin Lmax],lag_max);
else
    [set_ar, varxh, klifit] = ARShat_misd(ng,xg,[Lmin Lmax],lag_max,set_ar_start);    
end

%Order selection
gic = klifit+s.pengic*(Lmin:Lmax)';
[gicm ipselgic] = min(gic);
ar = set_ar{ipselgic};

%Set sellog
sellog = s;
sellog.funct_name = 'sig2ar_misd';
sellog.comp_time = toc;
sellog.set_ar= set_ar;
sellog.klifit = klifit;
sellog.ar = ar;
sellog.psel = length(ar)-1;
sellog.Lmin = Lmin;
sellog.Lmax = Lmax;
sellog.gic = gic;