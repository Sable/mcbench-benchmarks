function sliderc(r,L1,rec,sp)
% SLIDERC Slider Crank Mechanism
% sliderc(r,L1,rec) plots the slider crank mechanism specified and rotates it,
% where:
%
% r   : Radius of crank
% L1  : Length of piston
% rec : Side lengths of slider
% sp  : Speed of rotation
%
% Example 1:
%
% sliderc(1,3,[1,.5],.5)
%
%
% Example 2:
%
% sliderc(2,5,[5,.5],2)
%
%
% Uses the function Draw a Circle by Zhenhai Wang on the MATLAB File Exchange.
%
% numandina@gmail.com

L2=rec(1); % get horizontal side of slider
L3=rec(2); % get vertical side of slider
g=circle([0 0],r,100); % draw the crank
grid on
hold on
t=0; % originally, the angle theta is zero
	
xL1=r*cos(t); % the first piston end x location
yL1=r*sin(t); % the first piston end y location

xL2=r*cos(t)+(L1^2-yL1^2)^(1/2); % the second piston end x location (Pythagoras theorem)
yL2=0;                           % the second piston end y location

ln=line([xL1 xL2],[yL1 yL2]); % draw the piston
set([ln,g],'linewidth',3,'color','k') % format the lines
plot(0,0,'k+') % centre of crank
set(gcf,'color','w','menubar','none') % more formatting

while true % rotate indefinitely
	
	% piston start and end x and y locations, just like before
	xL1=r*cos(t);
	yL1=r*sin(t);
	xL2=r*cos(t)+(L1^2-yL1^2)^(1/2);
	yL2=0;
	
	set(ln,'xdata',[xL1 xL2],'ydata',[yL1 yL2]); % draw the piston accordingly
	
	% put coloured points at piston start and end locations and update them
	delete(findobj('marker','.'))
	plot([xL1 xL2],[yL1 yL2],'r.')
	
	% slider location points
	
	xp1=xL2; % first end x location is the same as the piston second end x location, since they are connected
	xp2=xL2+L2; % second end x location depends on the horizontal side length
	
	yp1=yL2-L3/2; %	the vertical side lengths determine the rest of the slider shape.
	yp2=yL2+L3/2;
	
	gr=[.5 .5 .5]; % RGB colour vector, [1 1 1] is white, [0 0 0] is black, so [.5 .5 .5] is grey
	
 	pl=patch([xp1,xp1,xp2,xp2],[yp1,yp2,yp2,yp1],gr); % draw the slider and paint it grey
	
 	axis([-(r+1) r+L1+L2+1 min([-(r+1),-(L3/2+1)]) max([r+1,L3/2+1])]) % adjust the axis limits
	axis equal % so that the circle would appear proper
	drawnow()  % update axes
 	delete(pl) % delete slider so it would be updated in next iteration
	t=t+.1*sp; % adjust theta for next iteration
end

end