function [ Blade ] = Make_Blade(x,y,rR,R,psi,theta,beta,zeta )
%MAKE_BLADE Summary of this function goes here
%  Detailed explanation goes here

%######################################################### Creating the Blade #########################################################
[Blade(1) Blade(2) Blade(3)]=Extrude(x,y,rR,R,'y','closed');

set(Blade,'EdgeAlpha',0)
hold on

Blade(4)=Cylinder([0 0 0],0.8,rR,'y',20,'open' );
xlabel('x')
ylabel('y')
axis equal
% axis off

% ######################################################### Rotating the Blade #########################################################

rotate(Blade,[0 1 0],theta,[0 0 0])
rotate(Blade,[1 0 0],beta,[0 0 0])
rotate(Blade,[0 0 1],-90+psi-zeta,[0 0 0])