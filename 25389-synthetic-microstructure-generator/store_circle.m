function [lnk] = store_circle(lnk,x0,y0,dlnk,nparticles)

ix = ceil(x0/dlnk);
iy = ceil(y0/dlnk);

if lnk(ix,iy) == 0;
    lnk(ix,iy) = nparticles;
else
    disp('Two circles in one linked list');
    if ix+1 < dlnk * length(lnk) && lnk(ix+1,iy) == 0
        lnk(ix+1,iy) = nparticles;
    elseif iy + 1 < dlnk * length(lnk) && lnk(ix,iy+1) == 0
        lnk(ix,iy+1) = nparticles;
    elseif ix - 1 > 0 && lnk(ix-1,iy) == 0
        lnk(ix-1,iy) = nparticles;
    elseif iy - 1 > 0 && lnk(ix,iy-1) == 0
        lnk(ix,iy-1) = nparticles;
    end
end 
