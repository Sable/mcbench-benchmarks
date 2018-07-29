function Y = DGradient(X, Dim, Spacing, Method)  %#ok<STOUT,INUSD>
% Gradient along a dimension
% Y = DGradient(X, Dim, Spacing, Method)
% INPUT:
%   X:   Real DOUBLE array.
%   Spacing: Scalar or vector of the length SIZE(X, Dim).
%        A scalar value is the distance between all points, while a vector
%        contains all time points, such that DIFF(Spacing) are the distances.
%        For equally spaced input a scalar Spacing is much faster.
%        Optional, default: 1.0
%   Dim: Dimension to operate on.
%        Optional, default: [] (1st non-singelton dimension).
%   Method: String, order of the applied method for unevenly spaced X:
%        '1stOrder', faster centered differences as in Matlab's GRADIENT.
%        '2ndOrder', 2nd order accurate centered differences.
%        On the edges forward and backward difference are used.
%        Optional, default: '1stOrder'.
%
% OUTPUT:
%   Y:   Gradient of X, same size as X.
%
% EXAMPLES:
%   t = cumsum(rand(1, 100)) + 0.01;  t = 2*pi * t ./ max(t);
%   x = sin(t);
%   dx1 = DGradient(x, t, 2, '1stOrder');
%   dx2 = DGradient(x, t, 2, '2ndOrder');
%   dx  = cos(t);          % Analytic solution
%   h = plot(t, dx, t, dx1, 'or', t, dx2, 'og');  axis('tight');
%   title('cos(x) and DGradient(sin(x))');
%   legend(h, {'analytic', '1st order', '2nd order'}, 'location', 'best');
%
% NOTES:
% - There are a lot of other derivation tools in the FEX. This function is
%   faster, e.g. 25% faster than dqdt and 10 to 16 times faster than Matlab's
%   GRADIENT. In addition it works with multi-dim arrays, on a specific
%   dimension only, and can use a 2nd order method for unevenly spaced data.
% - This function does not use temporary memory for evenly spaced data and if
%   a single vector is processed. Otherwise the 1st-order method needs one and
%   the 2nd-order method 3 temporary vectors of the length of the processed
%   dimension.
% - Matlab's GRADIENT processes all dimensions ever, while DGradient operates on
%   the specified dimension only.
% - 1st order centered difference:
%     y(i) = (x(i+1) - x(i-1) / (s(i+1) - s(i-1))
% - 2nd order centered difference:
%     y(i) = ((x(i+1) * (s(i)-s(i-1)) / (s(i+1)-s(i))) -
%             (x(i-1) * (s(i+1)-s(i)) / (s(i)-s(i-1)))) / (s(i+1)-s(i-1))
%            + x(i) * (1.0 / (s(i)-s(i-1)) - 1.0 / (s(i+1)-s(i)))
%   For evenly spaced X, both methods reply equal values.
%
% COMPILE:
%   mex -O DGradient.c
% Consider C99 comments on Linux:
%   mex -O CFLAGS="\$CFLAGS -std=c99" DGradient.c
% Pre-compiled Mex: http://www.n-simon.de/mex
% Run the unit test uTest_DGradient after compiling.
%
% Tested: Matlab 6.5, 7.7, 7.8, WinXP, 32bit
%         Compiler: LCC2.4/3.8, BCC5.5, OWC1.8, MSVC2008
% Assumed Compatibility: higher Matlab versions, Mac, Linux, 64bit
% Author: Jan Simon, Heidelberg, (C) 2011 matlab.THISYEAR(a)nMINUSsimon.de
%
% See also GRADIENT, DIFF.
% FEX: central_diff (#12 Robert A. Canfield)
%      derivative (#28920, Scott McKinney)
%      movingslope (#16997, John D'Errico)
%      diffxy (#29312, Darren Rowland)
%      dqdt (#11965, Geoff Wawrzyniak)

% $JRev: R0c V:003 Sum:RkNcmbCGEJGT Date:02-Jan-2010 02:41:46 $
% $License: BSD $
% $File: Tools\Mex\Source\DGradient.c $
% History:
% 001: 30-Dec-2010 22:42, First version published under BSD license.

% This is a dummy file to support Matlab's HELP.

error(['JSimon:', mfilename, ':NoMex'], ...
   'Cannot find compiled Mex.\nPlease compile at first:  mex -O DGradient.c');
