%Kilian O'Donoghue
%31st July 2013

%This file generates the equations that need to be solved to determine the
%final location and orientation of each sphere in the chain. Each equation
%is formed by calculating the potential energy resulting from the
%interaction between the spheres, including the dipole-dipole interaction
%between spheres, the interaction with the external magnetic field, and the
%effect of magnetic anisotropy on the magnetisation of the first sphere in
%the chain that is rigidly locked in place. This energy term is then
%differenciated to form a non-linear system of equations that must be
%solved. All equations are formed using the symbolic toolbox.

clc
clear
close all

%Define the global variables.
global n d_U_d_phi d_U_d_psi phi psi B_mag_ext theta_B_ext Ms gamma d_U_d_gamma

% n= the number of spheres in the chain
% d_U_d_phi= the derivitive of the energy term with respect to the phi
% variable.
% d_U_d_psi= the derivitive of the energy term with respect to the psi
% variable.
% phi= is a vector containing the position angles of each sphere.
% psi= is a vector containing the direction of each spheres magnetisation.
% B_mag_ext= is the magnitude of the external magnetic field
% theta_B_ext= the direction of the external magnetic field in the 2D
% plane.
% Ms is the volume magnetisation of each sphere.
% gamma= Direction of the magnetisation of the first sphere due to magnetic
% anisotropy
% d_U_d_gamma= the derivitive of the energy term with respect to the gamma
% variable.

%number of balls, not including the first fixed position ball
n=3;

%Define some parameters to be symbolic variables.
syms B_mag_ext theta_B_ext Ms

%permanent magnet paramters
K=628000; %magnetic anisotropy constant.
u0=4*pi*1e-7; %permeability of free space
a=.00225; %Radius of each sphere
V_mag=(4/3)*pi*(a^3); %volume of each sphere
m=Ms*V_mag; %magnetic dipole moment

%define symbolic variable matrices

phi=sym('phi',[1 n]); %Position variables
psi=sym('psi',[1 n]); %Magnetisation direction variables
gamma=sym('gamma',1); %anistropy variable
phi0=0;% position of first sphere =0
psi0=0;% Magnetisation of first sphere, aligned with x axis
x=sym('x',[1 n]); %Define x and y coordinates of each sphere
y=sym('y',[1 n]);
x0=0; %define position of first sphere
y0=0;


%This section defines the x and y coordinates of each sphere in terms of
%its x and y components
x(1)=2*a*cos(phi(1));
y(1)=2*a*sin(phi(1));

%Note: Each position depends on the position of the previous sphere in the
%chain.
for i=2:n;
    x(i)=x(i-1)+2*a*cos(phi(i));
    y(i)=y(i-1)+2*a*sin(phi(i));
end

% Calculate the dipole dipole energy.

Udd=0; %The dipole dipole interaction energy, initially set to 0.

% Sequentially move through each sphere position and calculate the energy
% due to their separation and orientation.
for i=2:n;
    for j=1:i-1;
        rx=x(j)-x(i); %x displacement
        ry=y(j)-y(i); %y displacement
        r_mod=sqrt(rx.^2+ry.^2); %magnitude of the displacement
        U_temp=(u0*(m^2)/(4*pi*(r_mod^3)))*(cos(psi(i)-psi(j))-(3/(r_mod^2))*(cos(psi(i))*cos(psi(j))*(rx^2)...
            +sin(psi(i)+psi(j))*rx*ry+sin(psi(i))*sin(psi(j))*(ry^2))); %Dipole dipole interaction equation
        
        Udd=Udd+U_temp; %sum the energy contributions
        
    end
end

%Now add the erngy contribution of the first sphere in the chain
for j=1:n
    rx=x(j)-x0;
    ry=y(j)-y0;
    r_mod=sqrt(rx.^2+ry.^2);
    U_temp=(u0*(m^2)/(4*pi*(r_mod^3)))*(cos(gamma-psi(j))-(3/(r_mod^2))*(cos(gamma)*cos(psi(j))*(rx^2)...
        +sin(gamma+psi(j))*rx*ry+sin(gamma)*sin(psi(j))*(ry^2)));
    Udd=Udd+U_temp;
end


%Calculate the energy resulting from external magnetic fields

U_ext=0; %Define a variable to store the external energy summation.


%Ignore the first sphere one as its energy is constant, hence its derivitive is zero.
for i=1:n;
    U_temp=-m*B_mag_ext*cos(psi(i)-theta_B_ext);
    U_ext=U_ext+U_temp;
end
U_ext=U_ext-m*B_mag_ext*cos(gamma-theta_B_ext);



%Now add anisotropic energy

U_ma=V_mag.*K.*sin(gamma).^2;

U=U_ext+Udd+U_ma; %Sum ech energy term

%Define variables to store the derivitives
d_U_d_phi=sym('d_U_d_phi',[1 n]);
d_U_d_psi=sym('d_U_d_psi',[1 n]);

%Calculate the derivitive of the energy function with respect to the
%variables.
for i=1:n;
    d_U_d_phi(i)=diff(U,phi(i));
    d_U_d_psi(i)=diff(U,psi(i));
end
d_U_d_gamma=diff(U,gamma);

%The equations are then converted to matlab functions, which are more
%efficient to use. This function is then stored as an m file named
%'Sphere_energy_function.m'.
F_func=matlabFunction([d_U_d_phi d_U_d_psi d_U_d_gamma],'file','Sphere_energy_function','vars',{B_mag_ext, theta_B_ext, Ms, [phi psi gamma]});

%This function must then be edited slightly. The first line must be
%replaced with the following two lines:
%function out1 = Sphere_energy_function(in4)
%global B_mag_ext theta_B_ext Ms