function rainbowplot(x, y)
%------------------------------------------------------------
%  RAINBOWPLOT Colorful linear 2-D plot
%  This function plots a line colored like a rainbow. 
%  The line is defined by x versus y pairs, which is the same
%  as a regular 2-D plot.
%
%   Usage Examples,
%
%   x = 1:100; y = randn(1,100);  
%   rainbowplot(x, y);
%
%   Kun Liu 
%   Version 1.00
%   June, 2006
%------------------------------------------------------------

if size(x, 1)~=1 || size(y, 1)~=1 
    error('x and y must be one dimensional vector...');    
end
if size(x, 2) ~= size(y, 2)
    error('x and y must have the same number of elements...');
end

length = size(x, 2);
d = length:-1:1;
p = patch([x nan],[y nan], [d nan], 'EdgeColor', 'interp');