% The fitting fuction:
function fit = SNumOnes(num)

% Iterating on the 32bit number:
fit = sum(dec2bin(num)=='1');