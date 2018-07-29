function Animation(ivp,duration,fps,movie,arrow)
%--------------------------------------------------------------------------
% To Animate the Spring Pendulum, Equation is solved by MATLAB ode45, and
% running a loop over the time step; for every time step the position
% coordinates of the pendulum are updated.Phase plane plots of the spring
% and pendulum are plotted
%--------------------------------------------------------------------------
nframes = duration*fps; % Number of Frames
% Solving the Equation using ode45
sol=ode45(@Equation,[0 duration], ivp); 
t = linspace(0,duration,nframes);
X = deval(sol,t);
% Extract length and angle in time
%
% Spring Parameters
r = X(1,:)'; 
rdot = X(2,:)' ;
% Pendulum Parameters
Phi = X(3,:)'; 
Phidot = X(4,:)' ;
L = X(7,:)' ;
L = L(1) ;
% Position of the pendulum bob:
position = [r.*sin(Phi), -r.*cos(Phi)];
% Range of the plot for Spring Pendulum
maxr = max(abs(r));
xmin = min(position(:,1))-0.1*maxr ;
xmax = max(position(:,1))+0.1*maxr ;
ymin = min(position(:,2))-0.1*maxr ;
ymax = max([0,max(position(:,2))])+0.1*maxr;
% Figure
h = figure(1);
clf(h);
set(h,'name','The Spring Pendulum','numbertitle','off','Color','w') ;
stop = uicontrol('style','toggle','string','stop','background','white');
% Plot for Pendulum
%
subplot(121);
% Pendulum suspension point
plot(0,0,'MarkerSize',10,'Marker','^','LineWidth',5,'Color','g');
hold on
% Pendulum bob/mass
bob = plot(position(1,1),position(1,2),'MarkerSize',60,'Marker','.','Color','b');
% Pendulum string 
[xs ys] = Spring([0,0],[position(1,1),position(1 ,2)],20,L,0.1) ;
arm = plot(xs,ys,'LineWidth',2,'Color','r');
% Trajectory of the pendulum bob
path = plot(position(1,1), position(1,2),'k');
% Axes properties
axis equal ;
grid on;
axis([xmin xmax ymin ymax]);
title('Spring Pendulum Animation','Color','k');
axis off ;
% Plot for Spring Phase plane
subplot(222) ;
h1 = plot(r(1),rdot(1),'LineWidth',1,'Color','r') ;
maxr = max(r) ;minr = min(r) ;
maxrdot = max(rdot) ; minrdot = min(rdot) ;
axis([minr maxr minrdot maxrdot]) ;
xlabel('r') ;ylabel('r''') ;
set(get(gca,'YLabel'),'Rotation',0.0)
set(gca,'nextplot','replacechildren');
grid on ;
title('Spring Phase Plane','Color','r')
% Plot for Pendulum Phase Plane 
subplot(224) ;
h2 = plot(Phi(1),Phidot(1),'LineWidth',1,'Color','b') ;
minPhi = min(Phi) ; maxPhi = max(Phi) ;
minPhidot = min(Phidot) ; maxPhidot = max(Phidot) ;
axis([minPhi maxPhi minPhidot maxPhidot]) ;
xlabel('\phi') ;ylabel('\phi''') ;
set(get(gca,'YLabel'),'Rotation',0.0)
grid on ;
set(gca,'nextplot','replacechildren');
title('Pendulum Phase Plane','Color','b');
% Animation of Spring Pendulum starts
for i=1:length(t)-1
    if get(stop,'value')==0
    % update of all moving components
    set(bob,'XData',position(i,1),'YData',position(i ,2));
    [xs ys] = Spring([0 0],[position(i,1) position(i,2)]) ;
    set(arm,'XData',xs,'YData',ys) ;
    DEPL(i,:) = [position(i,1) position(i,2)] ;
    set(path,'Xdata',DEPL(:,1),'YData',DEPL(:,2)) ;
    % Spring Phase Plane Plot
        if (ishandle(h1)==1)
            spring(i,:) = [r(i) rdot(i)] ;
            set(h1,'XData',spring(:,1),'YData',spring(:,2));
            drawnow;
            vasu = length(spring(:,1)) ;
            if arrow == true
            if i>1
                 subplot(222)
                 arrowh(r(i-1:vasu),rdot(i-1:vasu),'r') ;
                 hold on ;
            end         
            end
        end
     % Pendulum Phase Plane Plot
        if (ishandle(h2)==1)
            pendulum(i,:) = [Phi(i) Phidot(i)] ;
            set(h2,'XData',pendulum(:,1),'YData',pendulum(:,2)); 
            drawnow;
            vasu = length(pendulum(:,1)) ;
            if arrow == true
            if i>1
                 subplot(224)
                 arrowh(Phi(i-1:vasu),Phidot(i-1:vasu),'b') ;
                 hold on ;
            end         
            end
        end
        
    % Pause for length of time step
        F(i) = getframe(h) ; 
        if movie == false
            pause(t(i+1)-t(i));
        end
    elseif get(stop,'value')==1 
        break
    end
end
if movie == true
   msgbox('Please wait animaition being saved') ;
   movie2avi(F,'SpringPendulum.avi','compression','Cinepak','fps',fps)
end
set(stop,'style','pushbutton','string','close','callback','close(gcf)');