function [tg,xg,nobsg] = irr2grid(ti,xi,T);

%IRR2GRID Conversion of irregularly sampled data to missing data
%   [tg,xg,nobsg] = irr2grid(ti,xi,T) convert a set of irregularly sampled
%   data (ti,xi) to missing data (tg,xg) by rounding measurement times to
%   the nearest grid point k*T, k=1,2,3,...
%
%   See also MISSING2SEG.

%S. de Waele, March 2003.

ti = ti-ti(1);
ti = ti(:)';
xi = xi(:)';

tr = round(ti/T);
i_changed = find(diff(tr));
tg = [tr(1) tr(i_changed+1)];
nobsg = length(tg);
ti_x = [ti ti(end)+T]; %Extend observations for last gridpoint
xi_x = [xi xi(end)];
xg = interp1(ti_x,xi_x,tg*T,'nearest');