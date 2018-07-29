function wellvortex
% systems of wells or vortices 
%    using MATLAB analytical solutions                   
%
%   $Ekkehard Holzbecher  $Date: 2006/05/30 $
%--------------------------------------------------------------------------
wellvort = 0;                  % wells (1)/ vortices (0)  switch 
mirrorx = 0;                   % symmetry property for x-axis
mirrory = 1;                   % symmetry property for y-axis 
mirror = 0;                    % symmetry / antisymmetry switch
xspace = linspace(-100,100,200); % x-values mesh
yspace = linspace(-100,100,200); % y-values mesh
N = 3;                         % no. of wells / vortices (for random choice)
                               %    for manual input set: N = 0;
zloc = [-20 40] + 1i*[40 60];   % well / vortex positions
s = [5 10];                    % pumping rates / circulation rates 
N0 = 30;                       % no. of filled contours
M0 = 8;                        % no. starting points around each well / vortex
gquiv = 1;                     % arrow field on/off

%------------------------------------- execution --------------------------
xrange = xspace(end) - xspace(1);
yrange = yspace(end) - yspace(1);
[x,y] = meshgrid (xspace,yspace); z = x +1i*y;
if N > 0
    zloc = xspace(1)+xrange*rand(1,N)+1i*(yspace(1)+yrange*rand(1,N));
    s = -10+round(20*rand(1,N));    % strengths unit steps between -10 and 10
else
    N = size(s,2);
end

if mirrorx  
    zloc = [zloc conj(zloc)];
    if mirror 
        s = [s s]; 
    else
        s = [s -s];
    end
end
if mirrory
    zloc = [zloc -real(zloc)+1i*imag(zloc)];
    if mirror 
        s = [s s]; 
    else
        s = [s -s];
    end
end
    
f = Phi(z,zloc,s);
[u,v] = gradient (-real(f));
whitebg([.753,0.753,0.753]);
plot (xspace(1:2),yspace(1)*[1 1],'w'); hold on;
plot (xspace(1:2),yspace(1)*[1 1],'b');
legend ('streamlines','isopotentials')
colormap('jet'); 
xstart = []; ystart = [];
for k = 1:size(s,2)
    for j = 1:M0 xstart = [xstart real(zloc(k))+xrange*cos(2*pi*j/M0)/1000]; 
        ystart = [ystart imag(zloc(k))+yrange*sin(2*pi*j/M0)/1000]; end
end
xspace = linspace (xspace(1),xspace(end),20);
yspace = linspace (yspace(1),yspace(end),20);

%-------------------------------- graphics ------------------------------------
if wellvort
    contourf (x,y,real(f),N0,'b'); hold on;   
    hh = streamline (x,y,u,v,xstart,ystart);
    set (hh,'Color','w');
    hh = streamline (x,y,-u,-v,xstart,ystart);
    set (hh,'Color','w');
    if gquiv             
        [x,y] = meshgrid (xspace,yspace); z = x +i*y; 
        [u,v] = gradient (-real(Phi(z,zloc,s)));
        quiver (x,y,u,v,gquiv,'w'); 
    end
    title ('Well galery: Streamlines & Isopotentials','FontWeight','bold');
else
    contourf (x,y,real(f),N0,'w');
    hh = streamline (x,y,u,v,xstart,ystart);
    set (hh,'Color','b');
    hh = streamline (x,y,-u,-v,xstart,ystart);
    set (hh,'Color','b');
    if gquiv    
        [x,y] = meshgrid (xspace,yspace); z = x +1i*y; 
        [v,u] = gradient (-real(Phi(z,zloc,s))); u = -u;
        quiver (x,y,u,v,gquiv,'w'); 
    end
    title ('Vortices System: Streamlines & Isopotentials','FontWeight','bold');
end
axis off;
hold off; 

function f = Phi (z,zloc,s)
f = 0*z;
for k = 1:size(s,2) 
    f = f + s(k)*log(z-zloc(k))/2/pi; 
end
