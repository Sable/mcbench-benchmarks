function res = simpson(x,y,dim,rule)
% SIMPSON Simpson's rule for quadratic and cubic numerical integration
% 	RES = SIMPSON(Y) computes an approximation of the integral of Y via
% 	Simpson's 1/3 rule (with unit spacing).  Simpson's 1/3 rule uses 
% 	quadratic interpolants for numerical integration. To compute the 
%   integral for spacing different from one, multiply RES by the spacing 
%   increment.
%  
% 	For vectors, SIMPSON(Y) is the integral of Y. For matrices, SIMPSON(Y)
% 	is a row vector with the integral over each column. For N-D
%  	arrays, SIMPSON(Y) works across the first non-singleton dimension.
%  
% 	RES = SIMPSON(X,Y) computes the integral of Y with respect to X using
% 	Simpson's 1/3 rule.  X and Y must be vectors of the same
% 	length, or X must be a column vector and Y an array whose first
%  	non-singleton dimension is length(X). SIMPSON operates along this
% 	dimension. Note that X must be equally spaced for proper execution of
% 	the 1/3 and 3/8 rules. If X is not equally spaced, the trapezoid rule
% 	(MATLAB's TRAPZ) is recommended.
%  
% 	RES = SIMPSON(X,Y,DIM) or SIMPSON(Y,DIM) integrates across dimension 
%   DIM of Y. The length of X must be the same as size(Y,DIM)).
%  
%   RES = SIMPSON(X,Y,DIM,RULE) can be used to toggle between Simpson's 1/3
%   rule and Simpson's 3/8 rule. Simpson's 3/8 rule uses cubic interpolants
%   to accomplish the numerical integration. If the default value for DIM
%   is desired, assign an empty matrix.
%
%   - RULE options
%
%       [DEFAULT]   '1/3'   Simpson's rule for quadratic interpolants
%
%                   '3/8'   Simpson's rule for cubic interpolants
%
%  	Examples:
%       % Integrate Y = SIN(X)
%       x = 0:0.2:pi;
%       y = sin(x);
%       a = sum(y)*0.2; % Rectangle rule
%       b = trapz(x,y); % Trapezoid rule
%       c = simpson(x,y,[],'1/3'); % Simpson's 1/3 rule
%       d = simpson(x,y,[],'3/8'); % Simpson's 3/8 rule
%       e = cos(x(1))-cos(x(end)); % Actual integral
%       fprintf('Rectangle Rule:     %.15f\n', a)
%       fprintf('Trapezoid Rule:     %.15f\n', b)
%       fprintf('Simpson''s 1/3 Rule: %.15f\n', c)
%       fprintf('Simpson''s 3/8 Rule: %.15f\n', d)
%       fprintf('Actual Integral:    %.15f\n', e)
%
%       % http://math.fullerton.edu/mathews/n2003/simpson38rule/Simpson38RuleMod/Links/Simpson38RuleMod_lnk_2.html
%       x1 = linspace(0,2,4);
%       x2 = linspace(0,2,7);
%       x4 = linspace(0,2,13);
%       y = @(x) 2+cos(2*sqrt(x));
%       format long
%       y1 = y(x1); res1 = simpson(x1,y1,[],'3/8'); disp(res1)
%       y2 = y(x2); res2 = simpson(x2,y2,[],'3/8'); disp(res2)
%       y4 = y(x4); res4 = simpson(x4,y4,[],'3/8'); disp(res4)
%
%   Class support for inputs X, Y:
%      float: double, single
%
%   See also SUM, CUMSUM, TRAPZ, CUMTRAPZ.

%
% Jered Wells
% 10/26/11
% jered [dot] wells [at] gmail [dot] com
%
% v1.1 (02/27/2012)

perm = []; nshifts = 0;
if nargin == 4 || nargin == 3 % simpson(x,y,dim,rule) || simpson(x,y,dim)
    if isempty(dim) 
        [y,nshifts] = shiftdim(y);
        m = size(y,1);
    else
        perm = [dim:max(ndims(y),dim) 1:dim-1];
        y = permute(y,perm);
        m = size(y,1);
    end
    if nargin==3; rule = '1/3'; end
elseif nargin==2 && isscalar(y) % simpson(y,dim)
  dim = y; y = x;
    if isempty(dim)
        [y,nshifts] = shiftdim(y);
        m = size(y,1);
    else
        perm = [dim:max(ndims(y),dim) 1:dim-1];
        y = permute(y,perm);
        m = size(y,1);
    end
  x = 1:m;
  rule = '1/3';
else % simpson(y) or simpson(x,y)
  if nargin < 2, y = x; end
  [y,nshifts] = shiftdim(y);
  m = size(y,1);
  if nargin < 2, x = 1:m; end
  rule = '1/3';
end
if ~isvector(x)
  error('MATLAB:simpson:xNotVector', 'X must be a vector.');
end
x = x(:);
if length(x) ~= m
  if isempty(perm) % dim argument not given
    error('MATLAB:simpson:LengthXmismatchY',...
          'LENGTH(X) must equal the length of the first non-singleton dimension of Y.');
  else
    error('MATLAB:simpson:LengthXmismatchY',...
          'LENGTH(X) must equal the length of the DIM''th dimension of Y.');
  end
end

% The output size for [] is a special case when DIM is not given.
if isempty(perm) && isequal(y,[])
  res = zeros(1,class(y));
  return;
end

if ~iseqspsimp(x)
    warning('MATLAB:simpson:XNotEquallySpaced',...
        'X may not be equally spaced: Try TRAPZ for numerical integration instead')
end

% % Differentiate X to yield panel heights H
% h = diff(x,1,1);

h = (max(x)-min(x))/(length(x)-1);

switch rule
    case '3/8'
        % Execute the 3/8 rule
        n = m-1; 
        if n<3; error 'N>2 required for Simpson''s 3/8 rule'; end
        n38 = n-mod(n,3)-3*mod(mod(n,3),2);
        res = simpson38(y(1:n38+1,:),h)+...
              simpson13(y(n38+1:end,:),h);
    case '1/3'
        % Execute the 1/3 rule
        n = m-1; 
        if n<2; error 'N>1 required for Simpson''s 1/3 rule'; end
        n13 = n-3*mod(n,2);
        res = simpson13(y(1:n13+1,:),h)+...
              simpson38(y(n13+1:end,:),h);
    otherwise
        error 'Invalid option for RULE'
end

siz = size(y); siz(1) = 1;
res = reshape(res,[ones(1,nshifts),siz]);
if ~isempty(perm), res = ipermute(res,perm); end
end % MAIN

function res = simpson13(y,h)
res = sum(y(1:2:end-2,:)+4*y(2:2:end-1,:)+y(3:2:end,:),1)*h/3;
end % SIMPSON13

function res = simpson38(y,h)
res = sum(y(1:3:end-3,:)+3*(y(2:3:end-2,:)+...
          y(3:3:end-1,:))+y(4:3:end,:),1)*h*3/8;
end % SIMPSON38

function res = iseqspsimp(v)
v2 = linspace(min(v),max(v),length(v))';
% Compute error from subtraction due to propagation of error
errsub = hypot(eps(v),eps(v2));   
res = all(abs(v-v2)<=errsub);
end % ISEQSPSIMP



