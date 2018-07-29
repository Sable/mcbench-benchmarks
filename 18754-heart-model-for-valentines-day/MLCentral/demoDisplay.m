function demoDisplay
% This demo displays the generation of heart and also the possible re-shape and movement

% by Xin Zhao
% Feb 14, 2008
close all;

[x,y,z] = heart;
bottomZ = min(z(:));
radius = abs(bottomZ);

axis vis3d
axis off
daspect([1.6, 1, 1.875]);
hold on;
markerColor = [0.5, 0.5, 0.5];
lineColor = [0.7, 0.7, 0.7];

figWidth = 800
figHeight = 600;
screenSize = get(0, 'ScreenSize');
X0 = (screenSize(3)-figWidth)/2;
Y0 = (screenSize(4)-figHeight)/2;
set(gcf, 'Position', [X0,Y0, figWidth, figHeight]);

camtarget([0, 0, 0]);
set(gcf,'Renderer','zbuffer');
set(gcf,'DoubleBuffer','on');
% RGB(255 105 180) is for pink color
set(gcf, 'color', [255 105 180]/255);


startAZ = 30;
satrtEL = 20;
view(startAZ, satrtEL);

% draw points
for iLoop = 1:size(x, 1)
    plot3(x(iLoop, :), y(iLoop,:), z(iLoop, :), 'Marker', '.', 'MarkerEdgeColor', markerColor, 'LineStyle', 'none');
    pause(0.2);
end

% draw wire frames
for iLoop = 1:size(x, 1)
    plot3(x(iLoop, :), y(iLoop,:), z(iLoop, :), 'color', lineColor, 'LineStyle', '-');
    pause(0.2);   
end

for iLoop = 1:size(x, 2)
    plot3(x(:, iLoop), y(:, iLoop), z(:, iLoop), 'color', lineColor, 'LineStyle', '-');
    pause(0.2);  
end

% rotate wire frame
for i=1:36
	camorbit(10,0,'data');
	pause(0.1);   
end
% clean the curent axes
delete(get(gca, 'Children'));

camlight left;
newLineColor = [0.7, 0.4, 0.4];

% re-draw the whole heart with surf function
h = surf(x,y,z, 'EdgeColor', newLineColor, 'FaceColor', 'r');
for i=1:36
	camorbit(10,0,'data');
	pause(0.1);
end

mediumColor = [0.8, 0.3, 0.3];
set(h, 'EdgeColor', mediumColor,'FaceLighting','gouraud');
for i=1:36    
	camorbit(10,0,'data');
	drawnow;
end

set(h, 'EdgeColor', 'none');
drawnow;

% define the Z-path for heart re-shape
deltaZ = linspace(-.3, 0, 5);
deltaZ = [fliplr(deltaZ), deltaZ];
deltaZ = repmat(deltaZ, 1, 3);
zlim('manual');
for iLoop = 1:length(deltaZ)    
    % draw the bouncing heart
    curDeltaZ = deltaZ(mod(iLoop,length(deltaZ))+1);
    ratio = (radius+curDeltaZ)*radius;
    newZ = z*ratio + curDeltaZ;
    
    if exist('h', 'var')&& ishandle(h), delete(h);end;
    h = surf(x,y, newZ, 'EdgeColor', 'none', 'FaceColor', 'r','FaceLighting','gouraud');
    camorbit(-1, 0, 'data');
    drawnow;
end

% draw the bouncing heart
deltaZ = generateSimulatedBouncingPath;
zlim([-1, 3]);
for iLoop = 1:length(deltaZ)
    
    if exist('h', 'var')&& ishandle(h), delete(h);end;
    
    curDeltaZ = deltaZ(iLoop);
    if curDeltaZ < 0
        % when deltaZ is under the zero bar, it's hitting the ground
        ratio = (radius+curDeltaZ)*radius;
        newZ = z*ratio + curDeltaZ;
    else
        % when deltaZ is bigger than zero, it's a free object
        newZ = z + curDeltaZ;
    end  

    h = surf(x, y, newZ, 'EdgeColor', 'none', 'FaceColor', 'r','FaceLighting','gouraud');
    
    % zoom in and out for more vivid effect
    if iLoop <= length(deltaZ)/2
        camzoom(0.99);
    else
        camzoom(1.005);
    end
    
    camorbit(390/length(deltaZ), 0, 'data');
    drawnow;
end