function [Yq, Xq, MSE, Entropy, SNRdB] = QuantOpt (Nlev, FPDF, Sym)
% Find a non-uniform minimum mean square error quantizer.
%
% This subroutine searches for a quantizer which minimizes the mean
% square quantization error. It returns the quantizer decision levels
% and output levels that satisfy the necessary conditions for a
% minimum mean square error quantizer.
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

Farea = FPDF{1};
Fmean = FPDF{2};

% Parameters
TolP = 1e-8;    % Symmetry check tolerance

% Consistency check
if (Sym)
  Xmean = feval(Fmean, -Inf, Inf);
  PH = feval(Farea, Xmean, Inf);
  if (abs(PH - 0.5) > TolP)
    fprintf('QuantOpt: Warning, PDF is not symmetric\n');
  end
end

% Symmetry conditions
if (~Sym)
  NlevH = Nlev;
  QSym = 0;
elseif (mod(Nlev,2) == 0)
  NlevH = Nlev/2;
  QSym = 2;
else
  NlevH = (Nlev-1)/2;
  QSym = 1;
end

% Find a minimum mean square error quantizer
Yq = QuantLloyd(NlevH, FPDF, QSym);

% Refine the solution
Yq = QuantRefine(Yq, FPDF, QSym);

% Fill in all of the levels for symmetrical distributions
if (QSym == 1)
  Yq = [(Xmean-fliplr(Yq)) Xmean Yq];
elseif (QSym == 2)
  Yq = [(Xmean-fliplr(Yq)) Yq];
end

% Generate the quantizer decision levels
if (Nlev > 1)
  Xq = 0.5 * (Yq(1:end-1) + Yq(2:end)); 
else
  Xq = [];
end

% Calculate the MSE and entropy
if (nargout > 2)
  [MSE, Entropy, SNRdB] = QuantSNR(Yq, Xq, FPDF);
end
  
return
