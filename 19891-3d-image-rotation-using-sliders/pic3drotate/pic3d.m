function pic3d
clc
% load a standard MATLAB data set
load clown;
% determine size of image
X=X(1:5:end,1:5:end); % the image dimensions has been decreased to decrease the delay time
[c,r] = size(X);
% create values for surface's XData, YData, and ZData
[z,y] = meshgrid(1:c,1:r);
x = zeros(size(z));
% create surface
h=surf(x,y,z,X,'FaceColor','texturemap','EdgeColor','none');

xlabel('x')
ylabel('y')
zlabel('z')

% the elevation slider
rr=findobj(gcf,'Tag','slider1');
el=get(rr,'value');
% the Azimuth slider
rr=findobj(gcf,'Tag','slider2');
az=get(rr,'value');
% view(-35,30)% defult value of view
view(-35+az,30+el)

% the x-axis rotation slider
rr=findobj(gcf,'Tag','slider3');
rx=get(rr,'value');
% the y-axis rotation slider
rr=findobj(gcf,'Tag','slider4');
ry=get(rr,'value');
% the z-axis rotation slider
rr=findobj(gcf,'Tag','slider5');
rz=get(rr,'value');

center=[0,floor(c/2),floor(r/2)];
rotate(h,[1 0 0],rx,center)%about x axis
rotate(h,[0 1 0],ry,center)%about y axis
rotate(h,[0 0 1],rz,center)%about z axis

axis square