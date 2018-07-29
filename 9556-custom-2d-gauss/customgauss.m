% CUSTOMGAUSS    Generate a custom 2D gaussian 
%
%    gauss = customgauss(gsize, sigmax, sigmay, theta, offset, factor, center)
%
%          gsize     Size of the output 'gauss', should be a 1x2 vector
%          sigmax    Std. dev. in the X direction
%          sigmay    Std. dev. in the Y direction
%          theta     Rotation in degrees
%          offset    Minimum value in output
%          factor    Related to maximum value of output, should be 
%                    different from zero
%          center    The center position of the gaussian, should be a
%                    1x2 vector                     
function ret = customgauss(gsize, sigmax, sigmay, theta, offset, factor, center)
ret     = zeros(gsize);
rbegin  = -round(gsize(1) / 2);
cbegin  = -round(gsize(2) / 2);
for r=1:gsize(1)
    for c=1:gsize(2)
        ret(r,c) = rotgauss(rbegin+r,cbegin+c, theta, sigmax, sigmay, offset, factor, center);
    end
end


function val = rotgauss(x, y, theta, sigmax, sigmay, offset, factor, center)
xc      = center(1);
yc      = center(2);
theta   = (theta/180)*pi;
xm      = (x-xc)*cos(theta) - (y-yc)*sin(theta);
ym      = (x-xc)*sin(theta) + (y-yc)*cos(theta);
u       = (xm/sigmax)^2 + (ym/sigmay)^2;
val     = offset + factor*exp(-u/2);