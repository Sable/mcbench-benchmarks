function y = nigcdfSmall(x, alpha, beta, mu, delta)
%NIGCDFSMALL Normal-Inverse-Gaussian cumulative distribution function (cdf).
%
%   This version is called by nigcdf and should not be used on its own.
%   This version is optimized for small vectors x (numel(x) < 100).

% -------------------------------------------------------------------------
% 
% Allianz, Group Risk Controlling
% Risk Methodology
% Koeniginstr. 28
% D-80802 Muenchen
% Germany
% Internet:    www.allianz.de
% email:       ralf.werner@allianz.de
% 
% Implementation Date:  2006 - 05 - 01
% Author:               Dr. Ralf Werner
%
% -------------------------------------------------------------------------

% define accuracy of procedure
eps = 1.0e-008;

%% numerical integration of the NIG density
% uses logarithmic transformation
function z = helpfunction(u)
    z = zeros(size(u));
    iPos = (u > 0);
    v = u(iPos);
    z(iPos) = nigpdf(log(v), alpha, beta, mu, delta) ./ v;
end    

% abbreviation for NIG density
function z = nigdens(u)
     z = nigpdf(u, alpha, beta, mu, delta);
end

y = zeros(size(x));

% sort values ascending
[sortx, isortx] = sort(x(:));

y(isortx(1)) = quadl(@helpfunction, 0, exp(sortx(1)), eps);

% successive integration of NIG density
for k = 2:numel(x);
    
    y(isortx(k)) = quadl(@nigdens, sortx(k-1), sortx(k), eps) + y(isortx(k-1));

end

end
