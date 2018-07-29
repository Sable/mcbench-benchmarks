function rnd = cauchy_rnd(m,s)
%---------------------------------------------------
% PURPOSE: 
% Returns random draws from the Cauchy-Lorentz Distribution 
%---------------------------------------------------
% USAGE: 
% rnd = cauchy_rnd(m,s)
% where: 
% m = (n x 1) or (n x 1) vector
% s = (n x 1) or (n x 1) vector
%---------------------------------------------------
% RETURNS: 
% rnd = (n x 1) or (1 x n) vector 
%---------------------------------------------------
% Author:
% Alexandros Gabrielsen, a.gabrielsen@city.ac.uk
% Date: 06/2010
%---------------------------------------------------

if nargin == 0 
    error('Location Parameter, Scale Parameter') 
end

% One Approach
%rnd = m + s*tan(pi*(randn-1/2));
% Second Approach
rnd = cauchy_inv(randn,m,s);

end