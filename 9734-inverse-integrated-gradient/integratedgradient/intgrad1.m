function fhat = intgrad1(fx,dx,f1,method)
% intgrad: generates a vector, integrating derivative information.
% usage: fhat = intgrad1(dfdx)
% usage: fhat = intgrad1(dfdx,dx)
% usage: fhat = intgrad1(dfdx,dx,f1)
% usage: fhat = intgrad1(dfdx,dx,f1,method)
%
% arguments: (input)
%  dfdx - vector of length nx, as gradient would have produced.
%
%    dx - (OPTIONAL) scalar or vector - denotes the spacing in x
%         if dx is a scalar, then spacing in x (the column index
%         of fx and fy) will be assumed to be constant = dx.
%         if dx is a vector, it denotes the actual coordinates
%         of the points in x (i.e., the column dimension of fx
%         and fy.) length(dx) == nx
%
%         DEFAULT: dx = 1
%
%    f1 - (OPTIONAL) scalar - defines the first eleemnt of fhat
%         after integration. This is just the constant of integration.
%
%         DEFAULT: f1 = 0
%
%  method - (OPTIONAL) scalar - either 0, 1, 2, or 3. Defines
%         the integration scheme used.
%
%         method = 0 --> cumtrapz
%
%         method = 1 --> solves central finite difference
%                        approximation using linear algebra
%                        A second order fda. At least 3 points
%                        are necessary.
%
%         method = 2 --> integrated spline model
%                        This will almost always be the most
%                        accurate among the alternative methods.
%
%         method = 3 --> integrated pchip model
%
%         method = 4 --> higher order finite difference approximation
%                        A 4th order fda. At least 5 points are
%                        necessary.
%
%         DEFAULT: method = 2
%
%         Note: method = 0 (cumtrapz) will generally be the fastest,
%         and method = 2 (spline integral) will be the most accurate
%         of the four methods.
%         Methods 1, 3, and 4 were put in there mainly for fun on my
%         part, lthough for equally spaced points, the 4th order fda
%         should also be quite accurate.
%
%         Data series with noise in them may be best integrated using
%         a lower order method to avoid noise amplification.
%
% arguments: (output)
%   fhat - vector of length nx, containing the integrated function
%
% Example usage: 
%  x = 0:.001:1;
%  f = exp(x) + exp(-x);
%  dfdx = exp(x) - exp(-x);
%  tic,fhat = intgrad1(dfdx,.001,2,2);toc

% Author; John D'Errico
% Current release: 2
% Date of release: 1/27/06

% size 
if (length(fx)~=numel(fx))
  error 'dfdx must be a vector.'
end
sx = size(fx);
fx = fx(:);
nx = length(fx);
if nx<2
  error 'dfdx must be a vector of length >= 2'
end

% supply defaults if needed
if (nargin<2) || isempty(dx)
  % default x spacing is 1
  dx = 1;
end
if (nargin<3) || isempty(f1)
  % default integration constant is 0
  f1 = 0;
end
if (nargin<4) || isempty(method)
  % default integration method is 2
  method = 2;
end

% if scalar spacings, expand them to be vectors
dx=dx(:);
uniflag = 1;
if length(dx) == 1
  mdx = dx; % mean of dx
  xp = (0:(nx-1))'*dx;
  dx = repmat(dx,nx-1,1);
elseif length(dx)==nx
  % dx was a vector, use diff to get the spacing
  xp = dx;
  dx = diff(dx);
  mdx = mean(dx);
  ddx = diff(dx);
  if any(dx<=0)
    error 'x points must be monotonic increasing'
  elseif any(abs(ddx)>(xp(end)*1.e-15))
    uniflag = 0;
  end
else
  error 'dx is not a scalar or of length == nx'
end

if (length(f1) > 1) || ~isnumeric(f1) || isnan(f1) || ~isfinite(f1)
  error 'f1 must be a finite scalar numeric variable.'
end

if ~ismember(method,[0 1 2 3 4])
  error 'Method must be one of: [0, 1, 2, 3 4]'
end

switch method
  case 0
    % cumtrapz
    fhat = f1 + cumtrapz(xp,fx);
  case 1
    % builds a system using finite differences, then solves using \
    if nx<3
      error 'Method == 2 requires at least 3 points'
    end
    
    % build gradient design matrix, sparsely. Use a central difference
    % in the body of the array, and forward/backward differences along
    % the edges.
    
    % A will be the final design matrix. it will be sparse.
    Af = zeros(nx,9);
    
    % non-central difference at first point
    d = igfda([dx(1),dx(1)+dx(2)],1);
    Af(1,:) = [1 1 1 1 2 3,d];
    
    % interior df/dx, central difference
    i = (2:(nx-1))';
    if uniflag
      d = repmat([0 -1 1]./(2*mdx),nx-2,1);
    else
      dxi = [-dx(i-1),dx(i)];
      d = igfda(dxi,1);
    end
    Af(i,:) = [i, i, i, i, i-1, i+1,d];
    
    % non-central difference at last point
    d = igfda([-dx(end-1)-dx(end),-dx(end)],1);
    Af(nx,:) = [nx, nx, nx, nx, nx-2, nx-1, d];
    
    % finally, we can build the rest of A itself, in its sparse form.
    A = sparse(Af(:,1:3),Af(:,4:6),Af(:,7:9),nx,nx);
    
    % Finish up with f11, the constant of integration.
    % eliminate the first unknown, as f11 is given.
    fhat = A(:,2:end)\(fx - A(:,1)*f1);
    fhat = [f1;fhat];
    
  case 2
    % integrate a spline model
    pp = spline(xp,fx);
    c = pp.coefs;
    fhat = dx.*(c(:,4) + dx.*(c(:,3)./2 + dx.*(c(:,2)./3 + dx.*c(:,1)./4)));
    fhat = f1+[0;cumsum(fhat)];
    
  case 3
    % integrate a pchip model
    pp = pchip(xp,fx);
    c = pp.coefs;
    fhat = dx.*(c(:,4) + dx.*(c(:,3)./2 + dx.*(c(:,2)./3 + dx.*c(:,1)./4)));
    fhat = f1+[0;cumsum(fhat)];
    
  case 4
    % builds a system using finite differences, then solves using \
    if nx<5
      error 'Method == 4 requires at least 5 points.'
    end
    
    % build gradient design matrix, sparsely. Use a central difference
    % in the body of the array, and forward/backward differences along
    % the edges.
    
    % A will be the final design matrix. it will be sparse.
    Af = zeros(nx,15);
    
    % non-central difference at start
    d = igfda(cumsum(dx(1:4)'),1);
    Af(1,:) = [1 1 1 1 1, 1 2 3 4 5, d];
    d = igfda([-dx(1),cumsum(dx(2:4)')],1);
    Af(2,:) = [2 2 2 2 2, 2 1 3 4 5, d];
    
    % interior df/dx, central difference
    i = (3:(nx-2))';
    if uniflag
      mdx = mean(dx);
      %       d = fda(mdx*[-2 -1 1 2],1);
      d = [0 1/12 -2/3 2/3 -1/12]./mdx;
      d = repmat(d,nx-4,1);
    else
      dxi = [-dx(i-2)-dx(i-1), -dx(i-1), dx(i), dx(i)+dx(i+1)];
      d = igfda(dxi,1);
    end
    Af(i,:) = [i i i i i, i i-2 i-1 i+1 i+2, d];
    
    % non-central difference at end point
    d = igfda([-dx(end-3)-dx(end-2)-dx(end-1), ...
             -dx(end-2)-dx(end-1),-dx(end-1),dx(end)],1);
    Af(nx-1,:) = [repmat(nx-1,1,5), nx+[-1 -4 -3 -2 0], d];
    
    d = igfda([-dx(end-3)-dx(end-2)-dx(end-1)-dx(end), ...
             -dx(end-2)-dx(end-1)-dx(end), ...
             -dx(end-1)-dx(end),-dx(end)],1);
    Af(nx,:) = [repmat(nx,1,5), nx+[0 -4 -3 -2 -1], d];
    
    % finally, we can build the rest of A itself, in its sparse form.
    A = sparse(Af(:,1:5),Af(:,6:10),Af(:,11:15),nx,nx);
    
    % Finish up with f11, the constant of integration.
    % eliminate the first unknown, as f11 is given.
    fhat = A(:,2:end)\(fx - A(:,1)*f1);
    fhat = [f1;fhat];
    
end

% restore row or column shape of fhat
fhat = reshape(fhat,sx);

%=============================================
%   begin subfunctions
%=============================================
function coef = igfda(dxlist,estimator)
% fda: computes finite difference coefficients
% usage: coef = igfda(dxlist,estimator)
%
% Will compute one fda for each row of dxlist
%
% arguments: (input)
%  dxlist - (nxp) numeric arrray - list of deltas from the
%         central node of the fda.
%
%  estimator - (OPTIONAL) scalar - denotes the derivative order
%         to be estimated
%
%         estimator = k --> estimate the k'th derivative
%
%         DEFAULT: estimator = 1

if (nargin<2) || isempty(estimator)
  estimator = 1;
end

[n,p] = size(dxlist);
nfda = p + 1;

if (estimator < 0) || (estimator > (nfda-1))
  error 'Invalid derivative order requested'
end

% tolerance for consolidator to cluster the deltas
tol = max(abs(dxlist(:))*1e-14);
if size(n,1)>1
  [dxu,ind] = consolidator(dxlist,[],[],tol);
else
  dxu = dxlist;
  ind = 1:n;
end
nu = size(dxu,1);

% loop over the distinct rows of dxlist
coef = zeros(nu,nfda);
E = zeros(nfda,1);
E(nfda - estimator) = 1;
pwr = repmat(p:-1:0,nfda,1);
f = repmat(1./factorial((nfda-1):-1:0),nfda,1);
for i = 1:nu
  M = f.*(repmat([0;dxu(i,:)'],1,nfda).^pwr);
  coef(i,:) = (M'\E)';
end

% expand any consolidated sets
coef = coef(ind,:);



