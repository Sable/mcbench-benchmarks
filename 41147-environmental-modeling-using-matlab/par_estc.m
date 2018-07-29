function par_estc   
% transport parameter estimation with derivatives             Holzbecher January 2006

global xfit cfit T D c0 c1

% Example values for Chlorid in Marmara Sea Sediment Core              
T = 3.15e11;  % [s] 10.000 years 
D = 1.0e-5;  % [cm*cm/s]
c0 = 0;      % [mmol/l]
c1 = 619;    % [mmol/l]
xmax = 4000; % [cm]

% specify fitting data
xfit = [0 20 40 60 100 120 140 160 215 255 275 300 375 450 525 600 750 1050 1200 1350 1650 1950 2250 2550 2700 3000 3450 3900];
cfit = [619 597 608 615 619 615 621 571 621 618 619 625 577 612 608 612 609 590 582 582 556 494 457 489 487 444 381 371];

x = [0:xmax/400:xmax];
options = optimset('Display','iter','TolFun',1e-9);
v = fzero(@myfun,0.2e-8,options);
display (['Best fit for v = ' num2str(v)]);

h = 1./(2.*sqrt(D*T)); e = diag(eye(size(x,2))); 
plot (xfit,cfit,'o',x,c0+0.5*c1*(erfc(h*(x-v*T*e'))+(exp((v/D)*x)).*erfc(h*(x+v*T*e'))),'-');
legend ('given','modelled');
xlabel ('depth [cm]'); ylabel ('chloride concentration [mmol/l]');
text(0.1*xmax,c1*0.65,['sedimentation velocity [cm/a]: ' num2str(v*3.15e7)]);
e = diag(eye(size(xfit,2))); 
normc = norm(cfit-c0+0.5*c1*(erfc(h*(xfit-v*T*e'))+(exp((v/D)*xfit)).*erfc(h*(xfit+v*T*e'))));
text(0.1*xmax,c1*0.6,['norm of residuals: ' num2str(normc)]);

function f = myfun(v) 
global xfit cfit T D c0 c1

e=diag(eye(size(xfit,2))); h=1./(2.*sqrt(D*T));
arg1 = h*(xfit-v*T*e'); arg2 = h*(xfit+v*T*e'); arg3 = (v/D)*xfit;

% solve advection diffusion equation for c with c(t=0)=c0 and c(x=0)=c1 
c = c0 + 0.5*c1*(erfc(arg1)+(exp(arg3).*erfc(arg2)));

% compute derivative of solution due to v
cv = c1*((T*h/sqrt(pi))*(exp(-arg1.*arg1)-exp(arg3).*exp(-arg2.*arg2))+0.5*(xfit/D).*exp(arg3).*erfc(arg2));

% specify function f to vanish
f = 2*(c-cfit)*cv';

