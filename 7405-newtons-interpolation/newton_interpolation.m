function fp = newton_interpolation(x,y,p)
% Script for Newton's Interpolation.
% Muhammad Rafiullah Arain
% Mathematics & Basic Sciences Department
% NED University of Engineering & Technology - Karachi
% Pakistan.
% ---------
% x and y are two Row Matrices and p is point of interpolation
%
% Example
% >> x=[1,2,4,7,8]
% >> y=[-9,-41,-189,9,523]
% >> newton_interpolation(x, y, 5)
% OR
% >> a = newton_interpolation(x, y, 5)

n = length(x);
a(1) = y(1);
for k = 1 : n - 1
   d(k, 1) = (y(k+1) - y(k))/(x(k+1) - x(k));
end
for j = 2 : n - 1
   for k = 1 : n - j
      d(k, j) = (d(k+1, j - 1) - d(k, j - 1))/(x(k+j) - x(k));
   end
end
d
for j = 2 : n
   a(j) = d(1, j-1);
end
Df(1) = 1;
c(1) = a(1);
for j = 2 : n
   Df(j)=(p - x(j-1)) .* Df(j-1);
   c(j) = a(j) .* Df(j);
end
fp=sum(c);




