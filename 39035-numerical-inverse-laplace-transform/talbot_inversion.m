function ilt = talbot_inversion(f_s, t, M)

% ilt = talbot_inversion(f_s, t, [M])
%
% Returns an approximation to the inverse Laplace transform of function
% handle f_s evaluated at each value in t (1xn) using Talbot's method as
% summarized in the source below.
% 
% This implementation is very coarse; use talbot_inversion_sym for better
% precision. Further, please see example_inversions.m for discussion.
%
% f_s: Handle to function of s
% t:   Times at which to evaluate the inverse Laplace transformation of f_s
% M:   Optional, number of terms to sum for each t (64 is a good guess);
%      highly oscillatory functions require higher M, but this can grow
%      unstable; see test_talbot.m for an example of stability.
% 
% Abate, Joseph, and Ward Whitt. "A Unified Framework for Numerically 
% Inverting Laplace Transforms." INFORMS Journal of Computing, vol. 18.4 
% (2006): 408-421. Print.
% 
% The paper is also online: http://www.columbia.edu/~ww2040/allpapers.html.
% 
% Tucker McClure
% Copyright 2012, The MathWorks, Inc.

    % Make sure t is n-by-1.
    if size(t, 1) == 1
        t = t';
    elseif size(t, 2) > 1
        error('Input times, t, must be a vector.');
    end

    % Set M to 64 if user didn't specify an M.
    if nargin < 3
        M = 64;
    end
    
    % Vectorized Talbot's algorithm
    
    k = 1:(M-1); % Iteration index
    
    % Calculate delta for every index.
    delta = zeros(1, M);
    delta(1) = 2*M/5;
    delta(2:end) = 2*pi/5 * k .* (cot(pi/M*k)+1i);
    
    % Calculate gamma for every index.
    gamma = zeros(1, M);
    gamma(1) = 0.5*exp(delta(1));
    gamma(2:end) =    (1 + 1i*pi/M*k.*(1+cot(pi/M*k).^2)-1i*cot(pi/M*k))...
                   .* exp(delta(2:end));
    
    % Make a mesh so we can do this entire calculation across all k for all
    % given times without a single loop (it's faster this way).
    [delta_mesh, t_mesh] = meshgrid(delta, t);
    gamma_mesh = meshgrid(gamma, t);
    
    % Finally, calculate the inverse Laplace transform for each given time.
    ilt = 0.4./t .* sum(real(   gamma_mesh ...
                             .* arrayfun(f_s, delta_mesh./t_mesh)), 2);

end