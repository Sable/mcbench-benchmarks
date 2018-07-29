function Yq = QuantRefine (Yq, FPDF, QSym)
% Iterate to find the output levels for a MMSE quantizer.
%
% This subroutine searches for a set of quantizer output levels which are
% the conditional means (centroids) of the quantizer decision regions. The
% decision boundaries are assumed to lie mid-way between output levels.
%
% Given a set of initial quantizer output levels, the mean square error can
% be minimized by choosing the decision levels to be midway between output
% levels. Given a set of decision levels, the MSE can be minimized by
% choosing the output levels to be the centroids of the intervals between
% decision levels. The iteration involves alternately adjusting the
% decisions levels and the output levels. At each step, the MSE will be
% non-increasing. This is the Method I iteration proposed by Lloyd.
%   S. P. Lloyd, "Least Squares Quantization in PCM", IEEE Trans. Inform.
%     Theory, vol. 28, no. 2, pp. 129-137, March 1982.

% Yq - Initial Nlev quantizer output levels in ascending order
% FPDF - Cell array of function pointers {Farea, Fmean, Fvar}
% QSym - Symmetry flag, optional (default 0)
%   0 - Quantizer not constrained to be symmetric
%   1 - Quantizer is symmetric with an odd number of levels. The middle
%       level is fixed at the mean. This routine finds the Nlev output
%       levels above the mean.
%   2 - Quantizer is symmetric with an even number of levels. The middle
%       decision level is at the mean. This routine finds the Nlev output
%       levels above the mean.
%
% Yq - Final Nlev quantizer output levels in ascending order

if (nargin < 3)
  QSym = 0;
end

Farea = FPDF{1};
Fmean = FPDF{2};
Fvar = FPDF{3};

% Parameters
MaxIter = 4000;
TolR = 1e-6;

% Find the standard deviation
Xmean = feval(Fmean, -Inf, Inf);
sd = sqrt(feval(Fvar, -Inf, Inf) - Xmean^2);

dMSE = 0;
Nzero1 = 0;
dXTol = TolR * sd;
Xmean = feval(Fmean, -Inf, Inf);
Nlev = length(Yq);

for (Iter = 1:MaxIter)

% Initialization for the first interval
  dMSEp = dMSE;
  Nzero = 0;
  dX = 0;
  dMSE = 0;

  if (QSym == 0)
    XL = -Inf;
  elseif (QSym == 1)
    XL = 0.5 * (Xmean + Yq(1));
% Add MSE contribution of the half interval from the mean to
% the first decision level
    Yc = Xmean;     % Output level at the mean
    Area = feval(Farea, Yc, XL);
    Avg = feval(Fmean, Yc, XL);
    dMSE = Yc * (2 * Avg - Yc * Area);
  elseif (QSym == 2)
    XL = Xmean;
  end

% -----
  for (i = 1:Nlev)

% Find the upper decision level
    if (i < Nlev)
      XU = 0.5 * (Yq(i+1) + Yq(i));
    else
      XU = Inf;
    end
    Area = feval(Farea, XL, XU);

% If the probability of the interval is zero, the output level is
% placed at the edge of the interval nearest the mean to move the
% output level towards a region with non-zero probability
    if (Area < 0)
      error('QuantRefine: Negative interval area');

    elseif (Area == 0)

      Nzero = Nzero + 1;
      if (abs(XL - Xmean) < abs(XU - Xmean))
        Yc = XL;
      else
        Yc = XU;
      end

    else

% Choose the output level to be the centroid of the interval
      Avg = feval(Fmean, XL, XU);
      Yc = Avg / Area;

% Accumulate the decrease in mean square error (relative to a one level
% quantizer placed at the mean) due to each quantizer interval. The MSE can
% be expressed as var(p(x))-dMSE. For symmetric quantizers, dMSE is the
% decrease in MSE for the intervals above the mean (the full dMSE is twice
% the value calculated).
      dMSE = dMSE + Yc * (2 * Avg - Yc * Area);
    end

% Find the maximum (relative / absolute) change in this iteration
    dX = max(dX, abs(Yc - Yq(i)) / max(1, abs(Yq(i))));

% Determine the next decision level and set the output level
% There are several ways to go here.
% (1) Adjust all output levels using the decision levels based on the
%     original output levels. The decision levels will get updated on the
%     next iteration cycle.
% (2) As an output level gets set, modify the decision level at the upper
%     end. This will affect the output level of the next interval in the
%     same iteration cycle.
% (Non-exhaustive) tests seem to show method (1) is best for non-symmetric
% quantizers where we move from outer levels to inner levels to outer
% levels, while method (2) is best for symmetic quantizers where we move
% from inner levels to outer levels. We opt for method (1) because we can
% calculate dMSE with essentially no additional cost and use this value as
% a safety net to halt the iterations when dMSE no longer changes.
%   XL = 0.5 * (Yq(i+1) + Yq(i)); % Method (1)
%   XL = 0.5 * (Yq(i+1) + Yc);    % Method (2)
    XL = XU;
    Yq(i) = Yc;

  end
% -----

  if (Iter == 1)
    Nzero1 = Nzero;
  end

% Check for convergence
  if (Nzero == 0 && (dX < dXTol || dMSE <= dMSEp))
    break
  end

end

if (Iter == MaxIter)
  fprintf('QuantRefine: Maximum iteration count reached\n');
end

if (dX < dXTol)
  fprintf('QuantRefine: Converged, %d iterations:', Iter);
  fprintf(' level changes less than threshold\n');
end
if (dMSE <= dMSEp)
  fprintf('QuantRefine: Converged, %d iterations:', Iter);
  fprintf(' MSE not decreasing\n');
end
if (Nzero1 > 0)
  fprintf('QuantRefine: %d zero probability interval(s) initially\n', Nzero1);
  fprintf('QuantRefine: %d zero probability interval(s) remain\n', Nzero);
end

return
