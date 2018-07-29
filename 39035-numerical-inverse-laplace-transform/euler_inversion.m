function ilt = euler_inversion(f_s, t, M)

% ilt = euler_inversion(f_s, t, [M])
%
% Returns an approximation to the inverse Laplace transform of function
% handle f_s evaluated at each value in t (1xn) using the Euler method as
% summarized in the source below.
% 
% This implementation is very coarse; use euler_inversion_sym for better
% precision. Further, please see example_inversions.m for examples.
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
        M = 32;
    end
    
    % Vectorized Talbot's algorithm
    bnml = @(n, z) prod((n-(z-(1:z)))./(1:z));
    
    xi = [0.5, ones(1, M), zeros(1, M-1), 2^-M];
    for k = 1:M-1
        xi(2*M-k + 1) = xi(2*M-k + 2) + 2^-M * bnml(M, k);
    end
    k = 0:2*M; % Iteration index
    beta = M*log(10)/3 + 1i*pi*k;
    eta  = (1-mod(k, 2)*2) .* xi;
    
    % Make a mesh so we can do this entire calculation across all k for all
    % given times without a single loop (it's faster this way).
    [beta_mesh, t_mesh] = meshgrid(beta, t);
    eta_mesh = meshgrid(eta, t);
    
    % Finally, calculate the inverse Laplace transform for each given time.
    ilt =    10^(M/3)./t ...
          .* sum(eta_mesh .* real(arrayfun(f_s, beta_mesh./t_mesh)), 2);

end
