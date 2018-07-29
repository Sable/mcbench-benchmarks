function [yOut] = cadzow(y, target_rank, iterations)
%
% Remove noise using the Cadzow composite property mapping method.
% See both Cadzow's paper and de Beer's online summary.
%
% Obligatory arguments:
% 'y' is the signal to clean.
% 'target_rank' is an estimate of the model order (number of exponentials).
% 'iterations' is the number of iterations to do. Set to 'inf' to
%  run to convergence. 3 or 4 iterations remove most noise but
%  running to convergence makes the decomposition methods
%  work wonderfully - it takes a *long* time to do though.
%
% Outputs:
% 'frequencies' - frequencies of components in signal
% 'dampings' - damping of components in signal
% 'basis' - basis vectors, one for each component
% 'ahat' - amplitudes of each basis in signal
%
% Author: Greg Reynolds (remove.this.gmr001@bham.ac.uk)
% Date: June 2005

N = length(y);
L = floor(0.5*N);
%L = target_rank+1;

% T is the prediction matrix before filtering.
T = conj(hankel(y(1:N-L),y(N-L:N).'));

Tr = T;

% reduce the rank or stop after desired number of iterations
for iter = 1:1:iterations 

    % decompose T
    [U, S, V] = svd(Tr);
%    [U, S, V] = svds(Tr, target_rank+1);
   
    % check current rank
    s = diag(S);        
    tol = max(size(Tr)') * eps(max(s));
    r = sum(s > tol);

    fprintf('\nCadzow iteration %d (rank is %d, target is %d).', iter, r, target_rank);
        
    if r <= target_rank
        break
    elseif r > target_rank  
        threshold = S(target_rank, target_rank);
        S(S < threshold) = 0;
        Tr = U*S*V';
    
        % average to restore Hankel structure
        Tr = avgHankel(Tr);
    end    
end

% need to extract data from matrix Tr
yOut = conj([Tr(:,1); Tr(size(Tr,1),2:size(Tr,2)).']);
