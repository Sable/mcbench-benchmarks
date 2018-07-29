%This file demonstrates the use of the function
%"magnetic_field_current_loop.m".

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

x_p=0; y_p=0; z_p=0; %Define coordinates of coil center point

%First we see how to calculate the magnetic field at a single point in
%space

%Input test point
x=0; y=0; z=.1;

[Bx,By,Bz] = magnetic_field_current_loop(x,y,z,x_p,y_p,z_p,a,I0)

%Now showing how to calculate points along a straigh line

clear x y z

%Input vector of points

x=0; y=0; z=linspace(0,.25,100); %These default coordinates calculates the magnetic field along the z axis through the center of the coil

[Bx,By,Bz] = magnetic_field_current_loop(x,y,z,x_p,y_p,z_p,a,I0);

figure
plot(z,Bz)
xlabel('z [m]')
ylabel('Bz [T]')
title('1D magnetic field tests')

%now we test how to calculate a 2D grid of points

clear x y z

%input mesh of points in 2D plane

x=0; [y,z]=meshgrid(linspace(-.05,.05,25),linspace(0,.1,25)); %this is a 2d plane over the x=0 plane that extends away from the coils in the yz plane.

[Bx,By,Bz] = magnetic_field_current_loop(x,y,z,x_p,y_p,z_p,a,I0);

figure
surf(y,z,Bz)
xlabel('y [m]')
ylabel('z [m]')
zlabel('Bz [T]')
title('2D magnetic field tests')
colorbar %add colorbar
shading flat %Removes black lines from the mesh

%NOTE: This code can also be used to calculate the magnetic field due to
%distributed windings by simply treating each winding as a separate loop
%and calculate them individually, then add up the resulting field values.