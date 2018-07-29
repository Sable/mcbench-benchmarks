%This file solves the system equations for the final position of the
%spheres for a single external magnetic field value. The position of each
%sphere is then plotted. 

%Kilian O'Donoghue

%31st July 2013

clc
close all

global n B_mag_ext theta_B_ext Ms

%Define parameters
B_mag_ext=2.5e-3;
theta_B_ext=pi/2;
Ms=1.32/u0;%Remnant flux density of magnet divided by permeability


%Equation solver
vars_0=0*ones(1,2*n+1); %define initial guess of the variables phi, psi and gamma, normally all set to 0
options=optimset('Display','iter','TolFun',1e-10); %Define options for solver, Function tolerance being the most important
[var_min,F,exitflag,output] = fsolve(@Sphere_energy_function,vars_0,options); %Solve using non-linear equation solver
%The vector var_min stores the solution of the solver

%Plotting the results

%First generate circular groups of points to plot the outline of each
%sphere
theta_rev=linspace(0,2*pi,100);
x_circle0=a.*cos(theta_rev);
y_circle0=a.*sin(theta_rev);

%Extract the values of the vectors phi, psi and gamma from the solver
%output var_min.

phi_min=var_min(1:n);
psi_min=var_min((n+1):2*n);
gamma_min=var_min(length(var_min));

%Convert the phi variable into the centre points of each sphere

x_min(1)=2*a*cos(phi_min(1));
y_min(1)=2*a*sin(phi_min(1));

for i=2:n;
    x_min(i)=x_min(i-1)+2*a*cos(phi_min(i));
    y_min(i)=y_min(i-1)+2*a*sin(phi_min(i));
end

%now plot each sphere outline with circles
figure
hold on
plot(x_circle0,y_circle0)
quiver(x0,y0,1,0,.001)

for i=1:n;
    plot(x_circle0+x_min(i),y_circle0+y_min(i),'r') %mover through each centre point and plot a circle
    quiver(x_min(i),y_min(i),cos(psi_min(i)),sin(psi_min(i)),.001) %Using quiver or arrows to show magnetisation direction
    
end
    axis([-2*(n+1)*a 2*(n+1)*a -2*(n+1)*a 2*(n+1)*a]); %set the axis area
    axis square
    
    xlabel ('x [m]')
    ylabel( 'y [m]')