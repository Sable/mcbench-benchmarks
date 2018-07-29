function threedofbuilding_sim(t,x1,x2,x3)
%Animation function for the lateral vibration of a 3-DOF building
%Written by T. Nordenholz, Fall 05
%To use, type threedofbuilding_sim(t,x1,x2,x3) where t is the time(sec) array, and x1,
%x2, and x3 are the lateral displacement (m) arrays of floors 1, 2, and 3.
%Geometrical and plotting parameters can be set within this program

%set geometric parameters
h=1;%wall heights
W=.1;%floor width
th=.1;%floor thickness
%plotting coordinates for floors
slabx=[0,0,W,W];
slaby=[-th,0,0,-th];

%wall vertical coordinate arrays
s1=linspace(0,h,100);
s2=linspace(h,2*h,100);
s3=linspace(2*h,3*h,100);

% set up and  initialize plots

figure('Units','Normalized','Position',[0,.1,1,.8]);

%plot for x1 vs t
Ha_plot1=subplot('Position',[.5 .1 .4 .2]);
axis([t(1) t(end) -W W]),grid on;xlabel('t (sec)'),ylabel('x1 (m)')
Hl_plotx1=line(t(1),x1(1),'Color','b');

%plot for x2 vs t
Ha_plot2=subplot('Position',[.5 .4 .4 .2]);
axis([t(1) t(end) -W W]),grid on;xlabel('t (sec)'),ylabel('x2 (m)')
Hl_plotx2=line(t(1),x2(1),'Color','r');

%plot for x3 vs t
Ha_plot3=subplot('Position',[.5 .7 .4 .2]);
axis([t(1) t(end) -W W]),grid on;xlabel('t (sec)'),ylabel('x3 (m)')
Hl_plotx3=line(t(1),x3(1),'Color','g');

%animation
Ha_anim=subplot('Position',[.1,.1,.3,.8]);
axis([-W 2*W 0 4*h]),grid on;
%draw 1st floor walls
v1=x1(1)*(-2*s1.^3/h^3+3*s1.^2/h^2);
Hl_Lwall1=line(v1,s1,'Color','k','Linewidth',3);
Hl_Rwall1=line(v1+W,s1,'Color','k','Linewidth',3);
Hp_floor1=patch(slabx+x1(1),slaby+h,'b');
%draw 1st floor walls
v2=x1(1)+(x2(1)-x1(1))*(-2*(s2-h).^3/h^3+3*(s2-h).^2/h^2);
Hl_Lwall2=line(v2,s2,'Color','k','Linewidth',3);
Hl_Rwall2=line(v2+W,s2,'Color','k','Linewidth',3);
Hp_floor2=patch(slabx+x2(1),slaby+2*h,'r');
%draw 3rd floor walls
v3=x2(1)+(x3(1)-x2(1))*(-2*(s3-2*h).^3/h^3+3*(s3-2*h).^2/h^2);
Hl_Lwall3=line(v3,s3,'Color','k','Linewidth',3);
Hl_Rwall3=line(v3+W,s3,'Color','k','Linewidth',3);
Hp_floor3=patch(slabx+x3(1),slaby+3*h,'g');

%draw initial plots and hold
drawnow 
tic;while toc<1,end
tic

%Run animation
for n=1:length(t)
    %plots
    set(Hl_plotx1,'XData',t(1:n),'YData',x1(1:n));
    set(Hl_plotx2,'XData',t(1:n),'YData',x2(1:n));
    set(Hl_plotx3,'XData',t(1:n),'YData',x3(1:n));
    % wall shapes
    v1=x1(n)*(-2*s1.^3/h^3+3*s1.^2/h^2);
    v2=x1(n)+(x2(n)-x1(n))*(-2*(s2-h).^3/h^3+3*(s2-h).^2/h^2);
    v3=x2(n)+(x3(n)-x2(n))*(-2*(s3-2*h).^3/h^3+3*(s3-2*h).^2/h^2);
    %animation
    set(Hl_Lwall1,'XData',v1);
    set(Hl_Rwall1,'XData',v1+W);
    set(Hp_floor1,'XData',slabx+x1(n));
    set(Hl_Lwall2,'XData',v2);
    set(Hl_Rwall2,'XData',v2+W);
    set(Hp_floor2,'XData',slabx+x2(n));
    set(Hl_Lwall3,'XData',v3);
    set(Hl_Rwall3,'XData',v3+W);
    set(Hp_floor3,'XData',slabx+x3(n));
    while toc<t(n),end %time delay
    drawnow
end

    
    
    
    
    







