% numerics demonstration (for decay equation)                   
%
%   $Ekkehard Holzbecher  $Date: 2011/04/10 $
%--------------------------------------------------------------------------
clear all;
Tmax = 1;
lambda = 2;
c0 = 1;

% plot analytical solution
marker='sod.sod.sod.';
plot (Tmax*[0:.01:1],c0*exp(-lambda*(Tmax*[0:.01:1])),'-r');
hold on

% compute and plot numerical solutions
deltat = .5*Tmax;
for i = 1:12
    f = 1-lambda*deltat;
    c(1) = c0;
    for j = 2:2^i+1
        c(j)=c(j-1)*f;
    end
    plot (linspace(0,Tmax,2^i+1),c,['-' marker(i)]);
    deltat=deltat/2;
    cend(i) = c(end);
end
legend ('analytical',['\Delta' 't=.5'],['\Delta' 't=.25'],['\Delta' 't=.125'],['\Delta' 't=.0625']) 
cend
    