function axesLabelsAlign3D
% Note: This function is taken from internet.
%Author: M Arthington
%Date: 02/05/2010
%Set the x and y axis labels of the current axes to be aligned to
%the orientation of the axes.
%This is intended to be used when the rotate3d command has been used.
[az,el] = view;
Raz = [cosd(az) sind(az) 0;-sind(az) cosd(az) 0;0 0 1];
Rel = [1 0 0;0 cosd(el) -sind(el);0 sind(el) cosd(el)];
%Calculate current orientation of x and y axes in view coordinates
xax = Rel*Raz*[1;0;0];yax = Rel*Raz*[0;1;0];
%Project x and y into current viewing plane
n1=cross(xax,[0;1;0]);x = cross([0;1;0],n1);
n1=cross(yax,[0;1;0]);y = cross([0;1;0],n1);
%If the view will show this label, orientate it to be aligned with the 
%axis direction. Otherwise set its rotation to 0 (default).
if any(x)
	set(get(gca,'xlabel'),'rotation',atand(x(3)/x(1)));
else
	set(get(gca,'xlabel'),'rotation',0);
end
if any(y)
	set(get(gca,'ylabel'),'rotation',atand(y(3)/y(1)));
else
	set(get(gca,'ylabel'),'rotation',0);
end