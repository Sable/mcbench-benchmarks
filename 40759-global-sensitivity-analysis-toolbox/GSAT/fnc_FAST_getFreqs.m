%% fnc_FAST_getFreqs: Selection of a frequency set. Done recursively as described in:
%% ‘A computational implementation of FAST’ [McRae et al.]
%
% Usage:
%   W = fnc_FAST_getFreqs(k)
%
% Inputs:
%    k                scalar number of inputs 
%
% Output:
%    W               frequencies of parameters
%
% ------------------------------------------------------------------------
% See also 
%
% Author : Flavio Cannavo'
% e-mail: flavio(dot)cannavo(at)gmail(dot)com
% Release: 1.0
% Date   : 01-05-2011
%
% History:
% 1.0  01-05-2011  First release.
%%

function W = fnc_FAST_getFreqs(k)

if k==2
    W = [5 9];
elseif k==3
    W = [1 9 15];
else
    F = [0 3 1 5 11 1 17 23 19 25 41 31 ...
        23 87 67 73 85 143 149 99 119 ...
        237 267 283 151 385 157 215 449 ...
        163 337 253 375 441 673 773 875 ...
        873 587 849 623 637 891 943 1171 ...
        1225 1335 1725 1663 2019];
    DN = [4 8 6 10 20 22 32 40 38 26 56 62 ...
        46 76 96 60 86 126 134 112 92 ...
        128 154 196 34 416 106 208 328 ...
        198 382 88 348 186 140 170 284 ...
        568 302 438 410 248 448 388 596 ...
        216 100 488 166 0];

    W(1) = F(k);

    for i=2:k
        W(i) = W(i-1)+DN(k+1-i);
    end
end