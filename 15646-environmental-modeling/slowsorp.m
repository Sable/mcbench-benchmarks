function slowsorp
% 1D transport - modelling with extensions for decay and slow sorption
%    using MATLAB pdepe                   
%
%   $Ekkehard Holzbecher  $Date: 2006/03/18 $
%--------------------------------------------------------------------------
T = 16;                    % maximum time [s]
L = 8;                     % length [m] 
D = 0.1;                   % diffusivity [m*m/s]
v = 0.5;                   % real fluid velocity [m/s]
lambdaf = 0;               % decay rate in fluid [1/s]
lambdas = 0;               % decay rate in solid [1/s]
theta = 0.2;               % porosity
rhob = 1200;               % porous medium bulk density [kg/m*m*m]
kappaf = 0.02;             % transition rate fluid to solid [1/s]
kappas =100000;            % transition rate solid to fluid [1/s]
c0f = 0.;                  % initial concentration in fluid [kg/m*m*m]
c0s = 0.;                  % initial concentration in solid [1]
cin = 1;                   % inflow concentration [kg/m*m*m]

M = 30;                    % number of timesteps  (>2)
N = 40;                    % number of nodes  
%-------------------------- output parameters
gplot = 2;                 % =1: breakthrough curves; =2: profiles   
gsurf = 0;                 % surface
gcont = 0;                 % =1: contours; =2: filled contours
ganim = 0;                 % animation of profiles; =1: single line; =2: all lines

t = linspace (T/M,T,M);    % time discretization
x = linspace (0,L,N);      % space discretization

%----------------------execution-------------------------------------------
options = odeset;
c = pdepe(0,@slowsorpde,@slowsorpic,@slowsorpbc,x,t,options,...
D,v,theta,rhob,kappaf,kappas,lambdaf,lambdas,[c0f;c0s],cin);

%---------------------- graphical output ----------------------------------
switch gplot
    case 1 
        plot ([0 t],c(:,:,1))        % breakthrough curves
        xlabel ('time'); ylabel ('concentration');
    case 2 
        plot (x,c(:,:,1)','--')      % profiles
        xlabel ('space'); ylabel ('concentration');
end
if gsurf                           % surface plot
    figure; surf (x,[0 t],c(:,:,1)); 
    xlabel ('space'); ylabel ('time'); zlabel('concentration');
end  
if gcont figure; end
switch gcont
    case 1 
        contour (x,[0 t],c(:,:,1))   % contours
        grid on; xlabel ('space'); ylabel ('time');
    case 2 
        contourf(x,[0 t],c(:,:,1))   % filled contours
        colorbar; xlabel ('space'); ylabel ('time');
end    
if (ganim)
    [FileName,PathName] = uiputfile('*.mpg'); 
    figure; if (ganim > 1) hold on; end 
    for j = 1:size(c,1)
        axis manual;  plot (x,c(j,:,1),'r','LineWidth',2); YLim = [min(c0,cin) max(c0,cin)]; 
        Anim(j) = getframe;
        axis manual; plot (x,c(j,:,1),'b','LineWidth',2); YLim = [min(c0,cin) max(c0,cin)];
    end
    mpgwrite (Anim,colormap,[PathName '/' FileName]);     % mgwrite not standard MATLAB 
    movie (Anim,0);   % play animation
end 

% --------------------------------------------------------------------------
function [c,f,s] = slowsorpde(x,t,u,DuDx,D,v,theta,rhob,kappaf,kappas,lambdaf,lambdas,c0,cin)
c = [1;1];
f = [D;0].*DuDx;
s = -[v;0].*DuDx - [lambdaf;lambdas].*u - ([kappaf -kappas]*u)*[1/theta;-1/rhob];

% --------------------------------------------------------------------------
function u0 = slowsorpic(x,D,v,theta,rhob,kappaf,kappas,lambdaf,lambdas,c0,cin)
u0 = c0;
    
% --------------------------------------------------------------------------
function [pl,ql,pr,qr] = slowsorpbc(xl,ul,xr,ur,t,D,v,theta,rhob,kappaf,kappas,lambdaf,lambdas,c0,cin)
pl = [ul(1)-cin;0];
ql = [0;1];
pr = [0;0];
qr = [1;1];