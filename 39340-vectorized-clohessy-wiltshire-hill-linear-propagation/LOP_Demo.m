function LOP_Demo()
%% Purpose:
% This is a demo of how to use the CW equations to propagate an orbit
% using the relative positions of a target satellite and a chaser
% satellite.  The frame of reference is the target satellite orbit
% (Shuttle).  We are interested in examining the motion of the Hubble
% telescope relative to the orbit of the shuttle.
%
% Programmed by Darin C Koblick 12/01/2012
%% Begin Code Sequence

%Declared Constants:
      mu = 398600.4418;     %Earth Graitational Constant
earthRad = 6378.1363;       %km

%Initial Circular Radius of Space Shuttle
r_int = 500;

%Create initial coordinates representing the target (shuttle)
   xt = earthRad + r_int;
   yt = 0;
   zt = 0;
xdott = 0;
ydott = sqrt(mu/(earthRad+r_int));
zdott = 0;
rT = [xt, yt, zt]';
vT = [xdott,ydott,zdott]';
%Add 51.65 degrees of inclination to the orbit
inc = -51.65;
RYM = [cosd(inc) 0 sind(inc); 0 1 0; -sind(inc) 0 cosd(inc)];
rT = RYM*rT;
vT = RYM*vT;

%Create initial coordinates representing the chaser satellite (Hubble)
%Initial Positions and Velocities of the hubble telescope from the space 
%shuttle bay All units are in km/s
%Assume that both telescope and shuttle are docked initially
   xi = rT(1);
   yi = rT(2);
   zi = rT(3);
xdoti = vT(1);
ydoti = vT(2);
zdoti = vT(3);
rI = [xi, yi, zi]';
vI = [xdoti,ydoti,zdoti]';

%Specify the time interval of interest in seconds
t = 0:60:400*60;

%Convert the chaser satellite ECI coordinates into the Hill frame of
%reference
[rHill,vHill] = ECI2Hill_Vectorized(rT,vT,rI,vI);

%Add initial displacement on the x vector
rHill(1) = rHill(1)+1;

%Now ... recompute the chaser satellite vector ...
[rI,vI] = Hill2ECI_Vectorized(rT,vT,rHill,vHill);

%Find the angular rate of the target orbit (shuttle)
omega = sqrt(mu/sqrt(sum(rT.^2))^3);

%Use the Linear Propagator (LOP) to propagate Hill's coordinates forward in time
%This is to find the relative orbital motion of the "Chaser" satellite
[rHill,vHill] = CWHPropagator(rHill,vHill,omega,t);

%Use a nonlinear propagator to determine the Target tragectory as well as
%the Chaser tragectory
    [rTgt,vTgt] = keplerUniversal(repmat(rT,[1 length(t)]),repmat(vT,[1 length(t)]),t,mu);
[rChase,vChase] = keplerUniversal(repmat(rI,[1 length(t)]),repmat(vI,[1 length(t)]),t,mu);

%Now ... Convert the propagated Hill results back to an ECI reference
%frame:
[rCL,vCL] = Hill2ECI_Vectorized(rTgt,vTgt,rHill,vHill);

%Compare Results from using CW propagation to the non-linear propagation!
figure('color',[1 1 1],'Position',[100 200 1000 400]);
subplot(1,2,1);
[x,y,z] = sphere(20);
x = x.*earthRad; y = y.*earthRad; z = z.*earthRad;
surf(x,y,z); hold on; colormap('bone'); shading flat;
plot3(rCL(1,:),rCL(2,:),rCL(3,:),'linewidth',3);
plot3(rChase(1,:),rChase(2,:),rChase(3,:),'--k','linewidth',3);
axis equal; grid off;
subplot(1,2,2);
plot(t./60,-(rChase(1,:)-rCL(1,:)).*1000,'r'); hold on;
plot(t./60,-(rChase(2,:)-rCL(2,:)).*1000,'k','linewidth',2);
plot(t./60,-(rChase(3,:)-rCL(3,:)).*1000,'g');
plot(t./60,-(sqrt(sum(rChase.^2,1))-sqrt(sum(rCL.^2,1))).*1000,'b')
plot(t./60,-(vChase(1,:)-vCL(1,:)).*1000,'--r'); hold on;
plot(t./60,-(vChase(2,:)-vCL(2,:)).*1000,'--k');
plot(t./60,-(vChase(3,:)-vCL(3,:)).*1000,'--g');
plot(t./60,-(sqrt(sum(vChase.^2,1))-sqrt(sum(vCL.^2,1))).*1000,'--b');
legend('R_x \epsilon','R_y \epsilon','R_z \epsilon','R \epsilon', ...
       'V_x \epsilon','V_y \epsilon','V_z \epsilon','V \epsilon','location','SW');
ylabel('Postion/Velocity Difference (m)/(m/s)');
xlabel('Popagation Time (min)');
axis square;
grid on;
end