function [Yq, Xq, MSE, Entropy, SNRdB, sdV] = QuantUnif (Nlev, FPDF, Sym)
% Find a uniform minimum mean square error quantizer.
%
% This subroutine searches for a uniform quantizer which minimizes the
% mean square quantization error. It returns the quantizer decision levels
% and output levels. A uniform quantizer is by our definition, one which
% has equally spaced output levels. Given those output levels, the
% MMSE quantizer has decision levels which fall midway between the output
% levels, and so are also equally spaced.
% Nlev - Number of quantizer output levels
% FPDF - Cell array of function handles {Farea, Fmean, Fvar}
% Farea - Pointer to a function to calculate the integral of a probability
%   density function in an interval.
%                 b
%   Farea(a,b) = Int p(x) dx,
%                 a
%   where (a,b) is the interval and p(x) is the probability density
%   function.
% Fmean - Pointer to a function to calculate the mean of a probability
%   density function in an interval.
%                 b
%   Fmean(a,b) = Int x p(x) dx,
%                 a
%   where (a,b) is the interval and p(x) is the probability density
%   function.
% Fvar - Pointer to a function to calculate the second moment of a
%   probability density function in an interval.
%                b
%   Fvar(a,b) = Int x^2 p(x) dx,
%                a
%   where (a,b) is the interval and p(x) is the probability density
%   function.
% Sym - Logical flag. If true, the quantizer is required to be symmetric
%   about the mean. For symmetric quantizers, the probability density is
%   assumed to be symmetric about its mean.
%
% Yq - Nlev quantizer output levels (in ascending order)
% Xq - Nlev-1 quantizer decision levels (in ascending order)
% MSE - Resulting mean square error
% Entropy - Resulting entropy (bits)
% SNRdB - Resulting signal-to-noise ratio dB

Farea = FPDF{1};
Fmean = FPDF{2};

% Parameter
TolP = 1e-8;    % Symmetry check tolerance

% Consistency check
if (Sym)
  Xmean = feval(Fmean, -Inf, Inf);
  PH = feval(Farea, Xmean, Inf);
  if (abs(PH - 0.5) > TolP)
    fprintf('QuantUnif: Warning, PDF is not symmetric\n');
  end
end

% Find a minimum mean square error uniform quantizer
Yq = QuantUOpt(Nlev, FPDF, Sym);

% Generate the quantizer decision levels
if (Nlev > 1)
  Xq = 0.5 * (Yq(1:end-1) + Yq(2:end)); 
else
  Xq = [];
end

% Calculate the MSE and entropy
if (nargout > 2)
  [MSE, Entropy, SNRdB, sdV] = QuantSNR(Yq, Xq, FPDF);
end

return

% ----- -----
function [Yq, Nzero] = QuantUOpt (Nlev, FPDF, Sym)
% Invoke a general search procedure to find the minimum
% mean square error uniform quantizer.
%
% The quantizer is defined by its output levels. The decision levels lie
% midway between output levels. Since the decision levels are equally spaced,
% the output levels are entirely defined by the midpoint of the quantizer and
% and quantizer step size.
%
% Nlev - Number of quantizer output levels. For symmetric quantizers
%   this is the number of levels above the mean.
% FPDF - Cell array of function pointers {Farea, Fmean, Fvar}
% Sym - Symmetry flag (optional, default false)
%
% Yq - Nlev output levels in ascending order
% Nzero - Number of intervals with zero probability

% Parameters
MaxIter = 6;

if (nargin < 3)
  Sym = false;
end

Farea = FPDF{1};
Fmean = FPDF{2};
Fvar = FPDF{3};

% Set the optimization parameters
Xmean = feval(Fmean, -Inf, Inf);
sd = feval(Fvar, -Inf, Inf) - Xmean^2;

% Convergence criteria
TolFun = sd^2 * 1e-6;
TolX = sd * 1e-6;
Options = optimset('TolFun', TolFun, 'TolX', TolX);

% Initialization
% The symmetric case is recognized in UnifQ by whether it is called
% by a one or a two element input.
V0(1) = 2 * sd / Nlev;
if (~Sym)
  V0(2) = Xmean;
end

for (Iter = 1:MaxIter)

% Search
  V = fminsearch(@UnifQ, V0, Options, Nlev, FPDF);

% Generate a set of uniform output values
  dY = V(1);
  if (~Sym)
    Yctr = V(2);
  else
    Yctr = Xmean;
  end
  [Yq, Xq] = GenUQuant(Nlev, dY, Yctr);

% Test for zero probability intervals
  Nzero = NzeroProb(Xq, Farea);
  if (Nzero > 0 || Iter > 1)
    fprintf('QuantUOpt: %d/%d intervals have zero probability\n', ...
            Nzero, Nlev);
  end
  if (Nzero == 0)
    break
  end

% Increase the step size for the next iteration
% If Nzero full intervals, the actual zero interval is
%   Nzero*dY < dZ < (Nzero+2)*dY
  V0(1) = Nlev/(Nlev-Nzero-1) * dY;
  
end

return

% ----- -----
function MSE = UnifQ(V, Nlev, FPDF)
% Function to be minimized

Fmean = FPDF{2};

NV = length(V);
dY = V(1);      % Step size
if (NV == 1)
  Yctr = feval(Fmean, -Inf, Inf);
else
  Yctr = V(2);
end

% Generate a set of uniform output values
[Yq, Xq] = GenUQuant(Nlev, dY, Yctr);

MSE = QuantMSE(Yq, Xq, FPDF);

return

% ----- -----
function [Yq, Xq] = GenUQuant (Nlev, dY, Yctr)
% Generate a set of uniform quantizer output values
%  Nlev - Number of quantizer output levels
%  dY - Quantizer step size (optional, default 1)
%  Yctr - Mean of the quantizer output levels (optional, default 0)
%
%  Xq - Quantizer decision levels (Nlev-1 values)
%  Yq - Quantizer output levels (Nlev values)
if (nargin <= 2)
  Yctr = 0;
end
if (nargin <= 1)
  dY = 1;
end

Yq = ((0:Nlev-1) - (Nlev-1)/2) * dY + Yctr;
if (Nlev > 1)
  Xq = 0.5 * (Yq(1:end-1) + Yq(2:end));
else
  Xq =[];
end

return

% ----- -----
function Nzero = NzeroProb (Xq, Farea)

Nlev = length(Xq)+1;
Nzero = 0;
XL = -Inf;
for (i = 1:Nlev)
  if (i == Nlev)
    XU = Inf;
  else
    XU = Xq(i);
  end
  Area = feval(Farea, XL, XU);
  if (Area <= 0)
    Nzero = Nzero + 1;
  end
  XL = XU;
end

return
