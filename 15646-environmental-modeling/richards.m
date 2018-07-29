function richards
% Solution of the Richards equation     
%    using MATLAB pdepe                   
%
%   $Ekkehard Holzbecher  $Date: 2006/07/13 $
%
% Soil data for Guelph Loam (Hornberger and Wiberg, 2005)
% m-file based partially on a first version by Janek Greskowiak 
%--------------------------------------------------------------------------
L = 200;                  % length [L]
s1 = 0.5;                 % infiltration velocity [L/T]
s2 = 0;                   % bottom suction head [L]
T = 4;                    % maximum time [T]
qr = 0.218;               % residual water content 
f = 0.52;                 % porosity
a = 0.0115;               % van Genuchten parameter [1/L]
n = 2.03;                 % van Genuchten parameter
ks = 31.6;                % saturated conductivity [L/T]

x = linspace(0,L,100);
t = linspace(0,T,25);

options=odeset('RelTol',1e-4,'AbsTol',1e-4,'NormControl','off','InitialStep',1e-7)
u = pdepe(0,@unsatpde,@unsatic,@unsatbc,x,t,options,s1,s2,qr,f,a,n,ks);

figure; 
title('Richards Equation Numerical Solution, computed with 100 mesh points');

subplot (1,3,1);
plot (x,u(1:length(t),:)); 
xlabel('Depth [L]');
ylabel('Pressure Head [L]');

subplot (1,3,2);
plot (x,u(1:length(t),:)-(x'*ones(1,length(t)))');
xlabel('Depth [L]');
ylabel('Hydraulic Head [L]');

for j=1:length(t)
    for i=1:length(x)
        [q(j,i),k(j,i),c(j,i)]=sedprop(u(j,i),qr,f,a,n,ks); 
    end 
end
 
subplot (1,3,3);
plot (x,q(1:length(t),:)*100)
xlabel('Depth [L]');
ylabel('Water Content [%]');

% -------------------------------------------------------------------------
function [c,f,s] = unsatpde(x,t,u,DuDx,s1,s2,qr,f,a,n,ks)
[q,k,c] = sedprop(u,qr,f,a,n,ks);
f = k.*DuDx-k;
s = 0;
% -------------------------------------------------------------------------
function u0 = unsatic(x,s1,s2,qr,f,a,n,ks)
u0 = -200+x; 
if x < 10 u0 = -0.5; end

% -------------------------------------------------------------------------
function [pl,ql,pr,qr] = unsatbc(xl,ul,xr,ur,t,s1,s2,qr,f,a,n,ks)
pl = s1; 
ql = 1; 
pr = ur(1)-s2;
qr = 0;

%------------------- soil hydraulic properties ----------------------------
function [q,k,c] = sedprop(u,qr,f,a,n,ks)
m = 1-1/n;
if u >= 0 
    c=1e-20;
    k=ks;
    q=f;
else
    q=qr+(f-qr)*(1+(-a*u)^n)^-m;
    c=((f-qr)*n*m*a*(-a*u)^(n-1))/((1+(-a*u)^n)^(m+1))+1.e-20;
    k=ks*((q-qr)/(f-qr))^0.5*(1-(1-((q-qr)/(f-qr))^(1/m))^m)^2;
end



  
