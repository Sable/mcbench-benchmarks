function Yq = QuantLloyd (Nlev, FPDF, QSym)
%  Iterate to find the output levels for a minimum mean square error
%  quantizer.
%
% This subroutine searches for a set of quantizer output levels which are
% the conditional means (centroids) of the quantizer decision regions. The
% decision boundaries are assumed to lie mid-way between output levels.
%
% The procedure is based on a Lloyd-Max iteration.
% (1) Given the start of an interval and an output level, find the end of
%     the interval, such that the output level is the centroid of the
%     probability density function in that interval.
% (2) Use the output level and upper interval edge to find the output
%     level in the next interval (the interval edge must lie midway
%     between output levels).
% (3) With the start and output level of the next interval
%     determined, repeat step (1) for this interval.
% The iteration continues by modifying the initial output level based
% on whether the centroid property of the last interval was satisfied.
%    S. P. Lloyd, "Least Squares Quantization in PCM", IEEE Trans. Inform.
%      Theory, vol. 28, no. 2, pp. 129-137, March 1982.
%    J. Max, "Quantizing for Minimum Distortion", IEEE Trans. Inform.
%      Theory, vol. 6, no. l, pp. 7-12, March 1960.
%
% Nlev - Number of quantizer output levels. For symmetric quantizers
%   this is the number of levels above the mean.
% FPDF - Cell array of function pointers {Farea, Fmean, Fvar}
% QSym - Symmetry flag (optional, default 0)
%   0 - Quantizer not constrained to be symmetric
%   1 - Quantizer is symmetric with an odd number of levels. The middle
%       level is fixed at the mean. This routine finds the Nlev output
%       levels above the mean.
%   2 - Quantizer is symmetric with an even number of levels. The middle
%       decision level is at the mean. This routine finds the Nlev output
%       levels above the mean.
%
% Yq - Nlev output levels in ascending order

% There are 3 symmetry cases to consider for symmetry
% QSym == 0: No symmetry. The first interval is defined by a lower
%   boundary XL = -Inf and an output level (centroid) Yc. The centroid
%   position is iterated.
% QSym == 1: Symmetrical quantizer with fixed output level at the mean.
%   If we place another output level Yc, the decision level XL lies
%   midway between the mean and Yc. When we iterate Yc, the decision level
%   is also be readjusted.
% QSym == 2: Symmetric quantizer with a decision boundary XL at the mean.
%   The output level Yc is iterated. 

if (nargin < 3)
  QSym = 0;
end

Fmean = FPDF{2};
Fvar = FPDF{3};

% Parameters
MaxIter = 100;
TolR = 1e-5;

% Set the optimization parameters
Xmean = feval(Fmean, -Inf, Inf);
sd = feval(Fvar, -Inf, Inf) - Xmean^2;

% Convergence criterion
Tol = TolR * sd;

if (QSym == 0)                  % No symmetry
  XL = -Inf;
  Yc = Xmean - 4 * sd;
  Xstep = sd;
elseif (QSym == 1)              % Symmetric, odd number of coefficients
  Xstep = 2 * sd / Nlev;
  Yc = Xmean + Xstep;
  XL = 0.5 * (Xmean + Yc);
elseif (QSym == 2)              % Symmetric, even number of coefficients
  Xstep = 2 * sd / Nlev;
  XL = Xmean;
  Yc = Xmean + Xstep;
end

% Initialization
Ytrial = Yc;
Ybase = Yc;
Xstep = 0.5 * Xstep;
FL = false;         % True if an upper bound has been found
FU = false;         % True if a lower bound has been found

for (Iter = 1:MaxIter)

% Find a set of output levels satisfying the necessary conditions
% for a minimum mean square error quantizer
% XU is the largest quantizer decision level
%  Yc = Ytrial;
  if (QSym == 1)
    XL = 0.5 * (Xmean + Ytrial);
  end

  [Yq, XU] = QuantLevel(Nlev, FPDF, XL, Ytrial);
  
  if (isnan(XU) || Yq(end) == XU)
    FU = true;
  else
    FL = true;
    Ybase = Ytrial;
  end

% Check for convergence, adjust the step size
  if (FL && FU)
    if (Xstep < Tol)
      break
    end
    Xstep = 0.5 * Xstep;
    Ytrial = Ybase + Xstep;
  elseif (FL)     % Need to extend the search upward
    Xstep = 2 * Xstep;
    Ytrial = Ybase + Xstep;
  else            % Need to back up the initial value
    Ybase = Ytrial;
    Xstep = 2 * Xstep;
    if (~isinf(XL))
      Xstep = min(Xstep, 0.5*(Ybase - XL)); % Don't step below XL
    end
    Ytrial = Ybase - Xstep;
  end

end

if (Iter >= MaxIter)
  error('QuantLloyd: Failed to converge');
end
if (~FU || ~FL)
  error('QuantLloyd: Feasible solution not found');
end
fprintf('QuantLloyd: Converged, %d iterations\n', Iter);

return

% ----- -----
function [Yq, XU] = QuantLevel(Nlev, FPDF, XL, Yc)
% Find a set of quantizer output levels, given the lower boundary and
% centroid of the first interval.
%
% Given the lower boundary (decision level) for an initial interval and the
% output level (centroid) of that interval, this routine first finds the
% upper decision boundary for that interval. These values are telescoped to
% give the lower boundary and output level for the second interval. This
% process continues for each interval.
%
% The last decision level is returned by this routine. If this value is
% finite, the last interval does not fully encompass the tail of the
% probability density function. If the last decision level is NaN, the last
% output level is not the centroid of the last region extenting to infinity.
%
% Nlev - Number of quantizer output levels. For symmetric quantizers this
%   is the number of levels above the mean.
% FPDF - Cell array of function handles {Farea, Fmean, Fvar}
% XL - Lower boundary of the first interval
% Yc - Centroid of the first interval
%
% Yq - Nlev quantizer output levels in ascending order. Trailing values may
%   be NaN if it is not possible to have intervals with these output levels
%   as the centroids of the corresponding intervals. The quantizer decision
%   levels lie midway between output levels. 
% XU - Largest decision level (greater than or equal to Yq(Nlev)) or
%   NaN.

% If XU is finite, then the levels should be adjusted upward (increase
% Yc). If XU is NaN, the last output level is not the centroid of the last
% interval, and the levels should be adjusted downward. Another case occurs
% if an entire interval is zero probability. Then the upper decision level
% falls on the output level for that interval. Test for XU == Yq(Nlev).

Yq = zeros(1, Nlev);
for (i = 1:Nlev)

% Given the lower decision level and the output level for an interval,
% find the upper decision level
  if (isnan(XL))
    XU = XL;
    Yc = XL;
  else
    XU = QuantInterval(FPDF, XL, Yc);
  end

% Given the interval limits just found, telescope to find the
% output level to be used in the next iteration
  Yq(i) = Yc;
  XL = XU;
  Yc = XU + (XU - Yc);

end

return

% ----- ------
function Xb = QuantInterval (FPDF, Xa, Yc)
% Find the upper edge of an interval which has a given centroid.
%
% This routine solves for upper limit of the integral
%    Xb
%   Int (x-Yc) p(x) dx = 0.
%    Xa
%
% The routine is designed to allow for Yc to be less than Xa, in which case
% Xb <= Yc, or for Yc to be greater than Xa, in which case Xb >= Yc.
%
% FPDF - Cell array of function handles {Farea, Fmean, Fvar}
% Xa - Lower boundary of the interval
% Yc - Centroid of the interval
%
% Xb - Returned value representing the upper boundary of the interval. This
%   value is set to NaN if there is no solution for Xb on the opposite side
%   of Yc from Xa.

% Parameters
XstepR = 1.2;    % Initial relative step size
TolF = 1e-5;     % Function amplitude relative tolerance
TolX = 1e-5;     % Position relative tolerance
MaxIter = 100;
EpsdF = 0.01;    % Choose between bisection or linear interpolation
EpsdX = 0.05;    % For linear interpolation, constrain the relative
                 % step size to EpsdX <= dX <= 1-EpsdX.

% Searching for a solution of the equation F(Xb) = 0. Consider the
% case that Yc > Xa. The function F(Xb) is zero at Xb = Xa. It becomes
% negative with increasing Xb (since p(x) is positive). It takes on its
% most negative value at Xb = Yc. It then decreases as Xb increases. It
% is the second zero crossing we seek.

% The search procedure has as its stopping criteria:
%  a) abs(F(Xb) < TolF*abs(F(YC)).
%  b) The interval of uncertainty is less than TolX*abs(Xb)
%  c) The probability from the present trial point to Inf or -Inf (as
%     appropriate) is zero. In this case Xb is set to NaN.
%  d) The maximum number of iterations is exceeded.
%  e) F(Yc)=0. This indicates that the probability density function is
%     zero in the interval (Xa,Yc).

if (Yc == Xa)
  Xb = Yc;
  return
end

Farea = FPDF{1};
Fmean = FPDF{2};
Fvar = FPDF{3};

% Evaluate the function at Yc to check if the probability
% is zero, and to determine the stopping criterion Feps
Fm = feval(Fmean, Xa, Yc) - Yc*feval(Farea, Xa, Yc);  % Should be negative
if (Fm >= 0)
  if (Fm > 0)
    error('QuantInterval: Error, function value at centroid positive');
  end
  Xb = Yc;          % Fm == 0;
  return
end

% Set up the boundaries of the search and the step size
FL = Fm;            % Value at lower boundary (initially negative)
XL = Yc;            % Lower boundary of search
if (~isinf(Xa))

  Xb = Yc + XstepR * (Yc - Xa);  % Initial trial upper boundary

else

% Find the standard deviation of the distribution
  Xmean = feval(Fmean, -Inf, Inf);
  sd = sqrt(feval(Fvar, -Inf, Inf) - Xmean^2);
  Xb = Yc + sign(Yc-Xa) * sd;   % Initial test upper boundary
end

FR = -1;            % Same sign as FL to indicate no zero found
XR = Xb;
Feps = TolF * abs(Fm); % Tolerance on integral value
Xstep = 0.5 * (Xb - Yc);

% Search loop
for (Iter = 1:MaxIter)

  Fp = Fm;          % Previous Fm
  Fm = feval(Fmean, Xa, Xb) - Yc*feval(Farea, Xa, Xb);

% Update the end-points of the search
if (Fm >= 0)
  FR = Fm;
  XR = Xb;
else
  FL = Fm;
  XL = Xb;
end

% ----- ------
  if (FR >= 0)
% Straddling a root

% Check for convergence in the function value
% Check for convergence of the position
    if (abs(Fm) <= Feps) || ...
       (~isinf(XL) && ~isinf(XR) && ...
        abs(XR-XL) <= TolX*max(abs(XR), abs(XL)))
      return
    end

% The root location is sought by cautious linear interpolation; however
% if successive function values are nearly equal, bisection is used.
    if (abs(Fp-Fm) > EpsdF * abs(FL-FR))
      dX = FL / (FL-FR);    % Estimated zero crossing position
      dX = max(min(dX, 1-EpsdX), EpsdX); % Avoid region close to XL or XR
    else
      dX = 0.5;             % Bisection
    end
    Xb = XL + dX*(XR-XL);

% ------ ------
  else
% Not straddling a root

% Right boundary undefined
% Check for successive identical returned values
    if (Yc > Xa)
      if (Fm == Fp && feval(Farea, Xb, Inf) <= 0)
        Xb = NaN;
        return
      end
    else
      if (Fm == Fp && feval(Farea, -Inf, Xb) <= 0)
        Xb = NaN;
        return
      end
    end

% Increase the step size
    Xb = Xb + Xstep;
    Xstep = 2 * Xstep;

  end

end

error('QuantInterval: Failed to converge');
