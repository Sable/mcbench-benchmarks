function demoheart
% DEMOHEART, vers. 1.0.
% Sergei Malchenko, University of Tartu, 2002, sergeim@ut.ee.
%
% Demonstration of a movie of Heart Shape Variation at contractions.
% Describes the motion of epicardial surface in spherical coordinates.
% Based on the Model of the Human Heart Shape Variation During Cardiac Cycle
% (filed in MATLAB spline function _heartsurf_ enclosed in the file heart.mat).
%
% Products Required: MATLAB (R11), Spline Toolbox (R11).
%
% Important note:
% Variation of the heart surface is presented by the spline function _heartsurf_ 
% using spherical coordinates and time: R=R(THETA,PHI,TIME). 
% The origin of coordinates is located in the centre of the aortic valve, 
% the Z axis is directed from the base of the heart towards the apex.
% Units of distances are centimeters, units of time are seconds.
% Duration of the contraction cycle is fixed to 0.77 s, the corresponding heart
% rate is 78 beats/minute.
% 
% The model has been used as tool for calculation of the total heart volume. 
% It can bee seen that the movement of the heart outer surface at normal functioning
% is relatively small. The total heart volume of the heart changes only about 11 
% percent during the heart cycle, in the present case from 674 till 751 cubic cm. 

clf
close all
clear all

% Set the proportions of the heart:
prop=35;
Z_sdvig=3;
mastbZ=30;
xo=0/prop;
yo=7/prop;
zo=-Z_sdvig.*mastbZ/prop;

% ____________________________________________________________________________
%                                   Loading data:

% Backbone, sternum, and spline function describing the heart surface is loaded:
load('heart.mat');
% ____________________________________________________________________________
%                             Prepare data for processing:

% Mesh generation:
Tper=0.77;               % Heart period, in seconds
N=20;                    % Desired number of frames per cardiac cycle

THETA=-pi:pi./30:pi;     % Azimuth grid
PHI=-pi./2:pi./30:pi./2; % Elevation grid 
TIME=0:Tper/N:Tper;      % Time grid

% The call  Rvalues=fnval(heartsurf,{THETA, PHI, TIME}) returns the radius values R 
% of this spline function  _heartsurf_ at the given argument sequences  THETA, PHI, TIME.
% Here azimuth THETA and elevation PHI are angular coordinates in radians,
% measured from the positive x-axis and the x-y plane, respectively; 
% R is the distance from the origin of coordinates to the point of the surface. 

Rvalues = fnval(heartsurf,{THETA,PHI,TIME});
set(gcf,'Position',[1 29 400 200]);

% Transposing:
for Time=1:size(Rvalues,3)
    Rs(:,:,Time)=Rvalues(:,:,Time).';
end
Rvalues=Rs;
clear Rs;

% Rotation (for proper presentation of the heart in natural human-body-related coordinate axes):
gx=gx.*cos(pi/3.7)+gy.*sin(pi/3.7);
gy=-gx.*sin(pi/3.7)+gy.*cos(pi/3.7);
px=px.*cos(pi/3.7)+py.*sin(pi/3.7);
py=-px.*sin(pi/3.7)+py.*cos(pi/3.7);

M=moviein(size(heartsurf,1));
[THETA,PHI] = meshgrid(THETA,PHI);

for Time=1:size(Rvalues,3)
    a=size(Rvalues(:,:,Time));
    Rvalues_tt=(Rvalues(:,:,Time));
    Rvalues_t=Rvalues_tt(:).';
    THETA_t=(THETA(:)).';
    PHI_t=(PHI(:)).';
    Rvalues_tt=[];
    [XX,YY,ZZ]=sph2cart(THETA_t,PHI_t,Rvalues_t);
    Object=[XX+xo;YY+yo;ZZ+zo];
    Object=[XX;YY;ZZ];
    % povorot3 - function, used for setting preferred direction for new Z-axis direction: 
    NewObject=povorot3(Object);
    XX=reshape(NewObject(1,:),a);
    YY=reshape(NewObject(2,:),a);
    ZZ=reshape(NewObject(3,:),a);
    XX=XX.*cos(pi/3.7)+YY.*sin(pi/3.7);
    YY=-XX.*sin(pi/3.7)+YY.*cos(pi/3.7);
    
    
    % ____________________________________________________________________________
    %                             Visualization:
    
    h=surf(XX,YY,ZZ);
    colormap(pink)
    hold on
    grid on
    set(gcf,'Color',[1 1 1]);
    set(h,'FaceLighting','phong','EdgeColor',[1 0 0]);colormap(pink);
    set(gca,'XDir','reverse')
    axis square
    surface(px,py,zgp_p);
    m=surface(gx,gy,zgp_g);
    set(m,'EdgeColor',[0.5 0.6 0.5]);
    xlabel('X(cm)');
    ylabel('Y(cm)');
    zlabel('Z(cm)','Rotation',0);
    title('Human Heart Shape','FontSize',16);
    colormap(pink);
    axis([-8 6 -4 4 -10.5 10.5]);
    view(158,6);
    fill(0,0,[1 0.65 0.5]);
    fill(0,0,'black');
    fill(0,0,[0.5 0.6 0.5]);
    h=fill(0,0,'w');
    set(h,'EdgeColor',[1 1 1]);
    legend('Cor','Medulla spinalis','Sternum',-1);
    hold off;
    M(Time,:)=getframe;
end
title('DemoHeart:  Movie of heart beating in MATLAB')
movie(M,10000,17);






function NewObject=povorot3(Object)
%
% Pivots a 3D-Object to make the dir_vert vertical, i.e. along Z-axis.
% Axes: 1 - X, 2 - Y, 3 - Z.
% Object is described as a 3-row (X,Y,Z-rows) matrix Oject of coordinates of location points.

dir_X=[1,0,0]; dir_Y=[0,1,0]; dir_Z=[0,0,1];

dir_vert=[216.9316 237.7576  450.0000]; % Preferred direction that is selected as direction for new Z-axis (Zn)
dir_Zn=dir_vert/sqrt(dir_vert(1).^2+dir_vert(2).^2+dir_vert(3).^2);  % Zn-axis (new Z-axis) unit vector
dir_Xn=cross(dir_Zn,dir_Z); % New X-axis direction, choosen rather arbitrarily, crosses both Z and Zn 
dir_Xn=dir_Xn/sqrt(dir_Xn(1).^2+dir_Xn(2).^2+dir_Xn(3).^2); % Xn-axis (new X-axis) unit vector
dir_Yn=cross(dir_Zn,dir_Xn); % Yn axis (new Y-axis) unit vector, choosen according orthonormality and right hand rule

DirCos=inv([dir_Xn; dir_Yn; dir_Zn].');
NewObject=DirCos*Object;



