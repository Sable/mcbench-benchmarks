function [z_c varargout] = myCenter(z)
%--------------------------------------------------------------------------
% Syntax:       z_c = myCenter(z);
%               mean_z = myCenter(z);
%
% Inputs:       z is a matrix is an m x n matrix containing n samples of a
%               multivariate random variable of dimension m.
%               
% Outputs:      z_c is the centered version of z.
%
%               mean_z is the vector of sample means of z
%
% Description:  This function returns the centered version of the input
%               matrix of multivariate random vector samples. That is:
%
%               mean(z_c,2) = zeros(size(z_c,1),1);
%
%               Note: z = z_c + repmat(mean_z,1,size(z_c,2))
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         July 19, 2012
%--------------------------------------------------------------------------

mean_z = mean(z,2);
z_c = z - repmat(mean_z,1,size(z,2));

if (nargout == 2)
    varargout{1} = mean_z;
end
