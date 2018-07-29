function axesLabelsAlign3D(~,~)
%function axesLabelsAlign3D
%Set the x and y axis labels of the current axes to be aligned to
%the orientation of the axes.
%Author: M Arthington
%Date: 02/05/2010
%
%Example 1, apply to current axes:
%axesLabelsAlign3D
%
%Example 2, execute in current axes after each rotation:
%h=rotate3d;
%set(h,'ActionPostCallback',@axesLabelsAlign3D);
%
%Updated 14 June 2011:
%The axes must be of equal size in order for this function to work correctly.
%i.e. run: axis equal, before running this function
%The position of the labels may not be where one would expect, but they should be rotationally
%correct. The labels can be translated graphically to fix positioning issues.
%Matlab decides where the position of the labels should be.
%The function has also been updated to allow camera roll too. This means that the z
%axis label will also be rotated.
%Updated 30 January 2012:
%Updated help with examples. Fixed typos in help and warning message,
%functionally unchanged.

if ~all(get(gca,'DataAspectRatio') == 1)
	warning('Axes must be set equal size for axesLabelsAlign3D to work correctly (use: axis equal). Not aligning axes');
else
	[az,el] = view;
	
	Raz = [cosd(az) sind(az) 0;...
		-sind(az) cosd(az) 0;...
		0 0 1];
	
	Rel = [1 0 0;...
		0 cosd(el) -sind(el);
		0 sind(el) cosd(el)];
	
	u=get(gca,'CameraUpVector');
	
	if ~(u(1)==0 && u(2)==0 && u(3)==1)
		p=get(gca,'CameraPosition');
		t=get(gca,'CameraTarget');
		v=(p-t);
		v=v/norm(v);%View vector from camera to target
		u = u/norm(u);%Camera up vector
		q = cross(v,u);
		q=q/norm(q);
		
		%Get the x axis's projection into the view plane and then find its angle wrt the up vector
		xH = cross([1;0;0],v);
		xH = xH/norm(xH);
		xH = cross(xH,v);
		thetax = -acosd(dot(xH,u))+90;
		
		%Check which way the label needs to be rotated
		if dot(q,xH)>0
			thetax = -thetax;
		end
		
		%Get the y axis's projection into the view plane and then find its angle wrt the up vector
		yH = cross([0;1;0],v);
		yH = yH/norm(yH);
		yH = cross(yH,v);
		thetay = -acosd(dot(yH,u))+90;
		if dot(q,yH)>0
			thetay = -thetay;
		end

		%Get the z axis's projection into the view plane and then find its angle wrt the up vector
		zH = cross([0;0;1],v);
		zH = zH/norm(zH);
		zH = cross(zH,v);
		thetaz = -acosd(dot(zH,u))+90;
		
		if dot(q,zH)>0
			thetaz = -thetaz;
		end
		
	else %When rotate3d has been used, the up vector isn't set by matlab correctly
		%Calculate current orientation of x and y axes in view coordinates
		xax = Rel*Raz*[1;0;0];
		yax = Rel*Raz*[0;1;0];
		
		%Project x and y into current viewing plane
		n1=cross(xax,[0;1;0]);
		x = cross([0;1;0],n1);
		
		n1=cross(yax,[0;1;0]);
		y = cross([0;1;0],n1);
		
		thetax = atand(x(3)/x(1));
		thetay = atand(y(3)/y(1));
		if ~any(x)
			thetax = 0;
		end
		if ~any(y)
			thetay = 0;
		end
		thetaz = 90;
	end
	
	%Orientate these labels to be aligned with the
	%axis directions.
	set(get(gca,'xlabel'),'rotation',thetax);
	set(get(gca,'ylabel'),'rotation',thetay);
	set(get(gca,'zlabel'),'rotation',thetaz);

end
end