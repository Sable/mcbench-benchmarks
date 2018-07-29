function dy = diffxy(x,y,varargin)
% DIFFXY - accurate numerical derivative/differentiation of Y w.r.t X. 
%
%   DY = DIFFXY(X,Y) returns the derivative of Y with respect to X using a 
%        pseudo second-order accurate method. DY has the same size as Y.
%   DY = DIFFXY(X,Y,DIM) returns the derivative along the DIM-th dimension
%        of Y. The default is differentiation along the first 
%        non-singleton dimension of Y.
%   DY = DIFFXY(X,Y,DIM,N) returns the N-th derivative of Y w.r.t. X.
%        The default is 1.
%
%   Y may be an array of any dimension.
%   X can be any of the following:
%       - array X with size(X) equal to size(Y)
%       - vector X with length(X) equal to size(Y,DIM)
%       - scalar X denotes the spacing increment
%   DIM and N are both integers, with 1<=DIM<=ndims(Y)
%
%   DIFFXY has been developed especially to handle unequally spaced data,
%   and features accurate treatment for end-points.
%
%   Example: 
%   % Data with equal spacing
%     x = linspace(-1,2,20);
%     y = exp(x);
% 
%     dy = diffxy(x,y);
%     dy2 = diffxy(x,dy);  % Or, could use >> dy2 = diffxy(x,y,[],2);
%     figure('Color','white')
%     plot(x,(y-dy)./y,'b*',x,(y-dy2)./y,'b^')
%
%     Dy = gradient(y)./gradient(x);
%     Dy2 = gradient(Dy)./gradient(x);
%     hold on
%     plot(x,(y-Dy)./y,'r*',x,(y-Dy2)./y,'r^')
%     title('Relative error in derivative approximation')
%     legend('diffxy: dy/dx','diffxy: d^2y/dx^2',...
%            'gradient: dy/dx','gradient: d^2y/dx^2')
%
%   Example: 
%   % Data with unequal spacing. 
%     x = 3*sort(rand(20,1))-1;
%     % Run the example above from y = exp(x)
%
%   See also DIFF, GRADIENT
%        and DERIVATIVE on the File Exchange

% for Matlab (should work for most versions)
% version 1.0 (Nov 2010)
% (c) Darren Rowland
% email: darrenjrowland@hotmail.com
%
% Keywords: derivative, differentiation

[h,dy,N,perm] = parse_inputs(x,y,varargin);
if isempty(dy)
    return
end
n = size(h,1);
i1 = 1:n-1;
i2 = 2:n;

for iter = 1:N
    v = diff(dy)./h;
    if n>1
        dy(i2,:) = (h(i1,:).*v(i2,:)+h(i2,:).*v(i1,:))./(h(i1,:)+h(i2,:));
        dy(1,:) = 2*v(1,:) - dy(2,:);
        dy(n+1,:) = 2*v(n,:) - dy(n,:);
    else
        dy(1,:) = v(1,:);
        dy(n+1,:) = dy(1,:);
    end
end

% Un-permute the derivative array to match y
dy = ipermute(dy,perm);

%%% Begin local functions %%%
function [h,dy,N,perm] = parse_inputs(x,y,v)

numvarargs = length(v);
if numvarargs > 2
    error('diffxy:TooManyInputs', ...
        'requires at most 2 optional inputs');
end

h = [];
N = [];
perm = [];

% derivative along first non-singleton dimension by default
dim = find(size(y)>1);
% Return if dim is empty
if isempty(dim)
    dy = [];
    return
end
dim = dim(1);

% Set defaults for optional arguments
optargs = {dim 1};
newVals = ~cellfun('isempty', v);
optargs(newVals) = v(newVals);
[dim, N] = optargs{:};

% Error check on inputs
if dim<1 || dim>ndims(y) || dim~=fix(dim) || ~isreal(dim)
    error('diffxy:InvalidOptionalArg',...
        'dim must be specified as a non-negative integer')
end
if N~=fix(N) || ~isreal(N)
    error('diffxy:InvalidOptionalArg',...
        'N must be an integer')
end

% permutation which will bring the target dimension to the front
perm = 1:length(size(y));
perm(dim) = [];
perm = [dim perm];
dy = permute(y,perm);


if length(x)==1  % Scalar expansion to match size of diff(dy,[],1)
    sizeh = size(dy);
    sizeh(1) = sizeh(1) - 1;
    h = repmat(x,sizeh);
elseif ndims(x)==2 && any(size(x)==1) % Vector x expansion
    if length(x)~=size(dy,1)
        error('diffxy:MismatchedXandY',...
            'length of vector x must match size(y,dim)')
    end
    x = x(:);
    sizeh = size(dy);
    sizeh(1) = 1;
    h = repmat(diff(x),sizeh);
else
    if size(y) ~= size(x)
        error('diffxy:MismatchedXandY',...
            'mismatched sizes of arrays x and y');
    end
    % Permute x as for y, then diff
    h = diff(permute(x,perm),[],1);
end