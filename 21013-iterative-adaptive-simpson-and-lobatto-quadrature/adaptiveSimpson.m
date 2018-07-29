function [Q fcnEvals iter] = adaptiveSimpson(fcn, a, b, varargin)
% adaptiveSimpson - Numerically evaluate integral, adaptive Simpson quadrature. 
%
% function [Q fcnEvals iter] = adaptiveSimpson(fcn, a, b, varargin)
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
%   The adaptive Simpson algorithm programmed in an iterative not recursive
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
%     Q = adaptiveSimpson(@(x) [-cos(50*x); sin(x)], 0, pi, 'tol', 1e-6)
%
% References:
%   [1] Gander, W. & Gautschi, W. Adaptive Quadrature - Revisited
%       Eidgenoessische technische Hochschule Zuerich, 2000.

% check scalar limits of interval
if ~isscalar(a) || ~isscalar(b)
  error('Matlab:adaptiveSimpson:Limits',...
    'The limits of integration must be scalars.');
end

% default values
tol = 1e-6; parts = 2; maxFcnEvals = 20000; maxParts = 8000;

% rewrite default options if needed
for j = 1 : length(varargin) / 2
  eval([varargin{2 * j - 1},'=varargin{',int2str(2 * j),'};']);
end

% initial values, termination constant (incl. quadr factor 15), parts of interval and integral value
tol = 15 * tol; m = parts;  parts = 4 * parts + 1; Q = 0;
iter = 0; fcnEvals = 0; maxResolution = 0; minH = eps(b - a) / 1024;
poleWarning = 0;

% check if interval has infinite boundaries, in case substitute function
if ~isfinite(a) || ~isfinite(b)
  warning('Matlab:adaptiveSimpson:infiniteInterval',...
    'The integral has an infinite interval; proceed with a substitution of function on finite interval.')
  if ~isfinite(a) && isfinite(b)
    [Q fcnEvals iter] = adaptiveSimpson(fcn, 0, b, varargin);
    fcn = @(t) infiniteLeft(t, fcn);
    a = 0; b = 1;
  elseif isfinite(a) && ~isfinite(b)
    [Q fcnEvals iter] = adaptiveSimpson(fcn, a, 0, varargin);
    fcn = @(t) infiniteRight(t, fcn);
    a = 0; b = 1;
  else
    fcn = @(t) infiniteBoth(t, fcn);
    a = - pi / 2; b = pi / 2;
  end
end

% choice of initial evaluation points
t = [a + (b - a) / m * (kron(ones(1,m), [0, 0.27158, 0.72842]) + kron(0: m - 1, [1 1 1])), b];
H = diff(t);
t = [t(1:end-1); t(1:end-1) + H/4; t(1:end-1) + H/2; t(1:end-1) + 3 * H/4;];
t = [t(:);b]';

% initialize equidistant mesh and dimension of fcn
y = fcn(t); fcnEvals = fcnEvals + length(y); n = size(y,1);

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

% initialize interval boundaries and values
A = t(1:4:end-1); yA = y(:, 1:4:end-1);
B = t(5:4:end);   yB = y(:, 5:4:end);
C = t(3:4:end-1); yC = y(:, 3:4:end-1);
D = t(2:4:end-1); yD = y(:, 2:4:end-1);
E = t(4:4:end-1); yE = y(:, 4:4:end-1);

% adaptive Simpson iteration
while 1

  % number of iteration
  iter = iter + 1;

  % Simpson formulas (on rough and fine grid)
  Q1 = kron(H, ones(n,1)) / 6 .* (yA + 4 * yC + yB);
  Q2 = kron(H, ones(n,1)) / 12 .* (yA + 4 * yD + 2 * yC + 4 * yE + yB);

  % difference of Simpson formulas
  diffQ = Q2 - Q1; diffQ(find(isnan(diffQ))) = 0;

  % intervals which do not fulfill termination criterion
  idx = find(max(abs(diffQ), [], 1) > tol);

  % intervals fulfill termination criterion
  idxQ = setdiff(1:length(A), idx);

  % check stop criterions
  STOP1 = isempty(idx); % check regular termination
  STOP2 = fcnEvals > maxFcnEvals;  % check maximal function evaluations
  STOP3 = 2 * length(idx) > maxParts; % check maximal partition

  % regular termination
  if STOP1
    Q = Q + sum(Q2 + diffQ / 15, 2);
    break
  end

  % check if maximal resolution reached
  idxH = find(abs(H) < minH);
  if ~isempty(idxH)
    Q = Q + sum(Q2(idxH) + diffQ(idxH) / 15, 2);
    idx = setdiff(idx, idxH);
    idxQ = setdiff(idxQ, idxH);
    maxResolution = 1;
    % termination criterion
    if isempty(idx), break, end
  end

  % maximal function evaluations reached
  if STOP2
    warning('Matlab:adaptiveSimpson:MaxEvaluations',...
      'The maximal number of function evaluations reached; singularity likely.')
    Q = Q + sum(Q2 + diffQ / 15, 2);
    break
  end

  % maximal partition reached
  if STOP3
    warning('Matlab:adaptiveSimpson:parts',...
      'The maximal number of parts reached.')
    Q = Q + sum(Q2 + diffQ / 15, 2);
    break
  end

  % update quadrature value
  Q = Q + sum(Q2(:,idxQ) + diffQ(:,idxQ) / 15, 2);

  % update A, B, and C
  t = zeros(1, 2*length(idx));
  t(1:2:end) = A(idx); t(2:2:end) = C(idx); A = t;
  t(1:2:end) = C(idx); t(2:2:end) = B(idx); B = t;
  t(1:2:end) = D(idx); t(2:2:end) = E(idx); C = t;

  % update yA, yB, and yC
  y = zeros(n, 2*length(idx));
  y(:,1:2:end) = yA(:,idx); y(:,2:2:end) = yC(:,idx); yA = y;
  y(:,1:2:end) = yC(:,idx); y(:,2:2:end) = yB(:,idx); yB = y;
  y(:,1:2:end) = yD(:,idx); y(:,2:2:end) = yE(:,idx); yC = y;

  % update interval length
  H = B - A;

  % update D and E by interval bisection
  D = (A + H / 4); E = (A + 3 * H / 4);

  % calculate yD and yE
  y = fcn([D,E]); fcnEvals = fcnEvals + 4 * length(idx);

  % poles at new points
  if ~isempty(find(~isfinite(max(abs(y))))), poleWarning = 1; end

  % assign new values ob yD and yE
  yD = y(:,1:end/2); yE = y(:,end/2+1: end);

end

% display warnings
if any(~isfinite(Q))
  warning('Matlab:adaptiveSimpson:Infinite',...
    'The Quadrature of the function reached infinity or is Not-a-Number.')
end
if maxResolution
  warning('Matlab:adaptiveSimpson:MaxResolution',...
    'The maximal resolution of partial interval reached; singularity likely.')
end
if poleWarning
  warning('Matlab:adaptiveSimpson:PoleDetection',...
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