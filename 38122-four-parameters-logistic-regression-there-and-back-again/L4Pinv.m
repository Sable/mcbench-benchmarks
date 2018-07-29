function x = L4Pinv(cf,y)
%L4PINV The inverse of the 4 parameters logistic equation.
% The Four Parameters Logistic Regression or 4PL nonlinear regression model
% is commonly used for curve-fitting analysis in bioassays or immunoassays
% such as ELISAs or dose-response curves. 
%
% Syntax: x=L4Pinv(cf,y)
% 
% Inputs: 
%           cf is the object containing the 4 parameters of logistic
%           equation computed by L4P function. Alternatively, it can be a
%           1x4 array.
%
%           y is the array of the response that you want to iterpolate. 
%
% Outputs:
%           x is the vector of interpolated data.
% 
% Example:
%
% xs=[0 4.5 10.6 19.7 40 84 210]; ys=[0.0089 0.0419 0.0873 0.2599 0.7074 1.528 2.7739];
%
% Calling on MatLab the function: [cf G]=L4P(x,y);
%
% you will find the 5 parameters of this curve. 
% 
% Calling on MatLab the function L4Pinv(cf,1.782315);
% 
%           Answer is:
% ans =
%
%  99.9982
%
% Alternatively, you can do:
% 
% P=[0.0010 1.5153 108.0035 3.7841]; L4Pinv(P,1.782315);
% 
% with the same result.
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% See also L4P, L5P, L5Pinv, L3P, L3Pinv
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2012) Four parameters logistic regression - There and back again
% 

%--------------------Input errors handling section-------------------------
if nargin < 2
    error('Almost two inputs are required')
end
if isobject(cf)
    p=coeffvalues(cf);
else
    p=cf;
    if ~isvector(p) || length(p)~=4 || ~all(isfinite(p))
        error('cf must be a fit object or a 1x4 vector of real and finite numbers')
    end
end

%-------------------------Interpolate--------------------------------------
x=NaN(size(y)); ok=isfinite(y);
x(ok)=p(3).*(((p(1)-p(4))./(y(ok)-p(4)))-1).^(1/p(2));
