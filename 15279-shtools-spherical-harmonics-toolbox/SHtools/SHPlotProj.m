function [sp,cb] = SHPlotProj(vec,res,interp)

% [sp,cb] = SHPlotProj(vec,res,shading)
%
% Makes a pcolor projection plot of a vector of spherical
% harmonic coefficients vec. In mapping to grid, uses the
% specified resolution res. To plot, uses shading,
% that can be set to either 'interp' or 'flat'.
% Returns the handles for the subplot and the colorbar

if nargin < 2
    res = 5;
end

[map,lon,lat] = SHMapToGrid(vec,res);

if nargin > 2 && strcmp(interp,'interp')
    sp=subplot(1,1,1); pcolor(lon,lat,map); shading interp; cb=colorbar;
else
    sp=subplot(1,1,1); pcolor(lon,lat,map); shading flat; cb=colorbar;
end