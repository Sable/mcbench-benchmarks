function Animation(ivp, duration, fps, movie)
%--------------------------------------------------------------------------
% To Animate the Bead on a rotating hoop, Equation is solved by MATLAB ode45, and
% running a loop over the time step; for every time step the position
% coordinates of the bead are updated. Phase plane plot and time Vs.
% displacement plot is also plotted 
%--------------------------------------------------------------------------
nframes=duration*fps;           % Number of Frames
% Solving the Equation using ode45
sol=ode45(@Equation,[0 duration], ivp); 
t = linspace(0,duration,nframes);
y = deval(sol,t);
% Position and Angular velocity of the bead
thita = y(1,:)';
dthita = y(2,:)';
R = ivp(5);                     % Radius of the Hoop
w0 = ivp(7) ;                   % Grequency of rotation of the hoop/ring
% 
% Figure starts
fh = figure ;
set(fh,'name','Bead on Rotating Hoop','numbertitle','off','color', 'k','menubar','none') ;
% Plot for the Hoop (Ring/Circle)
phi = linspace(0,2*pi,nframes) ;        
c = [ 0 0 0] ;                  % Center of the hoop
u = [1 0 0] ;                   % Normal vectors lying on the plane of circle
v = [0 0 1] ;
px = c(1)+R*cos(phi).*u(1)+R*sin(phi).*v(1) ;
py = c(2)+R*cos(phi).*u(2)+R*sin(phi).*v(2) ;
pz = c(3)+R*cos(phi).*u(3)+R*sin(phi).*v(3) ;
hoop = plot3(px,py,pz,'Color','r','Linewidth',3) ;
% Bead position
beadX = R*sin(thita).*cos(w0*t') ;
beadY = R*sin(thita).*sin(w0*t') ;
beadZ = -R*cos(thita) ;
hold on ;
bead =  plot3(beadX(1),beadY(1),beadZ(1),'MarkerSize',50,'Marker','.','Color','b');
% Trajectory of the bead on rotating hoop
path = plot3(beadX(1),beadY(1),beadZ(1),'Color','w','Linewidth',0.5) ;
% Figure Settings
title('Bead on a Rotating Hoop','Color','w','Fontsize',10);
range = 1.3*R;
campos([0 R 0]) ;
axis([-range range -range range -range range]) ;
axis square ;
axis off ;
rotate3d ;
stop = uicontrol('style','toggle','string','stop','background','white');
%
% Animation starts
for i=1:length(t)-1
 % Animation Plot
    if (ishandle(fh)==1)
        T = [cos(w0*t(i))  -sin(w0*t(i)) 0 ;
             sin(w0*t(i))   cos(w0*t(i)) 0 ;
             0          0       1] ;        % Rotation Matrix
       pn = T*[px;py;pz] ;                  % New Position of the Hoop
       pn = pn' ;
       set(hoop,'XData',pn(:,1),'YData',pn(:,2),'ZData',pn(:,3)) ;
       set(bead,'XData',beadX(i),'YData',beadY(i),'ZData',beadZ(i)) ;
      % drawnow;
        % Trajectory of the Bead
       PP(i,:) = [beadX(i,1) beadY(i,1) beadZ(i,1)];
       set(path,'XData',PP(:,1),'YData',PP(:,2),'ZData',PP(:,3));
            if get(stop,'value')==0
                drawnow; 
            elseif get(stop,'value')==1
                break
            end
    end  
    F(i) = getframe(fh) ;  
    % Pause for length of time step
    if movie == false
            pause(t(i+1)-t(i));
    end
end
if movie == true
        movie2avi(F,'BeadOnRotatingHoop.avi','compression','Cinepak','fps',fps)
end
set(stop,'style','pushbutton','string','close','callback','close(gcf)');
