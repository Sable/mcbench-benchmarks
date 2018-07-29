%   ****** See nozzle.m for instructions ******
%   With the given grid from the nozzle code solve the flow 
%   using MacCormack's finite volume method

%   CFD Portion parameters
cfl = .8;   %  Courant-Friedricks-Lewy stability factor (<1)
tt = 500;    %  Number of time steps to take
init = 1;   %  Initialize or use previous run's data? [1-init 0-previous]
visit = 0;  %  Output viz file? [1-yes 0-no]

%   Make some variables global
global gamma R x y cfl P_amb Vol T_c;

%   Initialize the domain here
if (init == 1)
    n = size(x,1);
    m = size(x,2);
    p(1:n+1,1:m+1) = P_c*(1+(gamma-1)/2)^(-gamma/(gamma-1));
    T(1:n+1,1:m+1) = T_c;
    u(1:n+1,1:m+1) = 1.25*M_e*sqrt(gamma*R*T_c);
    v(1:n+1,1:m+1) = 0;
    rho = p./(R.*T);
    e = p/(gamma-1) + (1/2)*rho.*(u.*u + v.*v);

    %   Cast into conservation form
    Q(:,:,1) = rho;     %  Conservation of Mass
    Q(:,:,2) = rho.*u;  %  Conservation of X-Momentum
    Q(:,:,3) = rho.*v;  %  Conservation of Y-Momentum
    Q(:,:,4) = e;       %  Conservation of Energy

    %	Get and store the volumes and surface flux terms
    Vol(1:size(x,1)+1,1:size(x,2)+1) = 1;
    for i=1 : n-1
        for j=1 : m-1
    	side1 = ( x(i,j)-x(i+1,j) )*y(i+1,j+1) + ( x(i+1,j)-x(i+1,j+1) )*y(i,j)...
            + ( x(i+1,j+1)-x(i,j) )*y(i+1,j);
        side2 = ( x(i,j)-x(i+1,j+1) )*y(i,j+1) + ( x(i+1,j+1)-x(i,j+1) )*y(i,j)...
            + ( x(i,j+1)-x(i,j) )*y(i+1,j+1);
        Vol(i+1,j+1) = (1/2)*( abs(side1) + abs(side2) );
        end
    end

end

%   Main iteration loop for integration in time
for k = 1: tt
    Q = solver(Q);  %  Call the solver to advance one time step
    k               %  Leave here for iteration counter
end

%   Get the flow variables back from conserved variables
rho = Q(:,:,1);
u = Q(:,:,2)./rho;
v = Q(:,:,3)./rho;
e = Q(:,:,4);
p = (gamma-1)*(e-(1/2)*rho.*(u.*u+v.*v));
T = p./(R*rho);
ss = sqrt(abs(gamma*R*T));
Mach = sqrt(u.^2 + v.^2)./ss;

%   Plot the mesh and the local Mach number of flow
figure(3);clf;
surf(x,y,Mach(1:size(p,1)-1,1:size(p,2)-1));view(0,90);
hold on;surf(x,-y,Mach(1:size(p,1)-1,1:size(p,2)-1));view(0,90);

%   Plot the pressure and Mach number plot on axis
figure(1);hold on;plot(x(:,1),p(1:size(p,1)-1,1)/P_amb,'b')
hold on;plot(x(:,1),Mach(1:size(p,1)-1,1),'r')
legend('Mach Number','P/P_a_m_b','M_e_x_i_t(predicted)',...
    'P_a_m_b/P_a_m_b','CFD-Mach','CFD-P/P_a_m_b')


%   Write a file for Tecplot* or VisIT~ 
%   *TecPlot is a commercial CFD visualization package
%   ~VisIT is a free CFD visualization package and is very good.
%       Can be downloaded here: (www.llnl.gov/visit)

if (visit == 1)
    
    %   Header so prgrams recognize the data format
    dlmwrite('visit.tec','VARIABLES="X","Y","Pressure","Mach" ZONE I=','delimiter','')
    dlmwrite('visit.tec',size(x,1),'delimiter','','-append')
    dlmwrite('visit.tec',',J=','delimiter','','-append')
    dlmwrite('visit.tec',size(x,2),'delimiter','','-append')
    dlmwrite('visit.tec',',F=POINT','delimiter','','-append')

    %   Loop through the data
    for j = 1: size(y,2)
        for i = 1:size(y,1)
            dlmwrite('visit.tec',x(i,j),'delimiter','','-append')
            dlmwrite('visit.tec',y(i,j),'delimiter','','-append')
            dlmwrite('visit.tec',p(i,j),'delimiter','','-append') 
            dlmwrite('visit.tec',Mach(i,j),'delimiter','','-append') 
        end
    end

end
