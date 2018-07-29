function a = factor2(k)
%A = FACTOR2(K)
%Returns the factors (not only the prime factors) of k, including k itself.
%This complements the usage of TMW's factor function, which returns only
%prime factors. 
%E.g., >> a=factor(1365), b=factor2(1365)
% ANS: a = 3    5    7   13
%      b = 1    3    5    7    13    15    21    35    39    65    91    105    195    273    455    1365

%Written by Brett Shoelson, Ph.D.
%shoelson@helix.nih.gov
%9/10/01; updated 9/08/03.
%Fix 9/10/03: Includes isinteger as a subfunction.

if ~isinteger(k)| k < 1
	error('Valid only for positive integers.');
end
a = [1:floor(k/2)];
tmp = k./a;
tmp = isinteger(tmp);
a = [a(tmp),k];

function a = isinteger(k)
a = k == floor(k);