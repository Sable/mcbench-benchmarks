function im = hysteresis(im,im_mag,th_low)

[w h d] = size(im);
index = find(im);
old_index = [];

while length(old_index)~=length(index)
    old_index = index;
    x = mod(mod(index,w*h),h);
    y = ceil(mod(index,w*h)/h);
    z = ceil(index/w/h);
    for i = -1:1
        for j = -1:1
            for k = -1:1
                xtemp = x+i;
                ytemp = y+j;
                ztemp = z+k;
                ind = find(xtemp>=1 & xtemp<=w & ytemp>=1 & ytemp<=h & ztemp>=1 & ztemp<=d);
                xtemp = xtemp(ind);
                ytemp = ytemp(ind);
                ztemp = ztemp(ind);
                im(xtemp+(ytemp-1)*w+(ztemp-1)*h*w) = im_mag(xtemp+(ytemp-1)*w+(ztemp-1)*h*w)>th_low;
            end
        end
    end
    index = find(im);
end