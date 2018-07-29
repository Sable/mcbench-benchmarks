function [V,F]=platonic_solid(n,r)

% function [V,F]=platonic_solid(n,r)
% ------------------------------------------------------------------------
% PLATONIC_SOLID Creates the PATCH data, the vertices (V) and faces (F) for
% a given platonic solid (according to "n" see below) with radius (r)
%
% n=1 -> Tetrahedron
% n=2 -> Cube
% n=3 -> Octahedron
% n=4 -> Icosahedron
% n=5 -> Dodecahedron
%
% %%%Example
% clear all; close all; clc;
% 
% r=1;
% figure;fig=gcf; clf(fig); colordef (fig, 'white'); units=get(fig,'units'); set(fig,'units','normalized','outerposition',[0 0 1 1]); set(fig,'units',units); set(fig,'Color',[1 1 1]);
% hold on; 
% 
% [V,F]=platonic_solid(1,r);
% subplot(2,3,1);
% patch('Faces',F,'Vertices',V,'FaceColor','b','FaceAlpha',0.6,'EdgeColor','k','LineWidth',2); axis equal; grid on; hold on; view(3); axis off;
% 
% [V,F]=platonic_solid(2,r);
% subplot(2,3,2);
% patch('Faces',F,'Vertices',V,'FaceColor','b','FaceAlpha',0.6,'EdgeColor','k','LineWidth',2); axis equal; grid on; hold on; view(3); axis off;
% 
% [V,F]=platonic_solid(3,r);
% subplot(2,3,3);
% patch('Faces',F,'Vertices',V,'FaceColor','b','FaceAlpha',0.6,'EdgeColor','k','LineWidth',2); axis equal; grid on; hold on; view(3); axis off;
% 
% [V,F]=platonic_solid(4,r);
% subplot(2,3,4);
% patch('Faces',F,'Vertices',V,'FaceColor','b','FaceAlpha',0.6,'EdgeColor','k','LineWidth',2); axis equal; grid on; hold on; view(3); axis off;
% 
% [V,F]=platonic_solid(5,r);
% subplot(2,3,5);
% patch('Faces',F,'Vertices',V,'FaceColor','b','FaceAlpha',0.6,'EdgeColor','k','LineWidth',2); axis equal; grid on; hold on; view(3); axis off;
%
%
% Kevin Mattheus Moerman
% kevinmoerman@hotmail.com
% 13/11/2009
% ------------------------------------------------------------------------

phi=(1+sqrt(5))/2;

switch n
    case 1 % Tetrahedron
        V1=[-0.5;0.5;0;0;];
        V2=[-sqrt(3)/6;  -sqrt(3)/6; sqrt(3)/3; 0];
        V3=[-0.25.*sqrt(2/3); -0.25.*sqrt(2/3); -0.25.*sqrt(2/3);  0.75.*sqrt(2/3)];
        F= [1 2 3; 1 2 4; 2 3 4; 1 3 4;];

    case 2 % Cube
        V1=[-1;  1; 1; -1; -1;  1; 1; -1;];
        V2=[-1; -1; 1;  1; -1; -1; 1;  1;];
        V3=[-1; -1;-1; -1;  1;  1; 1;  1;];
        F= [1 2 3 4; 1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8; 5 6 7 8;];

    case 3 % Octahedron
        V1=[-1;  1; 1; -1;  0;   0;];
        V2=[-1; -1; 1;  1;  0;   0;];
        V3=[ 0;   0; 0;  0; -1;  1;];
        F= [1 2 5; 2 3 5; 3 4 5; 4 1 5; 1 2 6; 2 3 6; 3 4 6; 4 1 6;];

    case 4 % Icosahedron
        V1=[0;0;0;0;-1;-1;1;1;-phi;phi;phi;-phi;];
        V2=[-1;-1;1;1;-phi;phi;phi;-phi;0;0;0;0;];
        V3=[-phi;phi;phi;-phi;0;0;0;0;-1;-1;1;1;];
        F= [1 4 9;1 5 9;1 8 5;1 8 10;1 10 4; 12 2 5; 12 2 3; 12 3 6; 12 6 9; 12 9 5; 11 7 10; 11 10 8; 11 8 2; 11 2 3; 11 3 7; 2 5 8; 10 4 7; 3 6 7; 6 7 4; 6 4 9; ];

    case 5 % Dodecahedron
        V1=[1;(1/phi);-phi;phi;-1;0;-phi;1;-1;-1;1;(1/phi);-1;0;0;-(1/phi);phi;-(1/phi);1;0;];
        V2=[1;0;-(1/phi);(1/phi);1;-phi;(1/phi);-1;1;-1;-1;0;-1;-phi;phi;0;-(1/phi);0;1;phi;];
        V3=[[1;phi;0;0;-1;-(1/phi);0;1;1;1;-1;-phi;-1;(1/phi);-(1/phi);phi;0;-phi;-1;(1/phi);]];
        F=[1,2,16,9,20;2,16,10,14,8;16,9,7,3,10;7 9 20 15 5;5,7,3,13,18;3,13,6,14,10;6,13,18,12,11;6,11,17,8,14;11,12,19,4,17;1,2,8,17,4;1,4,19,15,20;12,18,5,15,19];

    otherwise
        warning('False input for n')
end

[THETA,PHI,R]=cart2sph(V1,V2,V3);
R=r.*ones(size(V1(:,1)));
[V1,V2,V3]=sph2cart(THETA,PHI,R);
V=[V1 V2 V3];
