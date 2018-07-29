%Function that calculates view factors between two planar surfaces
%--------------------------------------------------------------------------------------------------------
%viewfactor - Developped by Nicolas Lauzier with collaboration of Daniel Rousse, Université Laval, 2003
%--------------------------------------------------------------------------------------------------------
%This function calculates view factors between two planar surfaces.
%The function receive 3 parameters, which are the coordinates of 
%both figures and the desired number of significant digits.
%
%[vfactor12,vfactor21,area1,area2]=viewfactor(coord1,coord2,nbdigits)
%
%coord1 and coord2 are the coordinates of the vertices that
%set the outline of figures 1 and 2. It must be entered this way:
%coord1=[[x1,y1,z1];[x2,y2,z2];[...,...,...];[xn,yn,zn]]
%
%nbdigits is the desired number of significant digits.
%The function display more digits but only 'nbdigits' 
%are significant.

function [facteur12,facteur21,aire1,aire2] =functionviewfactor(figure1,figure2,niveau)

%NOTE: THIS .m FILES HAS BEEN CODED IN FRENCH, THE COMMENTS HAS BEEN
%TRANSLATED.

%We want a long result
format long;

%How many vertices on each figures?
[nbpoint1,nbcoord1]=size(figure1);
[nbpoint2,nbcoord2]=size(figure2);

%We add the first point as the last point to close the outline of the figure
figure1(nbpoint1+1,:)=figure1(1,:);
figure2(nbpoint2+1,:)=figure2(1,:);

%Global variables: pt1 to pt4 are the points that define the segment to integrate, normale1 and normale2 are the unit normal vector.

global pt1;
global pt2;
global pt3;
global pt4;
global normale1;
global normale2;
global normale;

%Unit normal vector of figure 1
cote1=figure1(2,:)-figure1(1,:);
cote2=figure1(3,:)-figure1(1,:);
normale1=cross(cote1,cote2)/(norm(cross(cote1,cote2)));

%Unit normal vector of figure 2
cote1=figure2(2,:)-figure2(1,:);
cote2=figure2(3,:)-figure2(1,:);
normale2=cross(cote1,cote2)/(norm(cross(cote1,cote2)));

%Preliminar calculation of area to determine which precision to use in calculation to respect the number of significant digits
aire1temp=0;
normale=normale1;
for i=1:nbpoint1
    pt1=figure1(i,:);
    pt2=figure1(i+1,:);
    
    %Integration to calculate the area of figure 1
    aire1temp=aire1temp+quadL('functionviewfactorarea',0,1,0.1);
end    
aire1temp=abs(aire1temp);
prec=10^(-niveau)/(nbpoint1*nbpoint2/(2*pi*aire1temp)+nbpoint1/aire1temp);

%The calculation of area of figure 1 with the right precision.
aire1=0;
normale=normale1;
for i=1:nbpoint1
    pt1=figure1(i,:);
    pt2=figure1(i+1,:);
    
    %Integration to calculate the area of figure 1
    aire1=aire1+quadL('functionviewfactorarea',0,1,prec);
end    
aire1=abs(aire1)  ;

%The calculation of area of figure 1 with the right precision.
aire2=0;
normale=normale2;
for i=1:nbpoint2
    pt1=figure2(i,:);
    pt2=figure2(i+1,:);
    
%Integration to calculate the area of figure 2
    aire2=aire2+quadL('functionviewfactorarea',0,1,prec);
end    
aire2=abs(aire2)  ;



%Double integral that we need to calculate the view factor
sommeintegrale=0;
for i=1:nbpoint1
    for j=1:nbpoint2
        pt1=figure1(i,:);
        pt2=figure1(i+1,:);
        pt3=figure2(j,:);
        pt4=figure2(j+1,:);
        sommeintegrale=sommeintegrale+dblquad('functionintegral',0,1,0,1,prec,'quadL');
    end
end

%Calculation of the view factors
facteur12=abs(sommeintegrale)/(2*pi*aire1);
facteur21=abs(sommeintegrale)/(2*pi*aire2);
