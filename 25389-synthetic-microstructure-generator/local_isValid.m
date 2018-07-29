function is_val = local_isValid(x, y, x0, y0, a, c, theta, im, nx, ny, color)

d1 = (x - x0 - c * cos(theta))^2 + (y - y0 - c * sin(theta))^2;
d1 = sqrt(d1);
d2 = (x - x0 + c * cos(theta))^2 + (y - y0 + c * sin(theta))^2;
d2 = sqrt(d2);
if (d1 + d2 <= 2*a) && (x>0) && (y>0) && (x <= nx) && (y <= ny) && (im(x, y) ~= color)
    is_val = 1;
else
    is_val = 0;
end