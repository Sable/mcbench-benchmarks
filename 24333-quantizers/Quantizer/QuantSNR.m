function [MSE, Entropy, SNRdB, sdV] = QuantSNR (Yq, Xq, FPDF, ScaleF)
% Calculate the SNR (dB) for a quantizer defined by a table for a
% signal with a given probability density function.
%
% Yq - Nlev quantizer output levels (in ascending order)
% Xq - Nlev-1 quantizer decision levels (in ascending order)
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
% ScaleF - Scaling factor for the signal (optional, default 1)

% MSE - Resulting mean square error
% Entropy - Resulting entropy (bits)
% SNRdB - Resulting signal-to-noise ratio dB
% sdV - Peak to average ratio for the quantizer. The peak level (overload)
%   V of the quantizer is defined here as the the distance from the mean to
%   the largest output level plus a half step size. Then
%     sdV = sd / V,
%   where sd is the standard deviation of the signal.

if (nargin <= 3)
  ScaleF = 1;
end

% The scale factor represents a scaling of the signal
% For convenience we scale the quantizer by 1/ScaleF and later multipy
% the computed MSE by ScaleF^2 achieve the same effect as scaling the
% signal

% Quantizers are really a combination of two operations
%  - determine an interval k, such that Xq(k-1) <= x < Xq(k)
%  - output a value Yq(k)
% Consider a scaled signal g*x, then k can be determined as the value
% which satisfies
%   Xq(k-1)/g <= x < Xq(k)/g
% The quantization error for the scaled signal is
%   e = g*x - Yq(k)
%     = g * (x - Yq(k)/g)
% The bracketed term is the error for a signal x (not scaled) applied
% to a quantizer with break points Xq(.)/g and output levels Yq(.)/g.

Nlev = length(Yq);
if (ScaleF ~=1)
  if (Nlev > 1)
    Xq = Xq / ScaleF;
  end
  Yq = Yq / ScaleF;
end

% Calculate the mean square error
MSE = ScaleF^2 * QuantMSE (Yq, Xq, FPDF);

% Calculate the entropy
if (nargout >= 2)
  Entropy = QuantEntropy (Xq, FPDF{1});
end

% Calculate the SNR in dB
if (nargout >= 3)
  Fmean = FPDF{2};
  Fvar = FPDF{3};
  Xmean = feval(Fmean, -Inf, Inf);
  Svar = feval(Fvar, -Inf, Inf) - Xmean^2;
  SNRdB = 10 * log10(ScaleF^2 * Svar / MSE);
end

% Calculate the peak to average ratio for the quantizer
if (nargout >= 4)
  if (Nlev > 1)
    VL = (Yq(1)-Xq(1)) + Yq(1);
    VH = (Yq(end)-Xq(end)) + Yq(end);
    V = max(abs(VL-Xmean), abs(VH-Xmean));
  else
    V = Inf;
  end
  sdV = sqrt(Svar) / V;
end

return
