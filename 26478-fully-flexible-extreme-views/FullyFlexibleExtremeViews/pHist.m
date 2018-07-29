function [h, f] = pHist(X, p, nBins)

if nargin < 3;
    J = size(X, 1);
    nBins = round(10 * log(J));
end

[n, x] = hist(X, nBins);
D = x(2) - x(1);

N = length(x);
np = zeros(N, 1);
for s = 1:N
    idx = (X >= x(s) - D/2) & (X <= x(s) + D/2); 
    np(s) = sum(p(idx));
    f = np / D;
end

h = [];
if nargout < 2
    bar(x, f, 1);   
    h = findobj(gca, 'Type', 'patch');
    set(h, 'FaceColor', 0.6 * [1, 1, 1], 'EdgeColor', 0.6 * [1, 1, 1]);
    grid on;
end

end