function simpletrans
% 1D transport - modelling with extensions for decay and linear sorption
%    using mixing cell method                   
%
%   $Ekkehard Holzbecher  $Date: 2006/02/08 $
%--------------------------------------------------------------------------
T = 2;                     % maximum time [s]
L = 1;                     % length [m]
D = 0.1;                   % dispersivity [m*m/s]
v = 1;                     % velocity [m/s]
lambda = 1.2;              % decay constant [1/s]
R = 1;                     % retardation [1]
c0 = 0;                    % initial concentration [kg/m*m*m]
cin = 1;                   % inflow concentration [kg/m*m*m]

dtout = 0.05;              % output-timestep [s]
dxmax = 0.02;              % maximum grid spacing [m]
%------------------------ output parameters
gplot = 2;                 % =1: breakthrough curves; =2: profiles   
gsurf = 0;                 % surface
gcont = 0;                 % =1: contours; =2: filled contours
ganim = 2;                 % animation

%------------------------ execution----------------------------------------

dtout = dtout/R;           % timestep reduction for retardation case 
dx = dtout*v;              % grid spacing
K = 1;                     % K = reduction factor for grid spacing
if (dx>dxmax) K = ceil(dx/dxmax); end
dx = dx/K;                 % reduced grid spacing
dtadv=dtout/K;             % advection-timestep 
N = ceil(L/dx);            % N = number of cells
x = linspace(0,(N-1)*dx,N);% nodes on x-axis  
Neumann = D*dtadv/dx/dx;   % Neumann-number for dispersion
M = max (1,ceil(3*Neumann)); % M = reduction factor to fulfill Neumann-condition 
Neumann = Neumann/M/R;     % reduced Neumann-number
dtdiff = dtadv/M;          % diffusion timestep
t = dtadv;

clear c c1 c2;
c(1:N) = c0; c1 = c;
k = 1; kanim = 1;
while (t < T/R)
    for i=1:M
        kinetics;          % decay (1. order kinetics) 
        diffusion;         % diffusion
    end
    advection;             % advection
    if k >= K  
        c = [c;c1]; k=0; 
    end
    t = t + dtadv; k = k+1;
end
xlabel ('space'); ylabel ('concentration');

%-------------------- graphical output-------------------------------------

switch gplot
    case 1 
        plot (c)        % breakthrough curves
        xlabel ('time'); ylabel ('concentration');
    case 2 
        plot (x,c','--')% profiles
        xlabel ('space'); ylabel ('concentration');
end
if gsurf                % surface
    figure; surf (x,[0 t],c); 
    xlabel ('space'); ylabel ('time'); zlabel('concentration');
end  
if gcont figure; end
switch gcont
    case 1 
        contour (c)     % contours
        grid on; xlabel ('space'); ylabel ('time');
    case 2 
        contourf(c)     % filled contours
        colorbar; xlabel ('space'); ylabel ('time');
end    
if (ganim)
    [FileName,PathName] = uiputfile('*.mpg'); 
    figure; if (ganim > 1) hold on; end 
    for j = 1:size(c,1)
        axis manual;  plot (x,c(j,:),'r','LineWidth',2); 
        YLim = [min(c0,cin) max(c0,cin)]; 
        legend (['t=' num2str(dtout*(j-1))]);  
        Anim(j) = getframe;
        plot (x,c(j,:),'b','LineWidth',2); 
    end
    mpgwrite (Anim,colormap,[PathName '/' FileName]);     % mgwrite not standard MATLAB 
    movie (Anim,0);   % play animation
end 