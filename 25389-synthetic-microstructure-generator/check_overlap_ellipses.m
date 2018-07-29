function [overlap] = check_overlap_ellipses(lnk,circles,dlnk,nglnk,ndxy,image_size,x0,y0,a0,b0,theta0)

ix0 = ceil(x0/dlnk);
iy0 = ceil(y0/dlnk);

ndx1 = ix0 - ndxy; ndx2 = ix0 + ndxy;
ndy1 = iy0 - ndxy; ndy2 = iy0 + ndxy;

ix = mod(ndx1:ndx2,nglnk);ixt = ix==0;ix(ixt)=nglnk;
iy = mod(ndy1:ndy2,nglnk);iyt = iy==0;iy(iyt)=nglnk;

a = lnk(ix,iy);
b = find(a~=0);
overlap = 0;
for k = 1:length(b)
    j = a(b(k));
    x1 = circles(j,1); y1 = circles(j,2);
    a1 = circles(j,3); b1 = circles(j,4);
    theta1 = circles(j,5);

    if x1-x0 > image_size / 2; x1 = x1 - image_size; end;
    if x0-x1 > image_size / 2; x1 = x1 + image_size; end;
    if y1-y0 > image_size / 2; y1 = y1 - image_size; end;
    if y0-y1 > image_size / 2; y1 = y1 + image_size; end;

    overlap = overlap_ellipses(x0,y0,a0,b0,theta0,x1,y1,a1,b1,theta1);
    if overlap == 1; overlap = 1; break; end;
end




