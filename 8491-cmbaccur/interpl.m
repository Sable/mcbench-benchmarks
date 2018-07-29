function    result = interpl(x, table, x1)
% interpl.m  does a linear interpolation at x1 in a table of values along x,
% x is a row vector size n, table a matrix nXl and x1 a column vector size l
% the result is a column vector of size l 
% take attention :  vector x must match the rows in table, otherwise we assume
% that the table( and x1) is a row vector.
% There is no check that the interpolation is outside the range and x must be 
% a monotonic and equidistant row of values (such that we can calculate a step)
% 
% D Vangheluwe 3 jan 2005.
% remark 1: if the interpolation is outside the range of the table, MATLAB gives
%  mostly an error that the "index must be a positive integer" or "index exceeds matrix dimensions".


lx = size(x,2);
rx = x(lx) - x(1);
%step = rx/(lx - 1);
% step1 = 1/step to improve efficiency
step1 = (lx - 1)/rx; 

[nrt nct] = size(table);
% find x1 in the table and interpolate
a1 = x1 - x(1);
ix = 1 + floor(a1 *step1);

%rm = step1 *rem(a1, step);
% calculate the remainer this way, to improve efficiency 
%rm = a1 - (ix - 1) * step;
rm = step1 * a1 - ix + 1;

if nrt < lx
  result = table(1, ix) + (table(1, ix + 1) - table(1, ix)) .* rm;
else  % nrt == lx
  result = table(ix,:) + (table(ix + 1,:) - table(ix,:)) .* repmat(rm, 1, nct);
end
  

