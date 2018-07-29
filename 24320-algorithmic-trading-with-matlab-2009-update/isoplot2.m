function isoplot(xx,yy,zz,u)

% min and max and range
minval=min(min(min(u)));
maxval=max(max(max(u)));
delta=maxval-minval;
num=6;
% red - these are the best sharpes ratios
red=linspace(maxval-delta/3,maxval,num);
% yellow 'fog' - these are intermediate sharpes
yell= linspace(minval+delta/4,minval+1*delta/2,num);
% % blue
blue=linspace(minval,minval+delta/5,num);
title(['Red: [',num2str(red(1)),',',num2str(red(end)),']',...
    ', yellow: [',num2str(yell(1)),',',num2str(yell(end)),']',...
    ', blue: [',num2str(blue(1)),',',num2str(blue(end)),']'])
hold on
for i=1:length(red)
    pH1= patch(isosurface(xx,yy,zz,u,red(i)));
    set(pH1,'facecolor',[0.5 0 0],'edgecolor','none','facealpha',0.95)
end

for i=1:length(yell)
    pH2= patch(isosurface(xx,yy,zz,u,yell(i)));
    set(pH2,'facecolor',[0.8 0.8 0],'edgecolor','none','facealpha',0.35)
end

for i=1:length(blue)
    pH4= patch(isosurface(xx,yy,zz,u,blue(i)));
    set(pH4,'facecolor',[0 0 0.5],'edgecolor','none','facealpha',0.5)
end
 
% lighting
lighting phong
light('pos',[-100,50,100]); 
light('pos',[50,-100,100]); 
light('pos',[-100,-100,1]); 
light('pos',[1,0,1]);

set(gca,'view',[-109,9],'projection','persp')
cameramenu
box on, grid on

hold off