function cplxPot
% complex potential flow 
%    using MATLAB analytical solutions                   
%
%   $Ekkehard Holzbecher  $Date: 2006/05/31 $
%--------------------------------------------------------------------------
% Baseflow
H = 10;             % thickness [L]
h0 = 5;             % reference piezometric head [L] 
K = 5.e-5;          % hydraulic conductivity [L/T] 
Qx0 = 0;            % baseflow in x-direction [L^2/T]
Qy0 = 0;            % baseflow in y-direction [L^2/T]

% Wells
xwell = [150 250];          % x-coordinates well position [L]
ywell = [0 0];              % y-coordinates well position [L]
Qwell = 1.e-4*[1 -1];       % pumping / recharge rates [L^3/T]
R = [1 1];                  % well radius [L]

% Mesh
xmin = 0;           % minimum x-position of mesh [L]
xmax = 400;         % maximum x-position of mesh [L]
ymin = -100;        % minimum y-position of mesh [L]
ymax = 100;         % maximum y-position of mesh [L]

% Reference point position in mesh
iref = 1; jref = 1;

% Graphical output options
gsurfh = 0;         % piezometric head surface plot
gcontf = 16;        % no. filled contour lines (=0: none)
gquiv = 0;          % arrow field plot
gflowp_fit = 0;     % flowpaths forward in time
gflowp_bit = 0;     % no. flowpaths backward in time (=0: none)
gflowp_dot = 0;     % flowpaths with dots indicating speed
gstream = 10;       % streamfunction plot

%----------------------------------------execution-------------------------------
xvec = linspace(xmin,xmax,50);
yvec = linspace(ymin,ymax,50);
[x,y] = meshgrid (xvec,yvec);                      % mesh

phi = -Qx0*x - Qy0*y;
psi = -Qx0*y + Qy0*x;
for i = 1:size(xwell,2)
    r = sqrt((x-xwell(i)).*(x-xwell(i))+(y-ywell(i)).*(y-ywell(i)));  
    phi = phi + (Qwell(i)/(2*pi))*log(r);   % potential
    psi = psi + (Qwell(i)/(2*pi))*atan2((y-ywell(i)),(x-xwell(i)));
end                                        
if h0 > H
    phi0 = -phi(iref,jref) + K*H*h0 - 0.5*K*H*H; 
else
    phi0 = -phi(iref,jref) + 0.5*K*h0*h0;       % reference potential 
end                                              
hc = 0.5*H+(1/K/H)*(phi+phi0);                  % head confined
hu = sqrt ((2/K)*(phi+phi0));                   % head unconfined
phicrit = phi0 + 0.5*K*H*H;                     % transition confined / unconfined
confined = (phi>=phicrit);                      % confined / unconfined indicator
h = confined.*hc+~confined.*hu;                 % head

%---------------------------------------display messages-------------------
if all(all(confined))
    display ('aquifer confined');
else
    if all(all(~confined)) 
        display ('aquifer unconfined'); 
    else
        display ('aquifer partially confined and unconfined'); 
    end
end    
if any(any(h<0)) 
    display ('aquifer falls partially dry'); 
    h = max(0, h);
end
[u,v] = gradient (-phi);

%--------------------------------------graphical output--------------------
if gsurfh 
    figure; surf (x,y,h);                             % surface 
end 
figure;
if gcontf                                             % filled contours  
    colormap(winter); 
    contourf (x,y,h,linspace(5-max(max(h-5)),5+max(max(h-5)),gcontf),'w'); 
    colorbar; hold on;
end
if gquiv 
    quiver (x,y,u,v,'y'); hold on;                    % arrow field
end
if gflowp_fit                                         % flowpaths 
    xstart = []; ystart = [];
    for i = 1:100
        if v(1,i) > 0 xstart = [xstart xvec(i)];...
                ystart = [ystart yvec(1)]; end
        if v(100,i) < 0 xstart = [xstart xvec(i)];...
                ystart = [ystart yvec(100)]; end
        if u(i,1) > 0 xstart = [xstart xvec(1)];...
                ystart = [ystart yvec(i)]; end
        if u(i,100) < 0 xstart = [xstart xvec(100)];...
                ystart = [ystart yvec(i)]; end
    end
    h = streamline (x,y,u,v,xstart,ystart);
    set (h,'Color','r'); 
end
if gflowp_bit                                              
    xstart = x0 + R*cos(2*pi*[1:1:gflowp_bit]/gflowp_bit); 
    ystart = y0 + R*sin(2*pi*[1:1:gflowp_bit]/gflowp_bit);
    h = streamline (x,y,-u,-v,xstart,ystart);
    set (h,'Color','y') 
end
if gflowp_dot
    [verts averts] = streamslice(x,y,u,v,gflowp_dot);
    sc = 10/mean(mean(sqrt(u.*u+v.*v)));
    iverts = interpstreamspeed(x,y,u,v,verts,sc);  
    h = streamline(iverts);
    set (h,'Marker','.','Color','y','MarkerSize',18)
end
if gstream
    h = contour (x,y,psi,gstream,'k','LineWidth',1);  
end
