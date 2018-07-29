function engStr = num2eng(aNumber,sigFigs)
% num2eng converts a number to engineering notation.
%
% Engineering notation is similar to scientific notation, except that
% the exponent power of 10 is always an integer multiple of 3, and the
% mantissa is scaled so that it is between 1 and 1000.
%
%      aNum   =   m x 10^k
%
%      where      k = 3*h    for integer h    and    1 <= m < 1000
%
% ------------------------------------------------------------------------
%
% SYNTAX:       engStr = num2eng(aNumber);
%
%               engStr = num2eng(aNumber,sigFigs);
%
% ------------------------------------------------------------------------
%
% EXAMPLE 1:    aNumber = 0.01234567;
%               engStr = num2eng(aNumber);
%
%               returns engStr as 12.346e-3
%
% EXAMPLE 2:    aNumber = 1.25e8;
%               sigFigs = 3;
%               engStr = num2eng(aNumber,sigFigs);
%
% ------------------------------------------------------------------------
%
% Created by Rick Rosson, 2012 December 27.
%
% Copyright (c) 2012 The MathWorks, Inc.  All rights reserved.
%
% ------------------------------------------------------------------------
%

    % Default precision:
    if nargin < 2
       sigFigs = 5;
    end
    
    % Exponent:
    k = floor(log10(aNumber));
    k = 3*floor(k/3);
    
    % Mantissa:
    m = aNumber/10^k;
    
    % Number of digits in the whole number part and the fractional part:
    wholeDigits = ceil(log10(m));
    fracDigits = sigFigs - wholeDigits;
    
    % Adjust mantissa if fracDigits is negative:
    if fracDigits < 0
        A = 10^(-fracDigits);
        m = A*round(m/A);
        fracDigits = 0;
        % wholeDigits = sigFigs;
    end
    
    % Engineering notation:
    engStr = sprintf(['%0.',num2str(fracDigits),'fe%i'],m,k);

end

