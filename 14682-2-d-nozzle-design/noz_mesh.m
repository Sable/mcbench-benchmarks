%   ****** See nozzle.m for instructions ******
%  Program to extrapolate the data points from nozzle design and make a
%  uniform grid spacing in the x-direction
%  Change nothing... simply run this script


%  Find the minimum spacing given by the method of characteristics
%  and set as the dx value
dx = 0;
for i=1: size(noz,1)-1
    len = noz(i+1,1) - noz(i,1);
    if (len < dx || i == 1)
        dx = len;
    end
end

%  Explicitly give the dx value here
dx = max(noz(:,1))/ceil(max(noz(:,1))/dx);
n = max(noz(:,1))/dx;

% len = max(noz(:,1));
% n = 50;   %  Note # of points is actually n+1 
% dx = len/n

%  Pick m points in y as some factor of x points
yfactor = .8;
m = ceil(yfactor*n);

%  Make uniform x-distribution of points
xmax = 0;
i = 1;
while xmax < max(noz(:,1))
    xmax = dx*(i-1);
    x(i,1:m) = xmax;
    i = i+1;
end


%  Make the y-points and extrapolate linearly from closest points to fit
%  the nozzle geometry

%  Initialize and assign last value
y(1:size(x,1),1:size(x,2)) = 0;
y(1,size(y,2)) = noz(1,size(noz,2));
y(size(y,1),size(y,2)) = noz(size(noz,1),size(noz,2));
for i = 1 : size(x,1)-1
    
    j = 1;
    while x(i,1) >= noz(j,1)
        x1 = noz(j,1);
        x2 = noz(j+1,1);
        y1 = noz(j,2);
        y2 = noz(j+1,2);
        j = j + 1;
    end
    
    slope = (y2 - y1)/(x2 - x1);
    y(i,size(y,2)) = y1 + slope*(x(i,1)-x1);
    
    %Fill in mesh
    dy = y(i,size(y,2))/(size(y,2)-1);
    for k = 1: size(y,2)
        y(i,k) = dy*(k-1);
    end
    
end

%Fill in mesh
dy = y(size(y,1),size(y,2))/(size(y,2)-1);
for k = 1: size(y,2)
    y(size(y,1),k) = dy*(k-1);
end
    
'Mesh done'

