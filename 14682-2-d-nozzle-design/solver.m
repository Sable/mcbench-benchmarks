%   ****** See nozzle.m for instructions ******
%   solver.m

%   Solver for the macormack method
function [Q] = solver(Q)
global gamma R

[u,v,rho,p,e,T,ss,F,G] = flowvars(Q);

%   Take one MacCormack step
[Q] = mac(Q);

end


%%%%%%%%    flowvars    %%%%%%%%
function [u,v,rho,p,e,T,ss,F,G] = flowvars(Q)
global gamma R

%	Calculate the actual flow variables at each time step
rho = Q(:,:,1);
u = Q(:,:,2)./rho;
v = Q(:,:,3)./rho;
e = Q(:,:,4);
p = (gamma-1)*(e-(1/2)*rho.*(u.*u+v.*v));
T = p./(R*rho);
ss = sqrt(abs(gamma*R*T));
 
F(:,:,1) = rho.*u;
F(:,:,2) = rho.*u.*u + p;
F(:,:,3) = rho.*u.*v;
F(:,:,4) = (e+p).*u;

G(:,:,1) = rho.*v;
G(:,:,2) = rho.*u.*v;
G(:,:,3) = rho.*v.*v + p;
G(:,:,4) = (e+p).*v;

end    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%    mac    %%%%%%%%

function [Q] = mac(Q)
global gamma R

Q0 = Q;

%	Forward flux
[Qflux,dt] = flux_mc(Q,-1);
Qbar = Q - dt*Qflux;  
Q = Qbar;

[Q] = boundary(Q);

%	Backward flux
[Qflux,dt] = flux_mc(Q,0);
Q = (1/2)*(Q0 + Qbar - dt*Qflux );

[Q] = boundary(Q);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%    flux_mc    %%%%%%%%

function [Qflux,dt] = flux_mc(Q,dd)
global x y Vol cfl

[u,v,rho,p,e,T,ss,F,G] = flowvars(Q);
nx = size(x,1);
ny = size(x,2);

a(1:nx+1,1:ny+1) = 0;
b(1:nx+1,1:ny+1) = 0;
c(1:nx+1,1:ny+1) = 0;
Qflux(1:nx+1,1:ny+1,1:4) = 0;

%	Get the fluxes
for i = 2: size(x,1)
    for j = 2: size(x,2)

	ii = i-1;
    jj = j-1;
    
    %	Right face
	sfpx = y(ii+1,jj+1)-y(ii+1,jj);
    sfpy = -( x(ii+1,jj+1)-x(ii+1,jj) );
    
	%	Left face
    sfmx = -( y(ii,jj+1) - y(ii,jj) );
    sfmy = ( x(ii,jj+1)-x(ii,jj) );

    %	Top face
    sgpx = -( y(ii+1,jj+1) - y(ii,jj+1) );
    sgpy = x(ii+1,jj+1) - x(ii,jj+1);

    %	Bottom face
    sgmx = ( y(ii+1,jj)-y(ii,jj) );
    sgmy = -( x(ii+1,jj) - x(ii,jj) );

	%	Get the flux
	Qflux(i,j,:) = ( F(i+1+dd,j,:)*sfpx + G(i+1+dd,j,:)*sfpy + ...
   		F(i+dd,j,:)*sfmx + G(i+dd,j,:)*sfmy + F(i,j+1+dd,:)*sgpx ...
        + G(i,j+1+dd,:)*sgpy + F(i,j+dd,:)*sgmx + G(i,j+dd,:)*sgmy );
	
	%	Normalize by Volume
    Qflux(i,j,:) = Qflux(i,j,:)./Vol(i,j);
    
	%	CFL terms
    a(i,j) = abs(u(i,j)*sfpx + v(i,j)*sfpy);
    b(i,j) = abs(u(i,j)*sgpx + v(i,j)*sgpy);
    c(i,j) = ss(i,j)*sqrt(abs( sfpx^2 + sfpy^2) ...
        + abs( sgpx^2 + sgpy^2) );
    
    end
end

dt = max(max((a+b+c)./Vol));
dt = cfl/dt;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%    boundary    %%%%%%%%

function [Q] = boundary(Q)
global x y gamma R P_amb T_c
[u,v,rho,p,e,T,ss,F,G] = flowvars(Q);

%   Problem boundary conditions here
nx = size(x,1);
ny = size(x,2);

%	Top Wall
p(:,ny+1) = p(:,ny);
v(:,ny+1) = 0;
u(:,ny+1) = 0;
rho(:,ny+1) = rho(:,ny);
    
%   Symmetry line
p(:,1) = p(:,2);
v(:,1) = -v(:,2);
u(:,1) = u(:,2);
rho(:,1) = rho(:,2);

%	Inflow-shouldn't change from initialization
u(1,:) = sqrt(gamma*R*T_c);
v(1,:) = v(2,:);

%	Out flow - set to upstream cells
u(nx+1,:) = u(nx,:);
v(nx+1,:) = v(nx,:);
p(nx+1,:) = p(nx,:);  %P_amb;
rho(nx+1,:) = rho(nx,:);

%	EOS
e = p/(gamma-1) + (1/2)*rho.*(u.*u + v.*v);

Q(:,:,1) = rho;
Q(:,:,2) = rho.*u;
Q(:,:,3) = rho.*v;
Q(:,:,4) = e;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
