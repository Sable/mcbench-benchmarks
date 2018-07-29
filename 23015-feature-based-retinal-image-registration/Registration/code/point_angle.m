function localangle = point_angle(bw, seed, R, start, NeighborNum) 

% This function computes the angle of seed from the start point
if (nargin == 4)
    NeighborNum =3;
end

[M, N]= size(bw);

% image(y,x) <==>(x-1)*M + y
seedy = mod(seed, M);
if (seedy==0) seedy = M; end
seedx = 1 + (seed - seedy)/M;
starty = mod(start, M);
if (starty==0) starty = M; end
startx = 1 + (start - starty)/M;

dy = 1 + R + starty - seedy;
dx = 1 + R + startx - seedx;

% set the region border from 1:8*R
region = zeros(2*R+1);
region(R+1:-1:1,end) = (1:R+1)';
region(1,end-1:-1:2)= R+2:3*R;
region(1:end,1)= (3*R+1:5*R+1)';
region(end,2:end-1) = 5*R+2:7*R;
region(end:-1:R+2,end) = (7*R+1:8*R)';

startidx = region(dy, dx);
anglevec = point_anglevec(bw, seed, R); 

if (startidx==0)
    localangle = [];
    return;
end

if (anglevec(startidx)==0)
    localangle = [];
    return;
end

localangle = findangle(anglevec, startidx);
localnum = prod(size(localangle));

if (localnum > NeighborNum)
    localangle = localangle(1:NeighborNum);
end
if (localnum < NeighborNum)
    localangle = [localangle, zeros(1, NeighborNum - localnum )];
end