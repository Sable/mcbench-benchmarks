function y = atkinsonineq(w, epsilon)

% The function computes the Atkinson Inequality Index for the wealth w
% associated to single individuals. The function operates on columns of w.
% w must be non-negative (with at least one i such that w(i, j) > 0, for
% all j). epsilon must be non-negative.
%
% The Atkinson Inequality Index is a measure of inequality, i.e. a measure
% of wealth concentration.
%
% Original paper from Atkinson
% Anthony B. Atkinson, On the measurement of economic inequality. Journal
% of Economic Theory, Vol. 2, Issue 3, pp. 244–263, 1970
% (http://dx.doi.org/10.1016/0022-0531(70)90039-6)
%
% On Wikipedia:
% http://en.wikipedia.org/wiki/Atkinson_index
% http://en.wikipedia.org/wiki/Theil_index
% http://en.wikipedia.org/wiki/Lorenz_curve
% http://en.wikipedia.org/wiki/Gini_coefficient
%
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
%
% % Example 1: Uniform U(0, 1)
% N = 1000;                                           % Number of individuals
% k = 1000;                                           % Number of cases
% w = rand(N, 1);                                     % Wealth extracted from a Uniform U(0, 1)
% epsilon = 4 * rand(k, 1);
% y = atkinsonineq(repmat(w, 1, k), epsilon);
% plot(epsilon, y, '.')
%
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
%
% % Example 2: Standard Normal z(0, 1)
% N = 1000;                                           % Number of individuals
% k = 1000;                                           % Number of cases
% mu = 4;
% w = mu + randn(N, 1);                               % Wealth extracted from a Normal N(mu, 1)
% w = abs(w);                                         % Be careful: all values must be strictly positive!!!
% epsilon = 50 * rand(k, 1);
% y = atkinsonineq(repmat(w, 1, k), epsilon);
% plot(epsilon, y, '.')
%
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
%
% % Example 3: LogNormal logN(0, 1)
% N = 1000;                                           % Number of individuals
% k = 1000;                                           % Number of cases
% w = exp(randn(N, 1));                               % Wealth extracted from a LogNormal logN(0, 1)
% epsilon = 10 * rand(k, 1);
% y = atkinsonineq(repmat(w, 1, k), epsilon);
% plot(epsilon, y, '.')
%
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
%
% % Example 4: Power Law PL(kappaPL, alphaPL)
% N = 1000;                                           % Number of individuals
% k = 1000;                                           % Number of cases
% kappaPL = 1;
% alphaPL = 2;
% w = kappaPL * (rand(N, 1) .^ (-1/alphaPL));         % Wealth extracted from a Power Law PL(kappaPL, alphaPL)
% epsilon = 20 * rand(k, 1);
% y = atkinsonineq(repmat(w, 1, k), epsilon);
% plot(epsilon, y, '.')
%
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
%
% % Example 5: Mixture of LogNormal logN(0, 1) and Power Law PL(kappaPL, alphaPL)
% N = 1000;                                           % Number of individuals
% k = 1000;                                           % Number of cases
% alpha = floor(0.92 * N);                            % Number of individuals whose wealth is extracted from a LogNormal LogN(0, 1)
% w = exp(randn(alpha, 1));                           % Wealth extracted from a LogNormal LogN(0, 1)
% kappaPL = 1;
% alphaPL = 2;
% w((alpha + 1):N) = kappaPL * (rand(N - alpha, 1) .^ (-1/alphaPL));   % Wealth extracted from a Power Law PL(kappaPL, alphaPL)
% epsilon = 10 * rand(k, 1);
% y = atkinsonineq(repmat(w, 1, k), epsilon);
% plot(epsilon, y, '.')
%
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
%
% Written by
% Francesco Pozzi
% 19 May 2008
%

ctrl = isnumeric(w) & isreal(w) & isnumeric(epsilon) & isvector(epsilon) & isreal(epsilon);
ctrl = ctrl & all(w(:) >= 0) & all(any(w > 0)) & all(epsilon >= 0);
if ~ctrl
  error('Values for either Epsilon or Wealth, or both, are incorrect!')
end

mu = mean(w);
N = size(w, 1);
k = size(w, 2);
ctrl = (k == length(epsilon));
if ~ctrl
  error('Values for either Epsilon or Wealth, or both, are incorrect!')
end

inds = find(epsilon ~= 1);
if ~isempty(inds)
  y(inds) = 1 - ((sum(w(:, inds) .^ (1 - repmat(epsilon(inds)', N, 1))) / N) .^ (1 ./ (1 - epsilon(inds)'))) ./ mu(inds);
end
inds = find(epsilon == 1);
if ~isempty(inds)
  y(inds) = 1 - (prod(w(:, inds) .^ (1 / N))) ./ mu(inds);
end
