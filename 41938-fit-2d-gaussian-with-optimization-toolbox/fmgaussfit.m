function [fitresult, zfit, fiterr, zerr, resnorm, rr] = fmgaussfit(xx,yy,zz)
% FMGAUSSFIT Create/alter optimization OPTIONS structure.
%   [fitresult,..., rr] = fmgaussfit(xx,yy,zz) uses ZZ for the surface 
%   height. XX and YY are vectors or matrices defining the x and y 
%   components of a surface. If XX and YY are vectors, length(XX) = n and 
%   length(YY) = m, where [m,n] = size(Z). In this case, the vertices of the
%   surface faces are (XX(j), YY(i), ZZ(i,j)) triples. To create XX and YY 
%   matrices for arbitrary domains, use the meshgrid function. FMGAUSSFIT
%   uses the lsqcurvefit tool, and the OPTIMZATION TOOLBOX. The initial
%   guess for the gaussian is places at the maxima in the ZZ plane. The fit
%   is restricted to be in the span of XX and YY.
%   See:
%       http://en.wikipedia.org/wiki/Gaussian_function
%          
%   Examples:
%     To fit a 2D gaussian:
%       [fitresult, zfit, fiterr, zerr, resnorm, rr] =
%       fmgaussfit(xx,yy,zz);
%   See also SURF, OMPTMSET, LSQCURVEFIT, NLPARCI, NLPREDCI.

%   Copyright 2013, Nathan Orloff.

%% Condition the data
[xData, yData, zData] = prepareSurfaceData( xx, yy, zz );
xyData = {xData,yData};

%% Set up the startpoint
[amp, ind] = max(zData); % amp is the amplitude.
xo = xData(ind); % guess that it is at the maximum
yo = yData(ind); % guess that it is at the maximum
ang = 45; % angle in degrees.
sy = 1;
sx = 1;
zo = median(zData(:))-std(zData(:));
xmax = max(xData)+2;
ymax = max(yData)+2;
xmin = min(xData)-2;
ymin = min(yData)-2;

%% Set up fittype and options.
Lower = [0, 0, 0, 0, xmin, ymin, 0];
Upper = [Inf, 180, Inf, Inf, xmax, ymax, Inf]; % angles greater than 90 are redundant
StartPoint = [amp, ang, sx, sy, xo, yo, zo];%[amp, sx, sxy, sy, xo, yo, zo];

tols = 1e-16;
options = optimset('Algorithm','levenberg-marquardt',...
    'Display','off',...
    'MaxFunEvals',5e2,...
    'MaxIter',5e2,...
    'TolX',tols,...
    'TolFun',tols,...
    'TolCon',tols ,...
    'UseParallel','always');

%% perform the fitting
[fitresult,resnorm,residual] = ...
    lsqcurvefit(@gaussian2D,StartPoint,xyData,zData,Lower,Upper,options);
[fiterr, zfit, zerr] = gaussian2Duncert(fitresult,residual,xyData);
rr = rsquared(zData, zfit, zerr);
zfit = reshape(zfit,size(zz));
zerr = reshape(zerr,size(zz));

end

function rr = rsquared(z,zf,ze)
% reduced chi-squared
dz = z-zf;
rr = 1./(numel(z)-8).*sum(dz.^2./ze.^2); % minus 8 because there are 7 fit parameters +1 (DOF)
end

function z = gaussian2D(par,xy)
% compute 2D gaussian
z = par(7) + ...
    par(1)*exp(-(((xy{1}-par(5)).*cosd(par(2))+(xy{2}-par(6)).*sind(par(2)))./par(3)).^2-...
    ((-(xy{1}-par(5)).*sind(par(2))+(xy{2}-par(6)).*cosd(par(2)))./par(4)).^2);
end

function [dpar,zf,dzf] = gaussian2Duncert(par,resid,xy)
% get the confidence intervals
J = guassian2DJacobian(par,xy);
parci = nlparci(par,resid,'Jacobian',J);
dpar = (diff(parci,[],2)./2)';
[zf,dzf] = nlpredci(@gaussian2D,xy,par,resid,'Jacobian',J);
end

function J = guassian2DJacobian(par,xy)
% compute the jacobian
x = xy{1}; y = xy{2};
J(:,1) = exp(- (cosd(par(2)).*(x - par(5)) + sind(par(2)).*(y - par(6))).^2./par(3).^2 - (cosd(par(2)).*(y - par(6)) - sind(par(2)).*(x - par(5))).^2./par(4).^2);
J(:,2) = -par(1).*exp(- (cosd(par(2)).*(x - par(5)) + sind(par(2)).*(y - par(6))).^2./par(3).^2 - (cosd(par(2)).*(y - par(6)) - sind(par(2)).*(x - par(5))).^2./par(4).^2).*((2.*(cosd(par(2)).*(x - par(5)) + sind(par(2)).*(y - par(6))).*(cosd(par(2)).*(y - par(6)) - sind(par(2)).*(x - par(5))))./par(3).^2 - (2.*(cosd(par(2)).*(x - par(5)) + sind(par(2)).*(y - par(6))).*(cosd(par(2)).*(y - par(6)) - sind(par(2)).*(x - par(5))))./par(4).^2);
J(:,3) = (2.*par(1).*exp(- (cosd(par(2)).*(x - par(5)) + sind(par(2)).*(y - par(6))).^2./par(3).^2 - (cosd(par(2)).*(y - par(6)) - sind(par(2)).*(x - par(5))).^2./par(4).^2).*(cosd(par(2)).*(x - par(5)) + sind(par(2)).*(y - par(6))).^2)./par(3)^3;
J(:,4) = (2.*par(1).*exp(- (cosd(par(2)).*(x - par(5)) + sind(par(2)).*(y - par(6))).^2./par(3).^2 - (cosd(par(2)).*(y - par(6)) - sind(par(2)).*(x - par(5))).^2./par(4).^2).*(cosd(par(2)).*(y - par(6)) - sind(par(2)).*(x - par(5))).^2)./par(4)^3;
J(:,5) = par(1).*exp(- (cosd(par(2)).*(x - par(5)) + sind(par(2)).*(y - par(6))).^2./par(3).^2 - (cosd(par(2)).*(y - par(6)) - sind(par(2)).*(x - par(5))).^2./par(4).^2).*((2.*cosd(par(2)).*(cosd(par(2)).*(x - par(5)) + sind(par(2)).*(y - par(6))))./par(3).^2 - (2.*sind(par(2)).*(cosd(par(2)).*(y - par(6)) - sind(par(2)).*(x - par(5))))./par(4).^2);
J(:,6) = par(1).*exp(- (cosd(par(2)).*(x - par(5)) + sind(par(2)).*(y - par(6))).^2./par(3).^2 - (cosd(par(2)).*(y - par(6)) - sind(par(2)).*(x - par(5))).^2./par(4).^2).*((2.*cosd(par(2)).*(cosd(par(2)).*(y - par(6)) - sind(par(2)).*(x - par(5))))./par(4).^2 + (2.*sind(par(2)).*(cosd(par(2)).*(x - par(5)) + sind(par(2)).*(y - par(6))))./par(3).^2);
J(:,7) = ones(size(x));
end