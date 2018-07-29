function varargout  =   vect2var(varargin)
%VECT2VAR Unpack vector to variables
%
%     [x1, x2, x3,...] =   vect2var(X) create variables x1, x2, x3... from
%     the vector X in the current workspace such as x1 = X(1), x2 = X(2),
%     x3 = X(3)...
%     vect2var is usefull with the optimization toolbox in which unknown 
%     variables can be grouped into a single row vector. vect2var allows
%     the use of common names for variables with a minimum waste of time.
%
%     Example :
%     X     =   [3E5    20   5   0.898];
%     [b f jh ws] =   vect2var(X)
%     Returns :
%       b =
%             300000
%       f =
%           20
%       jh =
%            5
%       ws =
%           0.8980
%
%     See also DEAL, MMV2STRUCT, LISTS

%   vect2var is complementary of mmv2struct developped by D.C. Hanselman
%   Author : Meille Christophe
%   Pharmacokinetics Department, UFR Pharmacy, Marseille France
%   Version 1.07    Date: 2005/11/18

X   =   varargin{1};% Extract vector X
lgt =   nargout;    % Extract number of outputs
if ndims(X)>2       % Error handling
    error('Input vector required.')
elseif length(X)<lgt
    error('Input vector shorter than number of outputs.')
else
    varargout = cell(1,lgt);% preallocating cell array
    for i=1:lgt;% index of outputs
        varargout{i}    =   X(i); % unpack
    end
end