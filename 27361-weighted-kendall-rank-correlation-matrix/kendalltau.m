function tau = kendalltau(Y, w)

%   TAU = KENDALLTAU(Y) returns an N-by-N matrix containing the
%   pairwise Kendall rank correlation coefficient between each pair
%   of columns in the T-by-N matrix Y. The coefficients are adjusted
%   for ties (it's the so called "tau-b"). Kendall's tau-b is
%   identical to the standard tau (or tau-a) when there are no ties.
%
%   TAU = KENDALLTAU(Y, w) returns the Weighted Kendall Rank
%   Correlation Matrix, where w is a [T * (T - 1) / 2]-by-1 vector of
%   weights for all combinations of comparisons between observations
%   i and j.
%
%   Reference: F. Pozzi, T. Di Matteo, T. Aste,
%   "Exponential smoothing weighted correlations",
%   The European Physical Journal B, Volume 85, Issue 6, 2012.
%   DOI: 10.1140/epjb/e2012-20697-x
%
%   This algorithm, potentially MUCH MUCH faster than Matlab CORR
%   function (seconds vs hours), has been thought for small datasets:
%   a contiguous block of your machine's virtual memory is needed, in
%   order to store a matrix of dimensions
%                       [T * (T - 1) / 2]-by-N
%
%   The basic idea is that Kendall tau is nothing else or more than a
%   linear correlation of all pairwise signs between variables.
%
%   Notice that no NaN or Inf value is allowed in Y: please clean
%   your data before using KENDALLTAU; also, this function doesn't
%   calculate p-values (but the implementation should be relatively
%   simple).
%
% % =====================================================================
% % EXAMPLE1: How to use this function (on my very limited laptop)
% % =====================================================================
%
%         N = 300;
%         T = 100;
%         Y = randint(T, N, [0, 100]);              % Lots of ties
%         tic, tau1 = kendalltau(Y); toc            % Try this function
%
%         % --->                                   <---
%         % ---> Elapsed time is 0.577000 seconds. <---
%         % --->                                   <---
%
%         tic, tau2 = corr(Y, 'Type', 'kendall'); toc   % Try CORR instead
%
%         % --->                                     <---
%         % ---> Elapsed time is 132.241000 seconds. <---
%         % --->                                     <---
%
%         plot(tau1(:) - tau2(:), '.')
%         set(gca, 'YLim', [-1e-12, 1e-12]);    % exactly same results
%
% % =====================================================================
% % EXAMPLE2: How to use this function (on a decent computer, fast
%             and with a big memory available).
% % =====================================================================
%
%         N = 1000;                         % 10/3 times bigger than before
%         T = 1000;                         % 10 times bigger than before
%         Y = randint(T, N, [0, 100]);              % Lots of ties
%         tic, tau1 = kendalltau(Y); toc            % Try this function
%
%         % --->                                    <---
%         % ---> Elapsed time is 48.826421 seconds. <---
%         % --->                                    <---
%
%         tic, tau2 = corr(Y, 'Type', 'kendall'); toc   % Try CORR instead
%
%         % --->                                       <---
%         % ---> Elapsed time is 13398.811714 seconds. <---
%         % --->                                       <---
%
%         temp = tau1(:) - tau2(:);
%         temp = hist(temp);
%         temp                                      % exactly same results
%         % 0 0 0 0 0 1000000 0 0 0 0
%
% % =====================================================================
% % EXAMPLE3: Weighted Kendall Rank Correlation Matrix
% % =====================================================================
%
%         N = 100;                                 % Number of variables
%         T = 200;                                 % Number of observations
%         Y = randint(T, N, [0, 100]);             % Lots of ties
%
%         % Weights with exponential smoothing
%         alpha = 3 / T;
%         w0 = ((exp(alpha) + 1) * (exp(alpha) - 1) ^ 2) / exp(2 * alpha) / (1 - exp(-alpha * T)) / (1 - exp(-alpha * (T - 1)));
%         % Prepare indexes for all combinations without repetition
%         [i1, i2] = find(tril(ones(T, 'uint8'), -1));
%         w = w0 * exp(alpha * (i1 + i2 - 2 * T));
%
%         tic, tau1 = kendalltau(Y, w); toc
%         tic, tau2 = kendalltau(Y); toc
%
%         plot(tau2(:), tau1(:), '.')           % Compare Weighted vs
%                                               % non-Weighted Kendall Rank
%                                               % Correlation Matrices
%
% % =====================================================================
%
%   See also CORRCOEF, CORR.
%
% % =====================================================================
%
%   Author: Francesco Pozzi
%   E-mail: francesco.pozzi@anu.edu.au
%   Date: 25 April 2010
%   Update: 6 June 2012
%
% % =====================================================================
%

% Check input
ctrl1 = isnumeric(Y) & isreal(Y);
if ctrl1
  ctrl2 = ~any(isnan(Y(:))) & ~any(isinf(Y(:)));
  if ~ctrl2
  error('Check Y: no infinite or nan values are allowed!')
  end
else
  error('Check Y: it needs be a matrix of real numbers!')
end

[T, N] = size(Y);
if N < 2 || T < 2
  error('You need at least two variables and two observations');
end

memoryinuse = round(N * T * (T - 1) / 2 * 8 / (1024^2));
if memoryinuse > 500
  warning(sprintf('Beware: you are going to need a contiguous block of your machine''s virtual memory\nof more than %d MB. On some machines this might result in an ''Out of Memory'' error. Hope you\nknow what you are doing. Good luck.', memoryinuse));
end

if nargin == 2
  ctrl1 = isvector(w) & isreal(w);
  if ctrl1
    ctrl2 = ~any(isnan(w(:))) & ~any(isinf(w(:))) & all(w > 0);
    if ctrl2
      if length(w) == T * (T - 1) / 2
        w = w(:) / sum(w);            % w is column vector
        ctrl = 0;
      else
        error(sprintf('Check w: if T is the number of observations, then length(w)\nneeds necessarily be equal to T * (T - 1) / 2.'))
      end
    else
      error('Check w: no infinite or nan values are allowed!')
    end
  else
    error('Check w: it needs be a vector of real positive numbers!')
  end
else
  ctrl = 1;
end

% Prepare indexes for all combinations without repetition
[i1, i2] = find(tril(ones(T, 'uint8'), -1));

% Now, this is just a linear correlation using the signs of
% [T * (T - 1) / 2] differences
tau = sign(Y(i2, :) - Y(i1, :));
if ctrl || all(diff(w) == 0);
  tau = tau' * tau;
  temp = diag(tau);
  tau = tau ./ sqrt(temp * temp');
else
  tau = tau' * (tau .* repmat(w, 1, N));
  tau = 0.5 * (tau + tau');        % Must be exactly symmetric
  temp = diag(tau);
  tau = tau ./ sqrt(temp * temp');
end
