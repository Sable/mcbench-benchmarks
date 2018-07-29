function [SortCoefVctr,SortSymPwrVctr] = coeffsort(CoefVctr,SymPwrVctr,SortSym)
% COEFFSORT
% [SortCoefVctr,SortSymPwrVctr] = coeffsort(CoefVctr,SymPwrVctr,SortSym)
% Finds Indices of Powers of Variables in the Symbolic-Vector Output of
% [CoeffVctr,SymPwrVctr] = coeffs(SymbolicPolynomialVector)
%
% Arguments of SYMSORT are:
%   CoefVctr   = Vector of Symbolic or Numeric Coefficients from coeffs
%   SymPwrVctr = Vector of Powers of Polynomial Variable e.g. [s^4, s^5, s, s^2, 1, s^3] from coeffs
%   SortSym    = Symbolic Polynomial Variable to Sort By (e.g. s in this example)
% NOTE:  Do not use either single or double quotes around the SortSym variable!
%
% COEFFSORT Returns Outputs of:
%   SortCoefVctr = Sorted Vector of of Powers of Polynomial Variable in DESCENDING
%       order, e.g. [s^5 s^4 s^3 s^2 s 1]
%   SortSymPwrVctr = Vector of coefficients of Polynomial Variable Corresponding
%       to the Coefficient Order in SortCoefVctr
%
%
% Frank Fisher
% Revision History  09-Feb-2005;
%
%

if isempty(SortSym)
    fprintf(1,'\n\nError coeffsort  No sort symbol provided\n\n');
    return
end

LenSymPwrVctr = length(SymPwrVctr);
SymPwrIdx = [];
if LenSymPwrVctr > 1
    for k1 = 1:LenSymPwrVctr
        SymPwrIdx(k1) = find(SymPwrVctr == SortSym^(k1-1));
    end
    for k1 = 1:LenSymPwrVctr
        SortCoefVctr(k1)   = CoefVctr(SymPwrIdx(k1));
        SortSymPwrVctr(k1) = SymPwrVctr(SymPwrIdx(k1));
    end
    SortCoefVctr   = fliplr(SortCoefVctr);
    SortSymPwrVctr = fliplr(SortSymPwrVctr);
elseif LenSymPwrVctr == 1
    SortCoefVctr   = CoefVctr;
    SortSymPwrVctr = 1;
elseif (LenSymPwrVctr < 1) | (isempty(CoefVctr)) | (isempty(SymPwrVctr))
    fprintf(1,'\n\nError coeffsort  Empty argument vectors\n\n');
end

if isempty(SymPwrIdx)
    SortCoefVctr   = CoefVctr*SymPwrVctr;
    SortSymPwrVctr = 1;
end

return

% ==============================  END     coeffsort.m  ==============================