function [Vbo,Wbo]=tnsbounce(Vb,ts,Vs,Ns,cor,cof,plt);

% [Vbo,Wbo]=tnsbounce(Vbi,ts,Vs,Ns,cor,cof,plt);
% This function computes the linear (Vbo) and angular (Wbo)
% velocity of a ball after it has bounced with a surface.
% They both are expressed in earth frame and in spherical coordinates: 
% (magnitude(m/s or rad/s), elevation (rad) and azimuth (rad)).
% Vb is the speed of the ball before the bounce, (same
% coordinates as Vbo and Wbo), ts its topspin in rev/sec, 
% Vs is the surface speed (still spherical coordinates), 
% Ns contains elevation and azimuth of the unity vector
% normal to the surface, cor and cof are the coefficients
% of restitution and friction of the surface (default 1 and 0).
% Finally, if plt is nonzero (default 0), a figure is created
% and a plot of the bounce is shown.
%
% Example #1 : ball with a speed of 65.96 ft/s descending with an angle 
% of 14 degrees and topspin of 10 rev/sec bounces on a wood surface (pag 65)
% [Vbo,Wbo]=tnsbounce([65.96*0.3048 -14*pi/180 0],10,[0 0 0],[pi/2 0],0.8,0.25,1);
% 
% Example #2 : ball with a speed of 60 ft/s going straight,
% bounces against a racket inclined by 20 degrees and going 
% in the other direction with an angle of 30 degrees at 60 ft/s
% [Vbo,Wbo]=tnsbounce([60*0.3048 0 0],0,[60*0.3048 -30*pi/180 pi],[-20*pi/180 0],0.7,0.2,1);
%
% Note that some simplifying assumptions are made, for example, 
% all the spin rotational energy is converted to kinetic energy,
% and, at the end of the dwell time the ball always starts to roll
% on the surface, as a consequence of that, the effect of the spin 
% on the bounce (and viceversa) is somewhat overestimated.

% Giampy, Jan 2003, revised July 2005.

%%%%%%%%%%%%%%%%% check arguments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<7, plt=0; end
if nargin<6, cof=0; end
if nargin<5, cor=1; end
if nargin<4, disp('please read help'); Vbo=[];Wbo=[]; return; end

%%%%%%%%%%%%%%%%% initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% surface orientation : spherical to cartesian
[Nsx,Nsy,Nsz]=sph2cart(Ns(2),Ns(1),1);
N=[Nsx,Nsy,Nsz]';

% ball initial velocity : spherical to cartesian
[Vbx,Vby,Vbz]=sph2cart(Vb(3),Vb(2),Vb(1));

% surface velocity : spherical to cartesian
[Vsx,Vsy,Vsz]=sph2cart(Vs(3),Vs(2),Vs(1));

% relative velocity
Vr=[Vbx Vby Vbz]'-[Vsx Vsy Vsz]';

% topspin (revolutions/s), (negative values for backspin).
W=2*pi*ts*[sin(Vb(3)) cos(Vb(3)) 0]';

% ball radius (m)
R=32.5e-3;

%%%%%%%%%%%%%%%%% computation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% vertical and horizontal components of relative velocity
VV=N*N'*Vr;VH=Vr-VV;

% vertical component after the bounce
VVo=-cor*VV;

% in the following it is assumed that all rotational energy 
% 1/2*(2/5*m*R^2)*W^2 is converted to horizontal kinetic energy
% 1/2*m*Vhos^2 where Vhos is the spin induced horizontal output 
% speed, which amounts to -cross(2/5*R*N,W), in reality this is 
% probably an overestimation since not all energy can be transferred

% the first part of the horizontal speed formula is the classic one
% which simply depends on the coefficient of friction

% horizontal component after the bounce
VHo=(1-cof*norm(VVo-VV)/norm(VH))*VH-cross(2/5*R*N,W);

% bounce-induced spin (assuming that ball rolls on the surface)
Wr=cross(N/R,VHo);

%%%%%%%%%%%%%%%%%% output values %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% absolute velocities
Vo=VHo+VVo+[Vsx Vsy Vsz]';
Wo=Wr;

% cartesian to spherical
[Va,Ve,Vm]=cart2sph(Vo(1),Vo(2),Vo(3));
[Wa,We,Wm]=cart2sph(Wo(1),Wo(2),Wo(3));

% output values
Vbo=[Vm Ve Va]';
Wbo=[Wm We Wa]';

%%%%%%%%%%%%%%%%%%% visualization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if plt,
    
    % norm
    mvn=max([norm([Vbx Vby Vbz]) norm([Vo]) norm([Vsx Vsy Vsz])]);
    
    % surface
    S=null(N');SM=[-S(:,1) -S(:,2) S(:,1) S(:,2)]';
    
    % ball trajectory
    VM=[-[Vbx Vby Vbz]' [0 0 0]' Vo]'/mvn;

    % surface trajectory
    VS=[[0 0 0]' [Vsx Vsy Vsz]']'/mvn;
    
    % plot
    figure;
    hold on;
    plot3(VM(1:2,1),VM(1:2,2),VM(1:2,3),'r');
    plot3(VM(2:3,1),VM(2:3,2),VM(2:3,3),'b');
    plot3(VS(1:2,1),VS(1:2,2),VS(1:2,3),'g');
    patch(SM(:,1),SM(:,2),SM(:,3),[0.9 0.8 0.9]);
    hold off;
    grid;
    view(3);

    % labels
    xlabel(['x']);
    ylabel(['y']);
    zlabel(['h']);
    title(['Tennis ball bounce ']);
    legend('ball input trajectory','ball output trajectory','surface trajectory',2);
    
end
