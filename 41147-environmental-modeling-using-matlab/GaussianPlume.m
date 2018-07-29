function GaussianPlume
% Gaussian plume model 
%    using MATLAB analytical solutions                   
%
%   $Ekkehard Holzbecher  $Date: 2006/08/21$
%-----------------------------------------------------------------------
Dy = 0.2; Dz = 1;           % diffusivities
v = 0.5;                    % velocity
lambda = 0;                 % decay rate
Q = 1;                      % emission rate(s)
xstack = 0; ystack = 50;    % stack location(s)
xmin = 10; xmax = 1000;     % x-axis interval
ymin = 0; ymax = 100;       % y-axis interval (used only for d>1)
H = 50;                     % effective stack height(s) 
z = 0;                      % height of observation (=0 for ground surface)
gplot = 1;                  % plot option (=1 yes; =0 no)
gcont = 2;                  % contour plot option (=2 filled; =1 yes; =0 none) 

%----------------------------------execution-------------------------------
[x,y] = meshgrid (linspace(xmin,xmax,100),linspace(ymin,ymax,100));
c = zeros (size(x)); e = ones(size(x));
for i = 1:size(Q,2)
    xx = x - xstack(i); yy = y - ystack(i); 
    c = c + Q(i)*e./(4*pi*xx*sqrt(Dy*Dz)).*exp(-v*yy.*yy./(4*Dy*xx)).*... 
    (exp(-v*(z-H(i))*(z-H(i))*e./(4*Dz*xx))+exp(-v*(z+H(i))*(z+H(i))*e./(4*Dz*xx)))...
    .*exp(-lambda*xx/v);
end

%----------------------------------output----------------------------------
if gplot
    for i = 10:10:100
	    plot (c(:,i)); hold on;
    end
end
if gcont
    figure;
    if gcont > 1
        contourf (x,y,c); colorbar;
    else
        contour (x,y,c); 
    end
end
