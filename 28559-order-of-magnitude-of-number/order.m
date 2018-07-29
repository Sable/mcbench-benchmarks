function n = order( val, base )
%Order of magnitude of number for specified base. Default base is 10.
%order(0.002) will return -3., order(1.3e6) will return 6.
%Author Ivar Smith

if nargin < 2
    base = 10;
end
n = floor(log(abs(val))./log(base));