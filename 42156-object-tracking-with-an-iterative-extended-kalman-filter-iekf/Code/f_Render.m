% function to display a frame of the simulation 
% Input:
% x  = [xc xcd zc zcd p1 p2 w].'
% pf - plot flag
function f_Render(x,obs,pf)

if pf == 1
    figure;
    %pos = get(gcf,'Position');
    %set(gcf,'Position',[pos(1)-100 pos(2)-200 1.5*pos(3) 1.5*pos(4)]);
end

load avar % r1,r2, L, and T

% unpack
xc = x(1); zc = x(3); p1 = x(5); p2 = x(6);

% match point 1
mp1 = [xc+r1*cos(p1) zc+r1*sin(p1)];

% match point 2
mp2 = [xc+r2*cos(p2) zc+r2*sin(p2)];

% plot  
hold on; 

% the object
line([xc mp1(1)],[zc mp1(2)],'LineWidth',2); 
line([xc mp2(1)],[zc mp2(2)],'LineWidth',2);

% to the focal point
line([mp1(1) 0],[mp1(2) 0],'LineStyle','--');
line([mp2(1) 0],[mp2(2) 0],'LineStyle','--');

% image plane
line([-50 50],[L L],'Color','r'); 

% observed 
plot(obs(1,1),L,'.',obs(2,1),L,'.')

hold off; grid on; axis([-55 55 0 110]);