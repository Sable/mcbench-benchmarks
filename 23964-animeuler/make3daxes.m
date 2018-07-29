function as = make3daxes(h)
% make3daxes creates a dextral set of coordinate axes for animation.
% 
% as = make3daxes returns an array (as) continaing handles to three surface
% objects created in figure h representing the unit vectors of a dextral
% reference frame.
%
% Note: This function is intended to be called by animEuler.m
% 
% Examples:  
%     as = make3daxes(1);

% Written by Dmitry Savransky 29 April 2009

%set figure and remove all children
figure(h);
clf(h,'reset');
hold off

%create an axis
[xrod,yrod,zrod] = cylinder(0.05,12);

%create and place the axes
a3 = surface(xrod,yrod,zrod,'FaceColor','b','AlphaData',0.5);
a2 = surface(xrod,yrod,zrod,'FaceColor','g','AlphaData',0.5);
a1 = surface(xrod,yrod,zrod,'FaceColor','r','AlphaData',0.5);
rotate(a2,[1 0 0],-90,[0,0,0])
rotate(a1,[0 1 0],90,[0,0,0])

%clean up display
axis equal;
axis([-1 1 -1 1 -1 1])
view(100,15)
grid on
xlabel('x');
ylabel('y');
zlabel('z');

%return handles
as = [a1 a2 a3];
