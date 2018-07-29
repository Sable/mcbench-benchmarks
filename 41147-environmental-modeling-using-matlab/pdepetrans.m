function pdepetrans
% 1D transport - modelling with extensions for decay and fast sorption
%    using MATLAB pdepe                   
%
%   $Ekkehard Holzbecher  $Date: 2006/03/16 $
%--------------------------------------------------------------------------
T = 1;                     % maximum time [s]
L = 1;                     % length [m]
D = 1;                     % diffusivity [m*m/s]
v = 1;                     % velocity [m/s]
lambda = 0.0;              % decay constant [1/s]
sorption = 2;              % sorption-model: no sorption (0), linear (1), 
                           %                 Freundlich (2), Langmuir (3)
k1 = 0.0004;               % sorption parameter 1 (R=0 for linear isotherm with Kd, else k1=R) 
k2 = 0.5;                  % sorption parameter 2 (Kd for linear isotherm with Kd)
rhob = 1300;               % porous medium bulk density [kg/m*m*m]
theta = 0.2;               % porosity [-]
c0 = 0.0;                  % initial concentration [kg/m*m*m]
cin = 1;                   % boundary concentration [kg/m*m*m]

M = 40;                    % number of timesteps
N = 40;                    % number of nodes  
%-------------------------- output parameters
gplot = 0;                 % =1: breakthrough curves; =2: profiles   
gsurf = 0;                 % surface
gcont = 0;                 % =1: contours; =2: filled contours
ganim = 2;                 % animation of profiles; =1: single line; =2: all lines

t = linspace (T/M,T,M);    % time discretization
x = linspace (0,L,N);      % space discretization

%----------------------execution-------------------------------------------
if sorption == 1 && k1 <=0
    k1 = 1+k2*rhob/theta;
else
    if sorption > 1 k1 = rhob*k1/theta; end
end
options = odeset; if (c0 == 0) c0 = 1.e-20; end
c = pdepe(0,@transfun,@ictransfun,@bctransfun,x,[0 t],options,D,v,lambda,sorption,k1,k2,c0,cin);

%---------------------- graphical output ----------------------------------
switch gplot
    case 1 
        plot ([0 t],c)        % breakthrough curves
        xlabel ('time'); ylabel ('concentration');
    case 2 
        plot (x,c','--')      % profiles
        xlabel ('space'); ylabel ('concentration');
end
if gsurf                      % surface plot
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
        ylim ([min(c0,cin) max(c0,cin)]); 
        legend (['t=' num2str(T*(j-1)/M)]);
        Anim(j) = getframe;
        plot (x,c(j,:),'b','LineWidth',2); 
    end
    mpgwrite (Anim,colormap,[PathName '/' FileName]);     % mgwrite not standard MATLAB 
    movie (Anim,0);   % play animation
end 


%----------------------functions------------------------------
function [c,f,s] = transfun(x,t,u,DuDx,D,v,lambda,sorption,k1,k2,c0,cin)
switch sorption
    case 0 
        R = 1;
    case 1 
        R = k1; 
    case 2
        R = 1+k1*k2*u^(k2-1);
    case 3 
        R = 1+k1*k2*u/(k2+u)/(k2+u);
end
c = R;
f = D*DuDx;
s = -v*DuDx -lambda*R*u;
% --------------------------------------------------------------
function u0 = ictransfun(x,D,v,lambda,sorption,k1,k2,c0,cin)
u0 = c0;
% --------------------------------------------------------------
function [pl,ql,pr,qr] = bctransfun(xl,ul,xr,ur,t,D,v,lambda,sorption,k1,k2,c0,cin)
pl = ul-cin;
ql = 0;
pr = 0;
qr = 1;
