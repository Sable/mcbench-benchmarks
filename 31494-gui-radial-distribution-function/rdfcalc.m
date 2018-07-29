function [rbin]=rdfcalc(C,xlim,ylim)

%This file takes a file containing the co-ordinates of the centers as
%input, and finds the rdf

%xlim=512; % The maximum x co-ordinate of the image
%ylim=512; % The maximum y co-ordinate of the image

n=size(C,1);

rmin=1;
rmax=100;
dr=2;

rvecarray=rmin:dr:rmax;

m=size(rvecarray,2);

rbin=zeros(m,2);
rbin(:,1)=rvecarray;

for j=1:m
    
    rvec=rvecarray(j);
    
for i=1:n
    x1=C(i,1);
    y1=C(i,2);
    bini=0;
    
    for k=1:n
        rk= sqrt((C(k,1)-C(i,1))^2 +(C(k,2)-C(i,2))^2);
        if rk>= rvec && rk<=(rvec+dr)
            bini=bini+1;
        end
    end
    
    
    
    theta1=checkquad(x1,y1,rvec,1,xlim,ylim);
    theta2=checkquad(x1,y1,rvec,2,xlim,ylim);
    theta3=checkquad(x1,y1,rvec,3,xlim,ylim);
    theta4=checkquad(x1,y1,rvec,4,xlim,ylim);
    
    theta=theta1+theta2+theta3+theta4;
    
    area1=rvec*theta*dr;
    
    bini=bini/area1;
    rbin(j,2)=rbin(j,2)+bini;  
    
end
end


% rbin=rbin/n; % This is to divide the result by the number of particles.
% 
% numden=(n/(xlim*ylim)); %This is the number density
% 
% rbin=rbin/numden;
% 
% plot(rvecarray,rbin,'ro','MarkerSize',10)

