function [z_pc varargout] = myPCA(z,NUM,varargin)
%--------------------------------------------------------------------------
% Syntax:       z_pc = myPCA(z,NUM);
%               [z_pc T U mean_z] = myPCA(z,NUM);
%               [z_pc T U mean_z] = myPCA(z,NUM,'std');
%               [z_pc eigVecs] = myPCA(z,NUM,'eig');
%
% Inputs:       z is an M x N matrix containing N samples of an
%               M-dimensional multivariate random variable
%
%               NUM is the desired number of principal components.
%
%               mode can be {'std','eig'}. The default is 'std'.
%               
% Outputs:      z_pc is a NUM x N matrix containing the NUM principal
%               components (scaled to have variance 1) of each of the N
%               samples in z.
%
%               U and T are the PCA transformation matrices such that:
%               z_LD = U / T * z_pc + repmat(mean_z,1,size(z,2));
%               is the NUM-dimensional PCA approximation of z
%
%               mean_z is the M x 1 sample mean vector of z.
%
%               eigVecs contains the eigenvectors of the sample covariance
%               matrix of z. The eigenvectors are scaled by the square root
%               of their corresponding eigenvalues.
%
% Description:  This function performs principal component analysis (PCA)
%               on the input samples of a multivariate random variable and
%               returns the NUM prinicpal components of each sample.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         July 19, 2012
%--------------------------------------------------------------------------

% Parse user input
if (nargin == 3)
    mode = varargin{1};
else
    mode = 'std';
end

% Get data dimension
[~,n] = size(z);

% Center the input data
[z_c mean_z] = myCenter(z);

%----------------------------------
% 3 equivalent ways to compute z_pc
%----------------------------------
% 1. (Least memory)
[U S ~] = svd(z_c,'econ');
z_pc = U(:,1:NUM)' * z_c;
%----------------------------------
% 2. (Fewest computations)
%[U S V] = svd(z,'econ');
%z_pc = zeros(NUM,n);
%for i = 1:NUM
%    z_pc(i,:) = S(i,i) * V(:,i);
%end
%----------------------------------
%3.
%[U S V] = svd(z,'econ');
%z_pc = eye(NUM,m)*S*V';
%----------------------------------

% Normalize variances to 1
[z_pc T] = myWhiten(z_pc);

if strcmpi(mode,'eig')
    % Scale the eigenvectors
    eigVecs = U(:,1:NUM);
    for i = 1:NUM
      eigVecs(:,i) = eigVecs(:,i) * (S(i,i) / sqrt(n));
    end
    varargout{1} = eigVecs;
else
    varargout{1} = T;
    varargout{2} = U(:,1:NUM);
    varargout{3} = mean_z;
end
