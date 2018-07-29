function g = ginicoeff(p, w)

% The function computes the Gini Coefficient for populations p associated
% to wealth levels w, i.e. p(i, j) people have a total wealth of w(i, j).
% The function operates on the columns of p and w.
% p and w must be 2D matrices: only positive values are allowed for p, only
% non-negative values are allowed for w (with at least one element i such
% that w(i, j) > 0, for all j).
% The Gini Coefficient is a measure of inequality, i.e. a measure of wealth
% concentration.
%
% http://en.wikipedia.org/wiki/Lorenz_curve
% http://en.wikipedia.org/wiki/Gini_coefficient
% http://en.wikipedia.org/wiki/Theil_index
% http://en.wikipedia.org/wiki/Atkinson_index
%
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
%
% % Example 1: Uniform U(0, 1)
% N = 1000;                                           % Number of populations
% p = rand(N, 1); w = rand(N, 1);                     % Population and Wealth extracted from a Uniform U(0, 1)
% g = ginicoeff(p, w)
% g =
% 
%     0.476192486513232
%
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
%
% % Example 2: Standard Normal(4, 1)
% N = 1000;                                           % Number of populations
% p = rand(N, 1);                                     % Population extracted from a Uniform U(0, 1)
% mu = 4;
% w = mu + randn(N, 1);                               % Wealth extracted from a Normal N(mu, 1)
% w = abs(w);                                         % Be careful: all values must be strictly positive!!!
% g = ginicoeff(p, w)
% g =
% 
%     0.383791430802560
%
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
%
% % Example 3: LogNormal logN(0, 1)
% N = 1000;                                           % Number of populations
% p = rand(N, 1);                                     % Population extracted from a Uniform U(0, 1)
% w = exp(randn(N, 1));                               % Wealth extracted from a LogNormal logN(0, 1)
% g = ginicoeff(p, w)
% g =
% 
%     0.610656424432874
%
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
%
% % Example 4: Power Law PL(kappaPL, alphaPL)
% N = 1000;                                           % Number of populations
% p = rand(N, 1);                                     % Population extracted from a Uniform U(0, 1)
% kappaPL = 1;
% alphaPL = 2;
% w = kappaPL * (rand(N, 1) .^ (-1/alphaPL));         % Wealth extracted from a Power Law PL(kappaPL, alphaPL)
% g = ginicoeff(p, w)
% g =
% 
%     0.481396918139056
%
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
%
% % Example 5: Mixture of LogNormal logN(0, 1) and Power Law PL(kappaPL, alphaPL)
% N = 1000;                                           % Number of populations
% p = rand(N, 1);                                     % Population extracted from a Uniform U(0, 1)
% alpha = floor(0.92 * N);                            % Number of populations whose wealth is extracted from a LogNormal logN(0, 1)
% w = exp(randn(alpha, 1));                           % Wealth extracted from a LogNormal logN(0, 1)
% kappaPL = 1;
% alphaPL = 2;
% w((alpha + 1):N) = kappaPL * (rand(N - alpha, 1) .^ (-1/alphaPL));   % Wealth extracted from a Power Law PL(kappaPL, alphaPL)
% g = ginicoeff(p, w)
% g =
% 
%     0.623694428395574
%
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
%
% Written by
% Francesco Pozzi
% 19 May 2008
%

ctrl = isnumeric(p) & isreal(p) & isnumeric(w) & isreal(w);
ctrl = ctrl & all(p(:) > 0) & all(w(:) >= 0) & all(any(w > 0));
[n, k] = size(p);
ctrl = ctrl & all([n, k] == size(w)) & (n ~= 1);
if ~ctrl
  error('Values for either Population or Wealth or both are incorrect!')
end

% Normalize total population and total wealth to 1.
p = p ./ repmat(sum(p), n, 1);
w = w ./ repmat(sum(w), n, 1);
% Keep the smallest population, needed to normalize the Gini coefficient
minpop = min(p);

% Store in a single array
pw = p; pw(:, :, 2) = w; pw(:, :, 3) = w ./ p;
% Sort with respect to Wealth Per Capita
for h = 1:k
  pw(:, h, :) = sortrows(squeeze(pw(:, h, :)), 3);
end
pw(:, :, 3) = [];
pw = [zeros(1, k, 2); pw];
% Cumulative p & w
pw = cumsum(pw);

% Average bases and height for right trapezoids
height = diff(pw(:, :, 1));
base = (pw(1:(end - 1), :, 2) + pw(2:end, :, 2)) / 2;

% The Gini Coefficient is normalized with respect to its highest possible
% value which is obtained if the smallest population owns all the existing
% wealth.
g = (1 - 2 * sum(height .* base)) ./ (1 - minpop);
