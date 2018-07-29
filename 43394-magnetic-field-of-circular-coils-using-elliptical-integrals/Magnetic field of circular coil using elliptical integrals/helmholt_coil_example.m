%Demo of a two coil Helmholtz setup using the magnetic field function.
%This is simpply two coils placed a radius distance apart, both carrying
%the same current which results in a uniform field in the centre of the
%coils.

%Kilian O'Donoghue
%30th July 2013

clc
clear
close all

%Define global variables
global u0

u0=4*pi*1e-7; %permeability of free space

%Define coil parameters

I0=1; %Coil current in Amps
a=.1; %Coil radius in m

x_p1=0; y_p1=0; z_p1=0; %Define coordinates of coil 1 center point
x_p2=0; y_p2=0; z_p2=a; %Define coordinates of coil 2 center point


%input mesh of points in 2D plane

x=0; [y,z]=meshgrid(linspace(-.05,.05,25),linspace(0,.1,25)); %this is a 2d plane over the x=0 plane that extends away from the coils in the yz plane.

[Bx1,By1,Bz1] = magnetic_field_current_loop(x,y,z,x_p1,y_p1,z_p1,a,I0); %Calculate field from first coil
[Bx2,By2,Bz2] = magnetic_field_current_loop(x,y,z,x_p2,y_p2,z_p2,a,I0); %Calculate field from second coil


%Add the components
Bx=Bx1+Bx2;
By=By1+By2;
Bz=Bz1+Bz2;

%Calculate the magnitude of the vector
B_mag=sqrt(Bx.^2+By.^2+Bz.^2);

figure
surf(y,z,B_mag)
xlabel('y [m]')
ylabel('z [m]')
zlabel('B [T]')
title('2D magnetic field tests')
colorbar %add colorbar
shading flat %Removes black lines from the mesh
