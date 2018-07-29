function [x] = kernelinv(p, xi, bw, wi)

if nargin < 4 || isempty(wi); wi = []; end
if nargin < 3 || isempty(bw); bw = kernelbw(xi); end

options = optimset('fzero');
options.Display = 'off';
sortp = sort(p);

if length(p) < 10
    % case with only few points by treating each point seperately
    x = zeros(size(p));
    for i = 1:length(p)
        x(i) = fzero(@(x) private_fun(x, xi, bw, wi, p(1)), 0, options);
    end
else
    % case with many points by interpolation, find x_min and x_max
    x_min = fzero(@(x) private_fun(x, xi, bw, wi, sortp(1)), 0, options);
    x_max = fzero(@(x) private_fun(x, xi, bw, wi, sortp(end)), 0, options);

    % mesh for x values
    x_ = linspace(x_min - 0.1 * abs(x_min), x_max + 0.1 * abs(x_max), 500);
    
    % evaluates the mesh on these values
    y_ = kernelcdf(x_, xi, bw, wi);
    
    % interpolation
    x = interp1q(y_', x_', p');
end

end

function [f] = private_fun(x, xi, bw, wi, p)

f = kernelcdf(x, xi, bw, wi) - p;

end
