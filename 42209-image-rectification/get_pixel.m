function [v,flag] = get_pixel(im,p)

[w,h,z] = size(im);
if z == 1
    v = 0;
else
    v = zeros(3,1);
end
flag = 0;

p = uint32(p);

if p(1)>0 && p(1)<=h && p(2)>0 && p(2)<=w
    if z == 1
        v = im(p(2),p(1));
    else
        v = im(p(2),p(1),:);
    end
    flag = 1;
end