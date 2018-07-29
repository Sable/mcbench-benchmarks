function im_sub = nonmax_sup(imfil_x,imfil_y,imfil_z,th_up, th_low)

imfil_mag = sqrt(imfil_x.^2+imfil_y.^2+imfil_z.^2);

% im_max = max(imfil_mag(:));
% 
% im_min = min(imfil_mag(:));
% 
% th_level = th*(im_max - im_min) + im_min; 

[w,h,d] = size(imfil_x);

[x,y,z] = meshgrid(1:h,1:w,1:d);

xi = x - imfil_x./imfil_mag;

yi = y - imfil_y./imfil_mag;

zi = z - imfil_z./imfil_mag;

imtemp = interp3(x,y,z,imfil_mag,xi,yi,zi);

xi = x + imfil_x./imfil_mag;

yi = y + imfil_y./imfil_mag;

zi = z + imfil_z./imfil_mag;

imtemp2 = interp3(x,y,z,imfil_mag,xi,yi,zi);

im_sub = (imfil_mag > th_up);

im_sub = hysteresis(im_sub,imfil_mag,th_low);

im_sub = im_sub & (imtemp < imfil_mag)&(imtemp2 < imfil_mag);

