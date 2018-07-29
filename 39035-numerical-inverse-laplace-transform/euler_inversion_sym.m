function ilt = euler_inversion_sym(f_s, t, M, P)

% ilt = euler_inversion_sym(f_s, t, [M], [P])
%
% Returns an approximation to the inverse Laplace transform of function
% handle f_s evaluated at each value in t (1xn) using the Euler method as
% summarized in the source below. This is a symbolic implementation capable
% of much greater accuracy than euler_inversion. For this reason, it takes
% an additional argument, P, the number of significant digits required by
% the calculation. In general, P should be about 0.6*M.
%
% f_s: Handle to function of s
% t:   Times at which to evaluate the inverse Laplace transformation of f_s
% M:   Optional number of terms to sum for each t (64 is a good guess);
%      highly oscillatory functions require higher M, but this can grow
%      unstable; see example_inversions.m for an example of stability [64]
% P:   Optional precision of calculation in significant digits [default 32]
% 
% Requires the Symbolic Toolbox(TM).
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
    if nargin < 3, M = 32; end
    
    % Set P to the greater of the default from digits() or 0.6M.
    if nargin < 4, P = max(floor(0.6*M), digits()); end
    
    % Vectorized Talbot's algorithm
    
    % Binominal function
    bnml = @(n, z) factorial(n)/(factorial(z)*factorial(n-z));
    
    xi = sym([0.5, ones(1, M), zeros(1, M-1), 2^-sym(M)]);
    for k = 1:M-1
        xi(2*M-k + 1) = xi(2*M-k + 2) + 2^-sym(M) * bnml(sym(M), sym(k));
    end
    k = sym(0:2*M); % Iteration index
    beta = vpa(sym(M)*log(sym(10))/3 + 1i*pi*k, P);
    eta  = vpa((1-mod(k, 2)*2) .* xi, P);
    
    % Make a mesh so we can do this entire calculation across all k for all
    % given times without a single loop (it's faster this way).
    [beta_mesh, t_mesh] = meshgrid(beta, sym(t));
    eta_mesh = meshgrid(eta, t);
    
    % Finally, calculate the inverse Laplace transform for each given time.
    f_s_evals = arrayfun(f_s, beta_mesh./t_mesh, 'UniformOutput', false);
    f_s_evals = vpa(reshape([f_s_evals{:}], size(beta_mesh)), P);
    ilt = vpa(10^(sym(M)/3)./sym(t).*sum(eta_mesh.*real(f_s_evals), 2), P);

end
