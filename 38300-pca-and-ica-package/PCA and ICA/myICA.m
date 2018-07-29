function [z_ic A T mean_z] = myICA(z,NUM,varargin)
%--------------------------------------------------------------------------
% Syntax:       z_ic = myICA(z,NUM);
%               z_ic = myICA(z,NUM,'true');
%               z_ic = myICA(z,NUM,'false');
%               [z_ic A T mean_z] = myICA(z,NUM);
%               [z_ic A T mean_z] = myICA(z,NUM,'true');
%               [z_ic A T mean_z] = myICA(z,NUM,'false');
%
% Inputs:       z is an M x N matrix containing N samples of an
%               M-dimensional multivariate random variable
%
%               NUM is the desired number of independent components.
%
%               display can be {'true','false'}. The default is 'true'.
%
% Outputs:      z_ic is a NUM x N matrix containing the NUM independent
%               components (scaled to have variance 1) of each of the N
%               samples in z.
%
%               A and T are the ICA transformation matrices such that:
%               z_LD = T \ pinv(A) * z_ic + repmat(mean_z,1,size(z,2));
%               is the NUM-dimensional ICA approximation of z
%
%               mean_z is the M x 1 sample mean vector of z.
%
% Description:  This function performs independent component analysis (ICA)
%               on the input samples of a multivariate random variable and
%               returns the NUM independent components of each sample.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         July 20, 2012
%--------------------------------------------------------------------------

eps = 1e-4; % Convergence criteria
maxSamples = 1000; % Max number of data points in sample mean calculations
maxIters = 100; % Maximum number of iterations allowed

% Parse user input
if (nargin == 3)
    display = varargin{1};
else
    display = 'true';
end

% Center and whiten the input data
[z_cw T mean_z] = myCenterAndWhiten(z);

% Get data dimension
[m,n] = size(z_cw);

if (n > maxSamples)
    % Draw maxSamples data points at random for sample mean calculations
    z_cw_trimmed = z_cw(:,randperm(n,maxSamples));
else
    % Use all data points for sample mean calculations
    z_cw_trimmed = z_cw;
end

% Choose random weights initially
w = rand(NUM,m);
for i = 1:NUM
    w(i,:) = w(i,:) / norm(w(i,:));
end

% Initialize loop variables
err = ones(NUM,1);
its = 0;

while ((max(err) > eps) && (its < maxIters))
    % Increment iteration counter
    its = its + 1;
    
    % Save last weight matrix
    w_old = w;
    
    % for each weight vector
    for i = 1:NUM
        % Last independent components
        si = w_old(i,:) * z_cw_trimmed;
        
        % Compute negentropy scores
        % negentropy function : f(u) = -exp(-u^2/2)
        g = si .* exp(-0.5 * (si.^2));
        gp = -1.0 * ((si.^2) .* exp(-0.5 * (si.^2)));
        
        % Update weights in the direction of maximum negentropy
        w(i,:) = mean(z_cw_trimmed .* repmat(g,m,1),2)' - mean(gp) * w_old(i,:);
        
        % Normalize weight vector
        w(i,:) = w(i,:) / norm(w(i,:));
    end
    
    % Decorrelate weight vectors
    [U,S,~] = svd(w,'econ');
    Sinv = diag(1./diag(S));
    w = U * Sinv * U' * w;
    
    % Compute innovation
    for i = 1:NUM
        err(i) = 1 - w(i,:) * w_old(i,:)';
    end
    
    % Display innovation
    if strcmpi(display,'true')
        disp(['Iteration ' num2str(its) ': max(1 - <w' num2str(its) ',w' num2str(its-1) '>) = ' num2str(max(err))])
    end
end

% Return transformation matrix
A = w;

% Compute independent components
z_ic = A * z_cw;
