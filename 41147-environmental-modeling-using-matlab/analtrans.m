function analtrans
% 1D transport - modelling with extensions for decay and linear sorption
%    using analytical solution of Ogata & Banks (1961)                   
%
%   $Ekkehard Holzbecher  $Date: 2006/02/08 $
%--------------------------------------------------------------------------                       
T = 1;                      % maximum time [s]
L = 1;                      % maximum length [m]
D = 0.1;                    % diffusivity / dispersivity [m*m/s]
v = 1;                      % velocity [m/s]
lambda = 0.0;               % decay coefficient [1/s]
R = 3;                      % retardation [1]
c0 = 0;                     % initial value [kg/m*m*m] (initial condition)
cin = 1;                    % inflow value [kg/m*m*m] (boundary condition)

M = 20;                     % number of timesteps
N = 20;                     % number of nodes  
%-------------------------- output parameters
gplot = 0;                  % =1: breakthrough curves; =2: profiles   
gsurf = 0;                  % surface
gcont = 0;                  % =1: contours; =2: filled contours
ganim = 2;                  % animation of profiles; =1: single line; =2: all lines

%-------------------------- execution--------------------------------------

e = ones (1,N);             % ones-vector
t = linspace (T/M,T,M);     % time discretization
x = linspace (0,L,N);       % space discretization
c = c0*e;                   % initial distribution
u = sqrt(v*v+4*lambda*R*D);

for i = 1:size(t,2)
    h = 1./(2.*sqrt(D*R*t(i)));       
    c = [c; c0*exp(-lambda*t(i))*(e-0.5*erfc(h*(R*x-e*v*t(i)))-...
        0.5*exp((v/D)*x).*erfc(h*(R*x+e*v*t(i))))+...
        (cin-c0)*0.5*(exp((v-u)/(D+D)*x).*erfc(h*(R*x-e*u*t(i)))+...
        exp((v+u)/(D+D)*x).*erfc(h*(R*x+e*u*t(i))))]; 
end

%-------------------- graphical output-------------------------------------
switch gplot
    case 1 
        plot ([0 t],c)        % breakthrough curves
        xlabel ('time'); ylabel ('concentration');
    case 2 
        plot (x,c','--')      % profiles
        xlabel ('space'); ylabel ('concentration');
end
if gsurf                      % surface
    figure; surf (x,[0 t],c); 
    xlabel ('space'); ylabel ('time'); zlabel('concentration');
end  
if gcont figure; end
switch gcont
    case 1 
        contour (x,[0 t],c)   % contours
        grid on; xlabel ('space'); ylabel ('time');
    case 2 
        contourf(x,[0 t],c)   % filled contours
        colorbar; xlabel ('space'); ylabel ('time');
end    
if (ganim)
    [FileName,PathName] = uiputfile('*.mpg');
    figure; if (ganim > 1) hold on; end 
    for j = 1:size(c,1)
        axis manual;  plot (x,c(j,:),'r','LineWidth',2); 
        YLim = [min(c0,cin) max(c0,cin)];
        legend (['t=' num2str(T*(j-1)/M)]);
        Anim(j) = getframe;
        plot (x,c(j,:),'b','LineWidth',2); 
    end
    mpgwrite (Anim,colormap,[PathName '/' FileName]);  % mgwrite not standard MATLAB
    figure; movie (Anim,0);   % play animation
end 