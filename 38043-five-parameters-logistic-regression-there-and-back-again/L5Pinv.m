function x = L5Pinv(cf,y)
%L5PINV The inverse of the 5 parameters logistic equation.
% The Five Parameters Logistic Regression or 5PL nonlinear regression model
% is commonly used for curve-fitting analysis in bioassays or immunoassays
% such as ELISAs or dose-response curves. 
%
% Syntax: x=L5Pinv(cf,y)
% 
% Inputs: 
%           cf is the object containing the 5 parameters of logistic
%           equation computed by L5P function. Alternatively, it can be a
%           1x5 array.
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
% Calling on MatLab the function: [cf G]=L5P(x,y);
%
% you will find the 5 parameters of this curve. 
% 
% Calling on MatLab the function L5Pinv(cf,1.782315);
% 
%           Answer is:
% ans =
%
%  100.0000
%
% Alternatively, you can do:
% 
% P=[0.0009 1.5150 108.0187 3.7845 1]; L5Pinv(P,1.782315);
% 
% with the same result.
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% See also L5P
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2012) Five parameters logistic regression - There and back again
% http://www.mathworks.com/matlabcentral/fileexchange/38043

%--------------------Input errors handling section-------------------------
if nargin < 2
    error('Almost two inputs are required')
end
if isobject(cf)
    p=coeffvalues(cf);
else
    p=cf;
    if ~isvector(p) || length(p)~=5 || ~all(isfinite(p))
        error('cf must be a fit object or a 1x5 vector of real and finite numbers')
    end
end

%-------------------------Interpolate--------------------------------------
x=NaN(size(y));
x(isfinite(y))=p(3).*((((p(1)-p(4))./(y(isfinite(y))-p(4))).^(1/p(5))-1).^(1/p(2)));
