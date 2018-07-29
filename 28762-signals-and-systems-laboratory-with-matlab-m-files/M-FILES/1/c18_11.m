% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
%  Plotting in 3-D space 


%curve
x=0:.1:100;
y=cos(x);
z=sin(x);

plot3(x,y,z)

xlabel('x')
ylabel('y=cos(x)')
zlabel('z = sin(x)')





%surface
x=1:5;
y=1:5;

[X,Y]=meshgrid(x,y)
Z=X+Y

figure
mesh(X,Y,Z)

figure
surf(X,Y,Z)
