function [p] = kernelpdf(x, xi, bw, wi)

n = length(xi);
if nargin < 4 || isempty(wi)
   wi = ones(n, 1) / n;
end

if nargin < 3; bw = kernelbw(xi); end

p = zeros(size(x));
for i = 1:n
    p = p + wi(i) * normpdf(x, xi(i), bw);
end

end