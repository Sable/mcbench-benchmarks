function Animation(ivp, duration, fps, movie, arrow)
%--------------------------------------------------------------------------
% To Animate the Simple Pendulum, Equation is solved by MATLAB ode45, and
% running a loop over the time step; for every time step the position
% coordinates of the pendulum are updated. Phase plane plot and time Vs.
% displacement plot is also plotted 
%--------------------------------------------------------------------------
nframes=duration*fps; % Number of Frames
% Solving the Equation using ode45
sol=ode45(@Equation,[0 duration], ivp); 
t = linspace(0,duration,nframes);
y = deval(sol,t);
% Position and Angular velocity
phi = y(1,:)';
dtphi = y(2,:)';
L = ivp(5); 
% To set the Range os Phase plane, time vs. depl plots
minu = 1.1*min(phi) ; maxu = 1.1*max(phi);
minv = 1.1*min(dtphi) ; maxv = 1.1*max(dtphi);
% 
fh = figure ;
set(fh,'name','The Simple Pendulum','numbertitle','off','color', 'w','menubar','none') ;
stop = uicontrol('style','toggle','string','stop','background','w');
% Plot for Pendulum
subplot(121);
h = plot(0,0,'MarkerSize',30,'Marker','.','LineWidth',1.5,'Color','b');
title('Simple Pendulum Animation','Color','b');
range = 1.1*L;
axis([-range range -range range]);
axis square;
set(gca,'XTickLabelMode', 'manual', 'XTickLabel', [],'YTickLabelMode', .....
    'manual', 'YTickLabel', [],'nextplot','replacechildren');
% Plot for Phase plane
subplot(222) ;
h1 = plot(ivp(1),ivp(2),'LineWidth',1,'Color','m') ;
axis([minu maxu minv maxv]) ;
xlabel('\phi') ;ylabel('\phi''') ;
set(get(gca,'YLabel'),'Rotation',0.0)
set(gca,'nextplot','replacechildren');
grid on ;
title('Phase Plane Plot','Color','m')
% Plot for time Vs. displacement 
subplot(224) ;
h2 = plot(t(1),ivp(1),'LineWidth',1,'Color','r') ;
axis([0 duration minu maxu]) ;
xlabel('t') ;ylabel('\phi') ;
set(get(gca,'YLabel'),'Rotation',0.0)
grid on ;
set(gca,'nextplot','replacechildren');
title('Time Vs. Displacement Plot','Color','r');
%
% Animatio starts
for i=1:length(phi)-1
 % Animation Plot
    if (ishandle(h)==1)
        Xcoord=[0,L*sin(phi(i))];
        Ycoord=[0,-L*cos(phi(i))];
        set(h,'XData',Xcoord,'YData',Ycoord);
        if get(stop,'value')==0
            drawnow;
        elseif get(stop,'value')==1
            break;
        end
        % Phase Plane Plot
        if (ishandle(h1)==1)
            PP(i,:) = [phi(i) dtphi(i)];
            set(h1,'XData',PP(:,1),'YData',PP(:,2));
            drawnow;    
            vasu = length(PP(:,1)) ;
            if arrow == 'ShowArrow'
            if i>1
                 subplot(222)
                 arrowh(phi(i-1:vasu),dtphi(i-1:vasu),'m') ;
                 hold on ;
            end         
            end
        % Time Vs. displacement Plot  
            if (ishandle(h2)==1)
                DEPL(i,:) = [t(i) phi(i)] ;
                set(h2,'Xdata',DEPL(:,1),'YData',DEPL(:,2)) ;
                drawnow ;    
            end    
        end  
    end
    F(i) = getframe(fh) ;          
end
if movie == true
   movie2avi(F,'SimplePendulum.avi','compression','Cinepak','fps',fps)
end
% Close the Figure window
set(stop,'style','pushbutton','string','close','callback','close(gcf)');