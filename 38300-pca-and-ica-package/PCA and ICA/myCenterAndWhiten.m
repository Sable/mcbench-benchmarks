function [z_cw varargout] = myCenterAndWhiten(z)
%--------------------------------------------------------------------------
% Syntax:       z_cw = myCenterAndWhiten(z);
%               [z_cw T] = myCenterAndWhiten(z);
%               [z_cw T mean_z] = myCenterAndWhiten(z);
%
% Inputs:       z is a matrix is an m x n matrix containing n samples of a
%               multivariate random variable of dimension m.
%               
% Outputs:      z_cw is the centered and whitened version of z.
%
% Description:  This function returns a centered and whitened version of
%               the input matrix of multivariate random vector samples.
%               That is:
%
%               cov(z_cw') = eye(size(z_cw,1));
%               mean(z_cw,2) = zeros(size(z_cw,1),1);
%
%               Note: z = T \ z_cw + repmat(mean_z,1,size(z_cw,2))
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         July 19, 2012
%--------------------------------------------------------------------------

% Center z
[z_c mean_z] = myCenter(z);

% Whiten z_c
[z_cw T] = myWhiten(z_c);

if (nargout == 2)
    varargout{1} = T;
elseif (nargout == 3)
    varargout{1} = T;
    varargout{2} = mean_z;
end
