function [g,L] = findLatentGaussian(m,c,acc)

% [g,L] = findLatentGaussian(m,c)
% 	Compute parameters for the hidden Gaussian random vector U generating the
% 	binary Bernulli vector X with mean m and covariances c according to 
%     X = 0 <==> U < -g
%     X = 1 <==> U > -g
%
% Usage: [g,L] = findLatentGaussian([0.4 0.7],[1 0.1; 0.1 1])
%
% Code from the paper: 'Generating spike-trains with specified
% correlations', Macke et al., submitted to Neural Computation
%
% www.kyb.mpg.de/bethgegroup/code/efficientsampling

% parameter check
if any(m < 0 | m >= 1)
    error('mean has to be in (0,1)')
end

if nargin==2
    acc=1e-10;
end

% find mean and variances of the hidden variable via equ. 2.2
n = length(m);
g = norminv(m); 
L = eye(n);

% find covariances by solving 
% Sigma_ij - Psi(gamma_i,gamma_j,Lambda_ij) = 0 (equ. 2.2)
for i = 1:n
    for j = i+1:n
        cMin = -1;
        cMax = 1;
        
        % constant
        pn = prod(normcdf([g(i) g(j)]));		

        % check whether DG distribution for covariance exists
        if (c(i,j) - bivnor(-g(i),-g(j),-1) + pn) < -1e-3 || ...
           (c(i,j) - bivnor(-g(i),-g(j),1) + pn) > 1e-3
            error('A joint Bernulli distribution with the given covariance matrix does not exist!')
        end

        % determine Lambda_ij iteratively by bisection (Psi is monotonous in rho)
        while cMax - cMin > acc
            cNew = (cMax + cMin) / 2;
            if c(i,j) > bivnor(-g(i),-g(j),cNew) - pn
                cMin = cNew;
            else
                cMax = cNew;
            end
        end
        
        L(i,j) = cMax;
        L(j,i) = cMax;
    end
end


