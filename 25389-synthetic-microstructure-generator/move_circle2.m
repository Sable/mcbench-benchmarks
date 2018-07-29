function [Image,x0,y0] = move_circle2(Image,I_ellipse,xlo,xhi,ylo,yhi,ix,iy);

image_size = length(Image);

while max(max(Image(ix,iy))) > 1

    Image(ix,iy) = Image(ix,iy) - I_ellipse;

    x0 = ceil(rand*image_size); 
    y0 = ceil(rand*image_size);

    nlo = x0 - xlo; nhi = x0 + xhi;
    ix = mod(nlo:nhi,length(Image));ix(ix==0)=length(Image);
    nlo = y0 - ylo; nhi = y0 + yhi;
    iy = mod(nlo:nhi,length(Image));iy(iy==0)=length(Image);

    Image(ix,iy) = Image(ix,iy) + I_ellipse;

end