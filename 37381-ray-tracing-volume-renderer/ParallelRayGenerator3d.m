function rays = ParallelRayGenerator3d(volume,dimx,dimy,raystep)
sz = size(volume);
xdim=uint16(1:raystep:sz(1));
ydim=uint16(linspace(1,sz(2),dimx));
zdim=uint16(linspace(1,sz(3),dimy));

[x y z] = ndgrid(xdim,ydim,zdim); % Will itterate y, then x then z for speed

rays = [x(:)';
        y(:)';
        z(:)'];

rays = double(reshape(rays,[3 length(xdim) dimx*dimy]));

%Clean up some memory
clear xdim ydim zdim x y z;