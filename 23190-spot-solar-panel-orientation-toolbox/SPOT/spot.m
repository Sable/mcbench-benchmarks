% SPOT--Solar Panel Orientation Toolbox +++++++++++++++++++++++++++++++++++
%   Matlab toolbox for solar panel orientation design
%   Author: Clement A. Ogaja (cogaja@csufresno.edu)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% What it does: plots the tilt and orientation of solar panel that captures
%               the most sun at mid-day for any location
%
% Reference Articles:
%     Ogaja C. (2009). “MATLAB Toolbox for Solar Panel Orientation Design” 
%            (In Preparation) 
%     Ogaja C. (2009). “Solar Panel Orientation Using Coordinate Geometry” 
%            (In Preparation) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% History
% 24 Feb 2009 created using MATLAB 7.7 (R2008b)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
clc

%collecting user information
prompt   = {'Enter date of interest e.g. for the 4.July "04_07"', ...
        'Enter geographical latitude (North is positive) [°]'};
    
tit    = 'Insert the following data';
li	= 1;
def     = {'04_07','-37.06'};
aw   = char(inputdlg(prompt,tit,li,def));

tag=str2num(aw(1,1:2)); % date of interest
monat=str2num(aw(1,4:5)); % month
Phi=str2num(aw(2,:)); % latitude

L=100; % length of solar panel
W=50; % width of solar panel
T=5; % thickness of solar panel

%%%%%% get sun position at mid-day
[Az El] = SolarAzEl(['2009/',aw(1,4:5),'/',aw(1,1:2),' ','12:00:00'],Phi,0,0)

%%%%%%%%%%%%%%%%%%%%%%

zf=5;%1; % the z-axis factor

%define coords of 3D panel corner points (1-8), normal vector (9-11), and
%right-angle points (12-14)
cube.points = [ 
  [ (1/2)*W*zf  (1/2)*L  (1/2)*T 1]; % 1
  [(-1/2)*W*zf  (1/2)*L  (1/2)*T 1]; % 2
  [(-1/2)*W*zf (-1/2)*L  (1/2)*T 1]; % 3
  [ (1/2)*W*zf (-1/2)*L  (1/2)*T 1]; % 4
  [ (1/2)*W*zf  (1/2)*L (-1/2)*T 1]; % 5
  [(-1/2)*W*zf  (1/2)*L (-1/2)*T 1]; % 6
  [(-1/2)*W*zf (-1/2)*L (-1/2)*T 1]; % 7
  [ (1/2)*W*zf (-1/2)*L (-1/2)*T 1]; % 8
  [          0        0        0 1]; % 9 (Origin of normal vector of panel)
  [          0        0  (zf*5.2)*T 1]; % 10 (Upper point of normal vector)
  [          0        0 (-zf*5.2)*T 1]; % 11 (Lower point of normal vector)
  [(-1/8)*W*zf        0 (-zf*4.2)*T 1]; % 12 (Righ-angle point)
  [          0        0 (-zf*4.2)*T 1]; % 13 (Righ-angle point)
  [(-1/8)*W*zf        0 (-zf*5.2)*T 1]; % 14 (Righ-angle point)
]';

%now define the edges - using point indices
cube.edges = [
  [1 2]; [2 3]; [3 4]; [4 1];...
  [5 6]; [6 7]; [7 8]; [8 5];...
  [1 5];...
  [2 6];...
  [3 7];...
  [4 8];...
  [9 10];...    
  [9 11]    
];

%setup the axes
figure;
axis([-1.2*W 1.2*W -1.2*L 1.2*L -zf*5.2*T zf*5.2*T]);
hold on;
grid off;

%define for East-West and North-South crossing
xt=[1.2*W 0 0; -1.2*W 0 0; 0 1.2*L 0; 0 -1.2*L 0; 0 0 -zf*5.2*T; 0 0 -zf*5.2*T];

xr=0; % rotation about x-axis (hold x-axis fixed)
     
for t=(90-El)*(pi/180)
%for t=0:0.05:(90-El)*(pi/180)

    % a rotation about x axis, 'xr' radians 
    R = [1  0 0 0 ;
         0 cos(xr) sin(xr) 0 ;
         0 -sin(xr) cos(xr)  0;
         0 0 0 1];

    % a rotation about the y axis, 't' radians
    R2 = [cos(t) 0 -sin(t) 0;
          0 1 0 0;
         sin(t) 0 cos(t)  0;
         0 0 0 1];
     
    % apply rotations 
    cube.image = R * R2* cube.points;   

    %draw the rotated PV panel
    cla;
    for i = 1:size(cube.edges,1)
        % get the coordinates of the edges
        p = [cube.image( :, cube.edges(i,1) ), cube.image( :, cube.edges(i,2) ) ];
        % draw the edges
        plot3( p(1,:), p(2,:), p(3,:), '-g','LineWidth',2 );
 
        %%plot original position
        %po = [cube.points( :, cube.edges(i,1) ), cube.points( :, cube.edges(i,2) ) ];
        %plot3( po(1,:), po(2,:), po(3,:), '-r','LineWidth',2);
        plot3( cube.points(1,9:10), cube.points(2,9:10), cube.points(3,9:10), '-r','LineWidth',2); % normal vector
        plot3( cube.points(1,9:11), cube.points(2,9:11), cube.points(3,9:11), '-r','LineWidth',2); % normal vector
        plot3( cube.points(1,12:13), cube.points(2,12:13), cube.points(3,12:13), '-r','LineWidth',2); % right angle
        plot3( cube.points(1,12:2:14), cube.points(2,12:2:14), cube.points(3,12:2:14), '-r','LineWidth',2); % right angle
        text(0,0,(zf*5.2)*T,[' ','Z',' '],'fontsize', 21);
        rn1=[0 0 0; cube.points(3,11)*tan(-t) 0 cube.points(3,11)]; % lower rotating normal point
        plot3(rn1(:,1), rn1(:,2), rn1(:,3),'-g','LineWidth',2); % rotating normal
        rn2=[0 0 0; cube.points(3,10)*tan(-t) 0 cube.points(3,10)]; % upper rotating normal point
        plot3(rn2(:,1), rn2(:,2), rn2(:,3),'-g','LineWidth',2); % rotating normal
        text(1.1*cube.points(3,10)*tan(-t),0,1.1*cube.points(3,10),['N',' '],'fontsize', 21); % upper normal point
        hl=[0 0 0 1; W*zf 0 0 1]'; % points for rotating N-S reference line
        hr= R * R2* hl; hr=hr';
        plot3(hr(:,1),hr(:,2),hr(:,3),'--g','LineWidth',2); % rotating N-S ref. line
        text(hr(2,1),hr(2,2),hr(2,3),[' ','P',' '],'fontsize', 21);
        cl=[.15*W*zf 0 0 1]'; % points for angle (beta) of rotation
        cv= R * R2* cl; cv=cv'; % trace points for angle (beta)
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    text(-.15*W*zf,0,0,[' ','O',' '],'fontsize', 21);
    cv=[cl';cv]; B=sprintf('%2.0f',t*(180/pi));  % angle beta
    drawCurve3d(cv(:,1), cv(:,2), cv(:,3),'--r','LineWidth',2); % draw arc
    text(1.4*cv(2,1),cv(2,2),.85*cv(2,3),[' ',num2str(B),'^o',' '],'fontsize', 21); % angle beta

    we=plot3(xt(1:2,1)*zf,xt(1:2,2),xt(5:6,3),'--o','LineWidth',2);   %West-East crossing
    ns=plot3(xt(3:4,1)*zf,xt(3:4,2),xt(5:6,3),'--o','LineWidth',2);   %North-South crossing 	
    href=[0 0 0; 1.2*W*zf 0 0]; % points for horizontal N-S reference line
    ns=plot3(href(:,1),href(:,2),href(:,3),'--r','LineWidth',2); %N-S ref. line 	
    text(1.2*W*zf,0,0,[' ','X',' '],'fontsize', 21);
    href=[0 0 0; 0 1.2*L 0]; % points for horizontal E-W reference line
    we=plot3(href(:,1),href(:,2),href(:,3),'--r','LineWidth',2); %E-W ref. line 	
    text(-.12*W*zf,1.2*L,0,[' ','Y',' '],'fontsize', 21);

    %plotformats(Phi,W,L,T,zf,aw);
 
    drawnow;
   
end
view(3) % set camera orientation
plotformats(Phi,W,L,T,zf,aw);