function [cf G]=L5P(x,y,varargin)
%L5P Five Parameters logistic regression
% The Five Parameters Logistic Regression or 5PL nonlinear regression model
% is commonly used for curve-fitting analysis in bioassays or immunoassays
% such as ELISAs or dose-response curves. The standard dose-response curve
% is sometimes called the four-parameter logistic equation. 
% It is characterized by it’s classic “S” or sigmoidal shape that fits the
% bottom and top plateaus of the curve, the EC50, and the slope factor
% (Hill slope). This curve is symmetrical around its inflection point. To
% extend the model to handle curves that are not symmetrical, the Richards
% equation adds an additional parameter, which quantifies the asymmetry.
% This equation is sometimes referred to as a five-parameters logistic
% equation.      
% The 5PL equation is:
% F(x) = D+(A-D)/((1+(x/C)^B)^E)
% where:
% A = Minimum asymptote. In a bioassay where you have a standard curve,
% this can be thought of as the response value at 0 standard concentration.
%
% B = Hill's slope. The Hill's slope refers to the steepness of the curve.
% It could either be positive or negative.
%
% C = Inflection point. The inflection point is defined as the point on the
% curve where the curvature changes direction or signs. C is the
% concentration of analyte where y=(D-A)/2.
%
% D = Maximum asymptote. In an bioassay where you have a standard curve,
% this can be thought of as the response value for infinite standard
% concentration. 
% 
% E = Asymmetry factor. When E=1 we have a symmetrical curve around
% inflection point and so we have a four-parameters logistic equation.
%
% Syntax: [cf G]=L5P(x,y,st,L,U)
% 
% Inputs: 
%           X and Y (mandatory) - data points.
%           X is a Nx1 column vector and Y must have the same rows number
%           of X. If Y is a NxM matrix (N points and M replicates), L5P
%           will generate a  column vector computing means for each row.
%           The standard deviations of the rows will be used as weights of
%           regression.
%
%           st = starting points. This is a 1x5 vector of starting points
%           that have to be used to start the process of not linear
%           fitting. If this vector is not provided, L5P will set the
%           starting points on the basis of x and y data.
%
%           L = Lower bounds of parameters. This is a 1x5 vector of lower
%           bounds of the 5 parameters. If this vector is not provided, L5P
%           will set it on the basis of x and y data.
%
%           U = Upper bounds of parameters. This is a 1x5 vector of upper
%           bounds of the 5 parameters. If this vector is not provided, L5P
%           will set it on the basis of x and y data.
%
% Outputs:
%           cf = the FIT object
%           G = goodness-of-fit measures, for the given inputs, in the
%           structure G. G includes the fields: 
%           -- SSE         sum of squares due to error
%           -- R2          coefficient of determination or R^2
%           -- adjustedR2  degree of freedom adjusted R^2
%           -- stdError    fit standard error or root mean square error
% 
% Example:
%
% x=[0 4.5 10.6 19.7 40 84 210]; y=[0.0089 0.0419 0.0873 0.2599 0.7074 1.528 2.7739];
%
% Calling on MatLab the function: [cf G]=L5P(x,y)
% 
%           Answer is:
% 
% cf = 
% 
%      General model:
%      cf(x) = D+(A-D)/((1+(x/C)^B)^E)
%      Coefficients (with 95% confidence bounds):
%        A =   0.0009063  (-0.08996, 0.09177)
%        B =       1.515  (0.3517, 2.678)
%        C =         108  (-659.2, 875.3)
%        D =       3.784  (-5.297, 12.87)
%        E =           1  (-10.35, 12.35)
% 
% G = 
% 
%            sse: 0.0012
%        rsquare: 0.9998
%            dfe: 2
%     adjrsquare: 0.9994
%           rmse: 0.0245
%
% hold on; plot(x,y,'ro'); plot(cf,'r'); hold off
% this will plot the curve.
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% See also L5Pinv
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2012) Five parameters logistic regression - There and back again
% http://www.mathworks.com/matlabcentral/fileexchange/38043

%--------------------Input errors handling section-------------------------
if nargin < 2
    error('Almost X and Y vectors are required')
end

x=x(:); 
if ~isvector(x)
    error('X must be a column vector')
end

%if y is a matrix, compute means and standard deviations
we=zeros(size(x));
if ~isvector(y) 
    we=std(y,0,2);
    y=mean(y,2);
end
y=y(:);

if size(x)~=size(y)
    error('X and Y must have the same raws number')
end

ok_ = isfinite(x) & isfinite(y);
if ~all( ok_ )
    warning('L5P:IgnoringNansAndInfs','Ignoring NaNs and Infs in data.');
end

%To compute 5 parameters you almost need 5 points...
if length(x(ok_))<5 
        warning('L5P:NotEnoughData','Not enough Data points')
end

%set or check optional input data
args=cell(varargin);
nu=numel(args);
default.values = {[],[],[]};
default.values(1:nu) = args;
[st_ L U] = deal(default.values{:});

%set the starting points:
% A is the lower asymptote so guess it with min(y)
% B is the Hill's slope so guess it with the slope of the line between first and last point.
% C is the inflection point (the concentration of analyte where you have
% half of the max response) so guess it finding the concentration whose
% response is nearest to the mid response.
% D is the upper asymptote so guess it with max(y)
% E is the asymmetric factor and so guess it with no asymmetry (E=1).

slope=(y(end)-y(1))/(x(end)-x(1));
if isempty(st_)
    [~,Idx]=min(abs((y-((max(y)-min(y))/2))));
    st_=[min(y) sign(slope) x(Idx) max(y) 1];
else
    st_=st_(:)';
    if length(st_)~=5
        error('Starting points array must be a 1x5 array')
    end
end

%set the bounds. Of course all lower bounds are 0 and all upper bound are
%Inf. Anyway, if the slope is negative the lower bound of B is -Inf and the
%upper bound is 0. 

if isempty(L)
    L=zeros(1,5);
    if slope<0
        L(2)=-Inf;
    end
else
    L=L(:)';
    if length(L)~=5
        error('Lower bounds array must be a 1x5 array')
    end
end

if isempty(U)
    U=Inf(1,5);
    if slope<0
        U(2)=0;
    end
else
    U=U(:)';
    if length(L)~=5
        error('Upper bounds array must be a 1x5 array')
    end
end
clear args default nu slope Idx

%-----------------------------Fit the data---------------------------------
fo_ = fitoptions('method','NonlinearLeastSquares','Lower',L,'Upper',U);
set(fo_,'Startpoint',st_);
if all(we) % if y was a matrix use std as weights for fitting
    set(fo_,'Weights',we);
end
ft_ = fittype('D+(A-D)/((1+(x/C)^B)^E)',...
     'dependent',{'y'},'independent',{'x'},...
     'coefficients',{'A', 'B', 'C', 'D', 'E'});
 [cf G] = fit(x(ok_),y(ok_),ft_,fo_);
