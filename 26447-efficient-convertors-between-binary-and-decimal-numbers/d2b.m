function y = d2b(x)

% Convert a decimanl number into a binary array
% 
% Similar to dec2bin but yields a numerical array instead of a string and is found to
% be rather faster

c = ceil(log(x)/log(2)); % Number of divisions necessary ( rounding up the log2(x) )
y(c) = 0; % Initialize output array
for i = 1:c
    r = floor(x / 2);
    y(c+1-i) = x - 2*r;
    x = r;
end
