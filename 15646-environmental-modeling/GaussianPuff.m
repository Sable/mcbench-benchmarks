function GaussianPuff
% Gaussian puff model 
%    using MATLAB analytical solutions                   
%
%   $Ekkehard Holzbecher  $Date: 2006/08/21 $
%-----------------------------------------------------------------------
d = 3;                      % dimensionality
Dx = 0.004; Dy = 0.001; Dz = 0.001;  % diffusivities
v = 1;                      % velocity
M = 1;                      % mass
xmin = 0.85; xmax = 1.15;   % x-axis interval
ymin = -0.1; ymax = 0.1;    % y-axis interval (used only for d>1)
zmin = -0.1; zmax = 0.1;    % z-axis interval (used only for d>2)
t = [1:4:20];               % time
gplot = 1;                  % plot option (=1 yes; =0 no)
gcont = 2;                  % contour plot option (=2 filled; =1 yes; =0 none) 
gsurf = 0;                  % surface plot option (=1 yes; =0 no) 
                            %       (only for d<3)
%-------------------------------execution------------------------------
switch d
    case 1
        x = linspace (xmin,xmax,100);
        c = [];
        for i = 1:size(t,2)
            xx = x - v*t(i);
            c = [c; (M/sqrt(4*pi*Dx*t(i)))*ones(1,size(x)).*...
                exp(-(xx.*xx)/(4*Dx*t(i)))];
        end
    case 2
        if size(t,2) > 1 t = t(1); display('first time level is considered only');
        end
        [x,y] = meshgrid (linspace(xmin,xmax,100),linspace(ymin,ymax,100));
        xx = x - v*t;
        c = (M/4/pi/t/sqrt(Dx*Dy))*ones(100).*exp(-0.25*(xx.*xx/Dx + y.*y/Dy)/t);
    case 3
        if size(t,2) > 1 t = t(1); display('first time level is considered only');
        end
        [x,y,z] = meshgrid (linspace(xmin,xmax,45),...
            linspace(ymin,ymax,45),linspace(zmin,zmax,45));
        xx = x -v*t;
        c = (M/(sqrt(4*pi*t)^3)/sqrt(Dx*Dy*Dz))*ones(45,45,45)...
            .*exp(-0.25*(xx.*xx/Dx + y.*y/Dy + z.*z/Dz)/t);
end

%---------------------------------output-------------------------------
if gplot
    switch d
        case 1
            plot (c'); hold on; xlabel ('space');
            ylabel ('concentration'); title ('1D Gaussian puff');
        case 2
            for i = 10:10:100
                plot (c(:,i)); hold on;
            end
            xlabel ('x'); ylabel ('concentration'); 
            title ('2D Gaussian puff along slices y=const)');  
        case 3
            for i = 5:5:45
                plot (c(:,i,23)); hold on;
            end
            xlabel ('x'); ylabel ('concentration'); 
            title ('3D Gaussian puff along line x=0');
    end
    colorbar
end

switch gcont
    case 1               % contours
        figure;
        switch d
            case 1
                contour (x,t,c,30);    
                grid on; xlabel ('space'); ylabel ('time');
            case 2
                contour (x,y,c,30);  
                xlabel ('x'); ylabel ('y'); 
            case 3
        end
        title ('concentration'); 
    case 2               % filled contours
        figure;
        switch d
            case 1
                contourf(x,t,c,30);   
                colorbar; xlabel ('space'); ylabel ('time');
            case 2
                contourf (x,y,c,30); 
                colorbar; xlabel ('x'); ylabel ('y'); 
            case 3
                xslice = [xmin 0.5*(xmin+xmax) xmax];
                yslice = [ymax];
                zslice = [zmin 0.5*(zmin+zmax) zmax];
                slice (x,y,z,c,xslice,yslice,zslice); 
                xlabel ('x'); ylabel ('y'); zlabel ('z');
        end
        title ('concentration'); 
end    
if gsurf
    figure; 
    switch d
            case 1
                surf(x,t,c);   
                colorbar; xlabel ('space'); ylabel ('time');
            case 2
                surf (x,y,c); 
                colorbar; xlabel ('x'); ylabel ('y'); 
            case 3
        end
        title ('concentration');
end

