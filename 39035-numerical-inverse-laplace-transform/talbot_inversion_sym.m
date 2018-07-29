function ilt = talbot_inversion_sym(f_s, t, M, P)

% ilt = talbot_inversion_sym(f_s, t, [M], [P])
%
% Returns an approximation to the inverse Laplace transform of function
% handle f_s evaluated at each value in t (1xn) using Talbot's method as
% summarized in the source below. This is a symbolic implementation capable
% of much greater accuracy than talbot_inversion. For this reason, it takes
% an additional argument, P, the number of significant digits required by
% the calculation. In general, P should be about 0.6*M.
%
% f_s: Handle to function of s
% t:   Times at which to evaluate the inverse Laplace transformation of f_s
% M:   Optional number of terms to sum for each t (64 is a good guess);
%      highly oscillatory functions require higher M, but this can grow
%      unstable; see example_inversions.m for an example of stability [64]
% P:   Optional precision of calculation in significant digits [32]
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
    if nargin < 3, M = 64; end
    
    % Set P to the greater of the default from digits() or 0.6M.
    if nargin < 4, P = max(floor(0.6*M), digits()); end
    
    % Vectorized Talbot's algorithm
    
    M = sym(M);
    
    k = 1:(M-1); % Iteration index
    
    % Calculate delta for every index.
    delta = vpa([2*M/5, 2*pi/5 * k .* (cot(pi/M*k)+1i)], P);
    
    % Calculate gamma for every index.
    gamma = vpa([0.5*exp(delta(1)), ...
                    (1 + 1i*pi/M*k .* (1+cot(pi/M*k).^2) - 1i*cot(pi/M*k)) ...
                 .* exp(delta(2:end))], P);
    
    % Make a mesh so we can do this entire calculation across all k for all
    % given times without a single loop (it's faster this way).
    [delta_mesh, t_mesh] = meshgrid(delta, t);
    gamma_mesh = meshgrid(gamma, t);
    
    % Finally, calculate the inverse Laplace transform for each given time.
    f_s_evals = arrayfun(f_s, delta_mesh./t_mesh, 'UniformOutput', false);
    f_s_evals = vpa(reshape([f_s_evals{:}], size(delta_mesh)), P);
    ilt = vpa(0.4./t .* sum(real(gamma_mesh .* f_s_evals), 2), P);

end