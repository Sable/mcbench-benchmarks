function [Q fcnEvals iter] = adaptiveLobatto(fcn, a, b, varargin)
% adaptiveLobatto - Numerically evaluate integral, adaptive Lobatto quadrature. 
%
% function [Q fcnEvals iter] = adaptiveLobatto(fcn, a, b, varargin)
%
% (c) Matthias Conrad and Nils Papenberg (2007-08-03)
% 
% Authors:               
%   Matthias Conrad (e-mail: conrad@tiaco.de)
%   Nils Papenberg  (e-mail: papenber@math.uni-luebeck.de)
%
% Version:
%		Release date: 2008-08-12   Version: 1.2
%   MATLAB Version 7.5.0.338 (R2007b)
%
% Description:
%   The adaptive Lobatto algorithm programmed in an iterative not recursive
%   manner
%
% Input arguments:
%   fcn             - function to be integrated 
%   a               - first point of interval
%   b               - final point of interval
%   #varargin       - further options of algorithm
%     tol           - tolerance accuracy of quadrature [ 1e-6 ]
%     parts         - initial number of partitions [ 2 ]
%     maxFcnEvals   - maximal number of function evaluations allowed [ 20000 ]
%     maxParts      - maximal number of partitions allowed [ 8000 ]
%
% Output arguments:
%   Q               - numerical integral of function fcn on [a,b]
%   fcnEvals        - number of function evaluations
%   iter            - number of iterations
%
% Details:
%   This function behavior is similar to of Matlab integrated function "quadv".
%   
%   Example:
%     Q = adaptiveLobatto(@(x) [-cos(50*x); sin(x)], 0, pi, 'tol', 1e-6)
%
% References:
%   [1] Gander, W. & Gautschi, W. Adaptive Quadrature - Revisited
%       Eidgenoessische technische Hochschule Zuerich, 2000.

% check scalar limits of interval
if ~isscalar(a) || ~isscalar(b)
  error('Matlab:adaptiveLobatto:Limits',...
    'The limits of integration must be scalars.');
end

% default values
tol = 1e-6; parts = 2; maxFcnEvals = 20000; maxParts = 8000;

% rewrite default options if needed
for j = 1 : length(varargin) / 2
  eval([varargin{2 * j - 1},'=varargin{',int2str(2 * j),'};']);
end

% initial values, termination constant, parts of interval and integral value
m = parts; parts = 4 * parts + 1; Q = 0;
minH = eps(b - a) / 1024; maxResolution = 0; iter = 0; 
poleWarning = 0;

% width constants
alpha = sqrt(2/3); beta = sqrt(1/5);

% check if interval has infinite boundaries, in case substitute function
if ~isfinite(a) || ~isfinite(b)
  warning('Matlab:adaptiveLobatto:infiniteInterval',...
    'The integral has an infinite interval; proceed with a substitution of function on finite interval.')
  if ~isfinite(a) && isfinite(b)
    [Q fcnEvals iter] = adaptiveLobatto(fcn, 0, b, varargin);
    fcn = @(t) infiniteLeft(t, fcn);
    a = 0; b = 1;
  elseif isfinite(a) && ~isfinite(b)
    [Q fcnEvals iter] = adaptiveLobatto(fcn, a, 0, varargin);
    fcn = @(t) infiniteRight(t, fcn);
    a = 0; b = 1;
  else
    fcn = @(t) infiniteBoth(t, fcn);
    a = - pi / 2; b = pi / 2;
  end
end

% initialize grid
t = linspace(a, b, m + 1);
A = t(1:end-1); B = t(2:end);

% widths and midpoints of intervals
H = diff(t)/2; J = (A + B) / 2;

% grid points
F = -alpha * H + J; D = -beta * H + J; C =  J;
E =  beta * H + J; G =  alpha * H + J;
t = [A; F; D; C; E; G; B]; t = t(:);

% function evaluations
y = fcn([A, F, D, C, E, G, B]); fcnEvals = 7 * m;

% avoid infinities at start point of interval
if any(~isfinite(y(:,1)))
  y(:,1) = fcn(a + eps(superiorfloat(a,b)) * (b - a));
  fcnEvals = fcnEvals + 1;
  poleWarning = 1;
end

% avoid infinities at end point of interval
if any(~isfinite(y(:, end)))
  y(:, end) = fcn(b - eps(superiorfloat(a,b)) * (b - a));
  fcnEvals = fcnEvals + 1;
  poleWarning = 1;
end

% poles at initial points
if ~isempty(find(~isfinite(max(abs(y))))), poleWarning = 1; end

% hand over function values
yA = y(:,     1 :   m); yF = y(:,   m+1 : 2*m); yD = y(:, 2*m+1 : 3*m);
yC = y(:, 3*m+1 : 4*m); yE = y(:, 4*m+1 : 5*m); yG = y(:, 5*m+1 : 6*m);
yB = y(:, 6*m+1 : end);

% dimension of parallel integration
n = size(yA,1);

% adaptive Lobatto iteration
while 1

  % number of iteration
  iter = iter + 1;

  % four point Lobatto formula
  Q1 = kron(H, ones(n,1)) / 6 .* (yA + 5 * (yD + yE) + yB);
  % seven point Kronrod formula
  Q2 = kron(H, ones(n,1)) / 1470 .* (77 * (yA + yB) + 432 * (yF + yG) + 625 * (yD + yE) + 672 * yC);

  % difference of Lobatto formulas
  diffQ = Q2 - Q1; diffQ(find(isnan(diffQ))) = 0;

  % intervals which do not fulfill termination criterion
  idx = find(max(abs(diffQ), [], 1) > tol);

  % intervals fulfill termination criterion
  idxQ = setdiff(1:length(A), idx);

  % check stop criterions
  STOP1 = isempty(idx); % check regular termination
  STOP2 = fcnEvals > maxFcnEvals;  % check maximal function evaluations
  STOP3 = 5 * length(idx) > maxParts; % check maximal partition

  % regular termination
  if STOP1
    Q = Q + sum(Q2, 2);
    break
  end

  % check if maximal resolution reached
  idxH = find(abs(H) < minH);
  if ~isempty(idxH)
    Q = Q + sum(Q2(idxH), 2);
    idx = setdiff(idx, idxH);
    idxQ = setdiff(idxQ, idxH);
    maxResolution = 1;
    % termination criterion
    if isempty(idx), break, end
  end

  % maximal function evaluations reached
  if STOP2
    warning('Matlab:adaptiveLobatto:MaxEvaluations',...
      'The maximal number of function evaluations reached; singularity likely.')
    Q = Q + sum(Q2, 2);
    break
  end

  % maximal partition reached
  if STOP3
    warning('Matlab:adaptiveLobatto:parts',...
      'The maximal number of parts reached.')
    Q = Q + sum(Q2, 2);
    break
  end

  % update quadrature value
  Q = Q + sum(Q2(:,idxQ) + diffQ(:,idxQ) / 15, 2);

  % number of intervals
  m = 6 * length(idx);

  % initialize t
  t = zeros(1, 6 * length(idx));

  % hand over new start points A
  t(1:6:end) = A(idx); t(2:6:end) = F(idx); t(3:6:end) = D(idx);
  t(4:6:end) = C(idx); t(5:6:end) = E(idx); t(6:6:end) = G(idx);
  A = t;

  % hand over new end points B
  t(1:6:end) = F(idx); t(2:6:end) = D(idx); t(3:6:end) = C(idx);
  t(4:6:end) = E(idx); t(5:6:end) = G(idx); t(6:6:end) = B(idx); 
  B = t;

  y = zeros(n, 6 * length(idx));
  % hand over new start values A
  y(:,1:6:end) = yA(:,idx); y(:,2:6:end) = yF(:,idx); y(:,3:6:end) = yD(:,idx);
  y(:,4:6:end) = yC(:,idx); y(:,5:6:end) = yE(:,idx); y(:,6:6:end) = yG(:,idx);
  yA = y;

  % hand over new end values B
  y(:,1:6:end) = yF(:,idx); y(:,2:6:end) = yD(:,idx); y(:,3:6:end) = yC(:,idx);
  y(:,4:6:end) = yE(:,idx); y(:,5:6:end) = yG(:,idx); y(:,6:6:end) = yB(:,idx); 
  yB = y;

  % widths and midpoints of intervals
  H = (B - A) / 2; J = (A + B) / 2;

  % calculate new mid points
  F = -alpha * H + J; D = -beta * H + J; C =  J;
  E =  beta * H + J; G =  alpha * H + J;

  % function evaluations
  y = fcn([F, D, C, E, G]); fcnEvals = fcnEvals + 5 * m;

  % poles at new points
  if ~isempty(find(~isfinite(max(abs(y))))), poleWarning = 1; end

  % hand over new midpoint values of F D C E and G
  yF = y(:,     1 :   m); yD = y(:,   m+1 : 2*m); yC = y(:, 2*m+1 : 3*m); 
  yE = y(:, 3*m+1 : 4*m); yG = y(:, 4*m+1 : 5*m);

end

% display warnings
if any(~isfinite(Q))
  warning('Matlab:adaptiveLobatto:Infinite',...
    'The Quadrature of the function reached infinity or is Not-a-Number.')
end
if maxResolution
  warning('Matlab:adaptiveLobatto:MaxResolution',...
    'The maximal resolution of partial interval reached; singularity likely.')
end
if poleWarning
  warning('Matlab:adaptiveLobatto:PoleDetection',...
    'A detection of a pole; singularity likely.')
end

return

% substitute function interval [-inf, 0] on [0, 1]
function f = infiniteLeft(t, fcn)
f = fcn(log(t));
f = f ./ kron(ones(size(f,1),1), t);
return

% substitute function interval [0, inf] on [0, 1]
function f = infiniteRight(t, fcn)
f = fcn(-log(t));
f = f ./ kron(ones(size(f,1),1), t);
return

% substitute function interval [-inf, inf] on [-pi / 2, pi / 2]
function f = infiniteBoth(t, fcn)
f = fcn(tan(t));
f = f ./ kron(ones(size(f,1),1), cos(t).^2);
return