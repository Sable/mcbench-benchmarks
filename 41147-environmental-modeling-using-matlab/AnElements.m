% Analytical elements
% Analytical solution of complex potential equation      
%    using MATLAB                     
%
%   $Ekkehard Holzbecher  $Date: 2006/11/28 $
%----------------------------------------------------------input-----------

Q0 = .5;         % baseflow
Q = 0;           % well pumping/recharge rate
A = 0;           % vortex strength 
s = -10;         % dipole strength
beta = 0;        % dipole angle
z0 = 0;          % position of well, vortex or di-pole 

% Mesh
xmin = -5;        % minimum x-position of mesh [m]
xmax = 5;         % maximum x-position of mesh [m]
dx = .21;         % grid spacing in x-direction [m]
ymin = -5;        % minimum y-position of mesh [m]
ymax = 5;         % maximum y-position of mesh[m]
dy = .22;         % grid spacing in y-direction [m]

% Output
gcontf = 50;               % number of filled contours for potential
gcont = 0;                 % number of contours for streamfunction    
gquiv = 0;                 % =1: arrow field
gstream = 1;               % =1: streamline command 

% Start positions (for streamline) 

zstart = xmin + i*(ymin+(ymax-ymin)*[0.1:0.1:1]);
zstart = [zstart xmin-i*0.001];

%--------------------------------------------------------execution---------

[x,y] = meshgrid ([xmin:dx:xmax],[ymin:dy:ymax]);  % mesh
z = x+i*y; 
Phi = -Q0'*z;                                                   % baseflow
if (Q ~= 0) Phi = Phi + (Q/(pi+pi))*log(z-z0); end              % well
if (A ~= 0) Phi = Phi + (A/i*pi)*log(z-z0); end                 % vortex
if (s ~= 0) Phi = Phi + (s/(pi+pi))*exp(i*beta)./(z-z0); end    % dipole

%-----------------------------------------------------------output---------

if gcontf
    colormap(winter);  
    contourf (x,y,real(Phi),gcontf);
end
hold on;
if gcont contour (x,y,imag(Phi),gcont,'w'); end  
[u,v] = gradient (-real(Phi)); 
if gquiv quiver (x,y,u,v,2,'w'); end
if gstream 
    h = streamline (x,y,u,v,real(zstart),imag(zstart));
    set(h,'Color','red');
end