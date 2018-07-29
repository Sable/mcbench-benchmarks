function ret = ellipseMatrix(y0, x0, a, b, teta, Image, color)
% Set the elements of the Matrix Image which are in the interior of the
% ellipse E with the value 'color'. The ellipse E has center (y0, x0), the
% major axe = a, the minor axe = b, and teta is the angle macked by the
% major axe with the orizontal axe.
% ellipseMatrix(y0, x0, a, b, teta, Image, color)
%
% Function:  ellipseMatrix
% Version:   1.1
% Author:    Nicolae Cindea

im = Image;
[ny, nx] = size(im);
imtemp = zeros(ny, nx);
list = zeros(ny * nx, 2);
toplist = 1;
c = sqrt(a * a - b * b);

x0 = round(x0);
y0 = round(y0);
list(toplist, 1) = y0;
list(toplist, 2) = x0;
im(y0, x0) = color;

while (toplist > 0)
    y = list(toplist, 1);
    x = list(toplist, 2);
    toplist = toplist - 1;
    
    if local_isValid(y, x + 1, y0, x0, a, c, teta, imtemp, ny, nx, color)
        toplist = toplist + 1;
        list(toplist, 1) = y;
        list(toplist, 2) = x + 1;
        im(list(toplist, 1), list(toplist, 2)) = color;
        imtemp(list(toplist, 1), list(toplist, 2)) = color;        
    end
    if local_isValid(y - 1, x, y0, x0, a, c, teta, imtemp, ny, nx, color)
        toplist = toplist + 1;
        list(toplist, 1) = y - 1;
        list(toplist, 2) = x;
        im(list(toplist, 1), list(toplist, 2)) = color;
        imtemp(list(toplist, 1), list(toplist, 2)) = color;
    end
    if local_isValid(y, x - 1, y0, x0, a, c, teta, imtemp, ny, nx, color)
        toplist = toplist + 1;
        list(toplist, 1) = y;
        list(toplist, 2) = x - 1;
        im(list(toplist, 1), list(toplist, 2)) = color;
        imtemp(list(toplist, 1), list(toplist, 2)) = color;        
    end
    if local_isValid(y + 1, x, y0, x0, a, c, teta, imtemp, ny, nx, color) == 1
        toplist = toplist + 1;
        list(toplist, 1) = y + 1;
        list(toplist, 2) = x;
        im(list(toplist, 1), list(toplist, 2)) = color;
        imtemp(list(toplist, 1), list(toplist, 2)) = color;        
    end
  
end
ret = im;


%--------------------------------------------------------------------------
function is_val = local_isValid(y, x, y0, x0, a, c, teta, im, ny, nx, color)

d1 = (x - x0 - c * cos(teta))^2 + (y - y0 - c * sin(teta))^2;
d1 = sqrt(d1);
d2 = (x - x0 + c * cos(teta))^2 + (y - y0 + c * sin(teta))^2;
d2 = sqrt(d2);
if (d1 + d2 <= 2*a) && (im(y, x) ~= color) && (x>0) && (y>0) && ...
        (x <= nx) && (y <= ny)
    is_val = 1;
else
    is_val = 0;
end