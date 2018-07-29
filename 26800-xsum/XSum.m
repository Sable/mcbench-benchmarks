% XSUM - Sum with error compensation
% The accuracy of the sum of floating point numbers is limited by the
% truncation error. E.g. SUM([1e16, 1, -1e16]) replies 0 instead of 1. The
% error grows with the length of the input, e.g. the error of SUM(RANDN(N, 1))
% is about EPS*(N / 10).
% Kahan, Knuth, Dekker, Ogita and Rump (and others) have derived some
% methods to reduce the influence of rounding errors, which are implemented
% here as fast C-Mex.
%
% Y = XSum(X, N, Method)
% INPUT:
%   X: Double array of any size.
%   N: Dimension to operate on. Optional, default: first non-singelton
%      dimension. Use the empty matrix [] to use this default together with
%      a 3rd argument.
%   Method: String: 'Double', 'Long', 'Kahan', 'Knuth', 'KnuthLong', 'Knuth2'.
%      Optional, default: 'Knuth'.
%      Not case sensitive. A description of the methods follows.
%   Call XSum without inputs to show the compilation date and availability of
%   long double methods.
%
% OUTPUT:
%   Y: Double array, equivalent to SUM, but with compensated error depending
%      on the Method. The high-precision result is rounded to double precision.
%      Y has the same size as X except for the N'th dimension, which is 1.
%      If X is empty, the empty matrix [] is replied.
%
% METHODS:
% The speed is compared to a single-threaded SUM for 1E6 elements. SUM is much
% faster with multi-threading and less than 1E4 elements, so only the relations
% between the methods have an absolute meaning.
% The accuracy depends on the input, so the stated values are estimations and
% must be seen as rules om thumb!
% Run TestXSum as a unit test and for comparing speeds and accuracies.
% Double: A thread-safe implementation of Matlab's SUM. At least in Matlab
%         2008a to 2009b the results of the multi-threaded SUM can differ 
%         slightly from call to call.
%         Speed:    0.5 of time for SUM (MSVC++ 2008).
%         Accuracy: If the compilers supports accumulation in a 80 bit register
%                   (e.g. Open Watcom 1.8), 3 additional digits are gained.
%                   Otherwise the result is equivalent to SUM.
% Long:   The sum is accumulated in a 80 bit long double, if the compiler
%         supports this (e.g. LCC v3.8, Intel compilers).
%         Speed:    40% slower than SUM.
%         Accuracy: 3-4 more valid digits compared to SUM.
% Kahan:  The local error is subtracted from the next element. See [4].
%         Speed:    10% slower than SUM.
%         Accuracy: 1 to 3 more valid digits than SUM.
% Knuth:  Calculate the sum as if it is accumulated in a 128 bit float. This is
%         suitable for the most real world problems. See [1], [2], [3].
%         Speed:    As fast as SUM (MSVC++ 2008).
%         Accuracy: About 15 more valid digits than SUM.
% Knuth2: As Knuth, but the error is accumulated with a further level of
%         compensation. This is equivalent to an accumulation in a 196 bit
%         float. See [2] and INTLAB.
%         Speed:    60% slower than SUM (MSVC++ 2008).
%         Accuracy: 30 more valid digits than SUM.
% KnuthLong: As Knuth, but the temporary variables are long doubles, if this
%         is supported by the compiler.
%         Speed:    250% slower than SUM (LCC 3.8).
%         Accuracy: 21 more valid digits than SUM.
%
% NOTES: Sorting the input increases the accuracy *sometimes*, but this is slow:
%   sorting 1E7 elements needs 30 times longer than adding them. For e.g.
%   SUM(RANDN(1, 1E7)) sorting reduces the accuracy! So this is no alternative.
%
% COMPILATION and REFERENCES: See XSum.c
%
% Tested: Matlab 6.5, 7.7, 7.8, WinXP, [UnitTest]
% Author: Jan Simon, Heidelberg, (C) 2009-2010 matlab.THISYEAR(a)nMINUSsimon.de
%
% See also: SUM.
% FEX: Alain Barraud: SUMBENCH (#23198), FORWARD_STABLE_SOLVER (#10668),
%      SUMDOTPACK (#8765)
% INTLAB: Prof. Dr. Siegfried M. Rump, http://www.ti3.tu-harburg.de/rump/intlab

% $JRev: R0m V:012 Sum:FOjU0nPJ7H7r Date:28-Feb-2010 02:40:08 $
% $License: BSD (use, copy, distribute on own risk, mention the author) $
% $File: Published\XSum\XSum.m $

% MEX file! This is a dummy to feed HELP.
