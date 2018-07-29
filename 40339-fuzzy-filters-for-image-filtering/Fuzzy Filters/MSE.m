function e = MSE( y, s )
% Mean Square Error
% y - Original image
% s - de-noised image

[m n ~] = size(y);
y = double(y);
s = double(s);
e = sum(sum((y-s).^2))/(m*n);