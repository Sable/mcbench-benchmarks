function analtransnodim
% 1D transport - modelling with extensions for decay and linear sorption
%    for dimensionless parameters and variables
%    using extended version of analytical solution of Ogata & Banks (1961)                   
%
%   $Ekkehard Holzbecher  $Date: 2006/02/22 $
%--------------------------------------------------------------------------
M = 50;         % graph resolution
N = 10;         % number of curves
T = 1;          % maximum dimensionless time
Da = 1;         % (2nd) Damköhler number (lambda*R*L/v)
Pe = 100.;      % Peclet number (L/alphal)
R = 1;          % Retardation, only used for scale = 1;

c0 = 0.5;       % initial value
c1 = 1;         % inflow value

type = 1;       % =0: btcs; =1: profiles
scale = 1;      % =0: time scaling with respect to retarded advection; 
                % =1: time scaling for advection only
               
if ~scale R = 1; end    
y ='grbkcym';
e = diag(eye(M));
if scale u = sqrt(1+4*R*Da/Pe); else u = sqrt(1+4*Da/Pe); end
%figure;
set(gca,'FontSize',14);
if (type > 0) 
    %Solution as function of x 
    t = linspace (T/N,T,N);
    x = linspace (1/M,1,M);
    for i = 1:size(t,2)
        t0 = t(i);
        h = diag(1./(2.*sqrt(t0*R/Pe)));
        u1s = c1*0.5*exp(0.5*Pe*(1-u)*x').*erfc(h*(R*x'-e*u*t0));
        u1 = c0*exp(-Da*t0)*(e-0.5*erfc(h*(R*x'-e*t0))-0.5*exp(Pe*x').*erfc(h*(R*x'+e*t0)))+...
        c1*0.5*(exp(0.5*Pe*(1-u)*x').*erfc(h*(R*x'-e*u*t0))+exp(0.5*Pe*(1+u)*x').*erfc(h*(R*x'+e*u*t0)));
        hh = plot(x,u1,y(mod(i,7)+1)); 
        hold on;
    end
    xlabel('Distance {\it\xi} [-]'); 
else
    %Breakthrough curves     
    x = linspace (1/N,1,N);
    t = linspace (T/M,T,M);    
    h = diag(1./(2.*sqrt(t/Pe)));
    for i = 1:size(x,2)
        x0 = x(i);
        u1 = c0*exp(-Da*t').*(e-0.5*erfc(h*(e*x0-t'))-0.5*exp(Pe*x0)*erfc(h*(e*x0+t')))+...
        c1*0.5*(exp(0.5*Pe*(1-u)*x0)*erfc(h*(e*x0-u*t'))+exp(0.5*Pe*(1+u)*x0)*erfc(h*(e*x0+u*t')));
        hh = plot(t,u1,y(mod(i,7)+1));
        hold on; 
    end
    xlabel('Time {\it\tau} [-]');
end
ylabel('Concentration {\it\theta} [-]');
set (hh,'LineWidth',2);
hold on;
