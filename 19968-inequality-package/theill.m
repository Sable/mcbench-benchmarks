function y = theill(w)

% The function computes the Theil-L Inequality Index for wealth w
% associated to single individuals. The function operates on the columns of
% w.
% w must be 2D matrices: only non-negative values are allowed (with at
% least one i such that w(i, j) > 0, for all j).
%
% The Theil Inequality Index is a measure of inequality, i.e. a measure of
% wealth concentration.
%
% http://en.wikipedia.org/wiki/Theil_index
% http://en.wikipedia.org/wiki/Atkinson_index
% http://en.wikipedia.org/wiki/Lorenz_curve
% http://en.wikipedia.org/wiki/Gini_coefficient
%
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
%
% % Example 1: Uniform U(0, 1)
% N = 1000;                                           % Number of individuals
% w = rand(N, 1);                                     % Wealth extracted from a Uniform U(0, 1)
% y = theill(w)
% y =
% 
%     0.3069
%
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
%
% % Example 2: Standard Normal z(0, 1)
% N = 1000;                                           % Number of individuals
% mu = 4;
% w = mu + randn(N, 1);                               % Wealth extracted from a Normal N(mu, 1)
% w = abs(w);                                         % Be careful: all values must be strictly positive!!!
% y = theill(w)
% y =
% 
%     0.0352
%
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
%
% % Example 3: LogNormal logN(0, 1)
% N = 1000;                                           % Number of individuals
% w = exp(randn(N, 1));                               % Wealth extracted from a LogNormal logN(0, 1)
% y = theill(w)
% y =
% 
%     0.4989
%
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
%
% % Example 4: Power Law PL(kappaPL, alphaPL)
% N = 1000;                                           % Number of individuals
% kappaPL = 1;
% alphaPL = 2;
% w = kappaPL * (rand(N, 1) .^ (-1/alphaPL));         % Wealth extracted from a Power Law PL(kappaPL, alphaPL)
% y = theill(w)
% y =
% 
%     0.1914
%
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
%
% % Example 5: Mixture of LogNormal logN(0, 1) and Power Law PL(kappaPL, alphaPL)
% N = 1000;                                           % Number of individuals
% alpha = floor(0.92 * N);                            % Number of individuals whose wealth is extracted from a LogNormal LogN(0, 1)
% w = exp(randn(alpha, 1));                           % Wealth extracted from a LogNormal LogN(0, 1)
% kappaPL = 1;
% alphaPL = 2;
% w((alpha + 1):N) = kappaPL * (rand(N - alpha, 1) .^ (-1/alphaPL));   % Wealth extracted from a Power Law PL(kappaPL, alphaPL)
% y = theill(w)
% y =
%
%     0.4760
%
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
%
% Written by
% Francesco Pozzi
% 19 May 2008
%

ctrl = isnumeric(w) & isreal(w);
ctrl = ctrl & all(w(:) >= 0) & all(any(w > 0)) & (size(w, 1) ~= 1);
if ~ctrl
  error('Values for wealth are incorrect!')
end

y = repmat(mean(w), size(w, 1), 1) ./ w;
y = sum(log(y))/ size(y, 1);
