function [pL,tL,ncl]=tnsstroke(p0,v0sph,ts,plt);

% [pL,tL,ncl]=tnsstroke(p0,v0sph,ts,plt);
% computes landing point (pL) in m, landing time (tL) in sec,
% and net clearance (ncl) in m, of a tennis stroke.
% p0 is the ball initial position in m (front,left,hight) 
% v0sph is the initial velocity in spherical coordinates
% (i.e. magnitude(m/s), elevation (rad) and azimuth (rad)),
% the scalar ts is the ball topspin in revolutions/sec
% (use negative values for backspin),  finally plt=1 
% plots the whole ball trajectory in 3D.
% Example:
% [pL,tL,ncl]=tnsstroke([0 0 0.9906],[25.03424 9*pi/180 0],16,1);

% Giampy, Nov 22 2003

%%%%%%%%%%%%%%%%% check arguments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<4, plt=0; end
if nargin<3, ts=0; end
if nargin<2, disp('please read help'); pL=[];tL=[];ncl=[]; return; end

%%%%%%%%%%%%%%%%% initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ball initial position in m, 
assignin('base','p0',p0(:));

% ball initial velocity : magnitude(m/s), elevation (rad) and azimuth (rad)
[V0x,V0y,V0z]=sph2cart(v0sph(3),v0sph(2),v0sph(1));
assignin('base','v0',[V0x;V0y;V0z]);

% topspin (revolutions/s), (negative values for backspin).
assignin('base','w0',2*pi*ts*[sin(v0sph(3));cos(v0sph(3));0]);

%%%%%%%%%%%%%%%%% simulation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% actual simulation
sim('tennis');

% court dimensions in m, length, width, net height, service line :
Dx=23.7744;Dy=8.2296;Dn=1.067;Ds=5.4864;

% landing point and time
[xm,im]=min(p(:,3).^2);
pL=p(im,:)';tL=t(im);

% net clearance
[xm,im]=min((p(:,1)-Dx/2).^2);
ncl=(p(end,1)>Dx/2)*p(im,3)-Dn;

%%%%%%%%%%%%%%%%%% visualization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if plt,
    
    % plot and labels
    plot3(p(:,1),p(:,2),p(:,3));
    axis([-1 25 -6 20 -10 16]);
    
    % lines
    hold on
    plot3(Dx*[0 1 1 0 0],Dy*[0 0 1 1 0],Dn*[0 0 0 0 0],'r'); % court
    plot3(0.5*Dx*[1 1 1 1 1],Dy*[0 0 1 1 0],Dn*[0 1 1 0 0],'r'); % net
    plot3(Ds*[1 1],Dy*[0 1],Dn*[0 0],'r'); % service line 1
    plot3((Dx-Ds)*[1 1],Dy*[0 1],Dn*[0 0],'r'); % service line 2
    plot3([Ds Dx-Ds],0.5*Dy*[1 1],Dn*[0 0],'r'); % half line
    hold off
    
    xlabel(['x (m), landing at ' num2str(pL(1)) ' m']);
    ylabel(['y (m), landing at ' num2str(pL(2)) ' m']);
    zlabel(['h (m), net clearance : ' num2str(ncl) ' m']);
    title(['tennis ball trajectory from 0 to ' num2str(tL) ' sec']);
    
end
