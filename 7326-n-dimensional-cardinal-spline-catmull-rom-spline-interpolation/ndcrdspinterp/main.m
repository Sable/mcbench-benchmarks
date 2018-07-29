close all, clear all, clc

n=100;   
% % Spline will be evaluted at n+1 values (uniform parameterization)
% % between each pair of middle control points
% %-----------------------------------------------% 
%%%% Cardinal Spline 1D Interpolation %%%%%%%%%%
% % We have 1D data (control points)
y=[35 35 16 15 25 40 65 50 60 80 80];	
% % Note that we will interpolate only y values (1D data)

figure, hold on    
Tension=0; 
for k=1:length(y)-3
    yi=crdatnplusoneval([y(k)],[y(k+1)],[y(k+2)],[y(k+3)],Tension,n);
    % % yi is 1D interpolated data
    
    plot(yi,'linewidth',2);        
    plot(yi(1),'ro','linewidth',2) ;
    plot(length(yi),yi(length(yi)),'ro','linewidth',2) ;
end
title('\bf 1D Cardinal Spline \newline Only Y-axis data is interpolated')
set(gca,'XTick',[0:10:120])
xlabel('\bf X-axis')
ylabel('\bf Y-axis')
legend('\bf Interpolated Data','\bf Control Points','Location','NorthWest')
grid on

% %-----------------------------------------------% 
%%%% Cardinal Spline 2D Interpolation %%%%%%%%%%
% % We have 2D data (control points)
Px=[35 35 16 15 25 40 65 50 60 80 80];	
Py=[47 47 40 15 36 15 25 40 42 27 27];	
% % Note first and last points are repeated so that spline passes
% % through all the control points

% when Tension=0 the class of Cardinal spline is known as Catmull-Rom spline
Tension=0; 
figure, hold on
for k=1:length(Px)-3
    
    [XiYi]=crdatnplusoneval([Px(k),Py(k)],[Px(k+1),Py(k+1)],[Px(k+2),Py(k+2)],[Px(k+3),Py(k+3)],Tension,n);
    
    % % XiYi is 2D interpolated data
    
    % Between each pair of control points plotting n+1 values of first two rows of XiYi 
    plot(XiYi(1,:),XiYi(2,:),'b','linewidth',2) % interpolated data
    plot(Px,Py,'ro','linewidth',2)          % control points
end
title('\bf 2D Cardinal Spline')
xlabel('\bf X-axis')
ylabel('\bf Y-axis')
legend('\bf Interpolated Data','\bf Control Points','Location','NorthEast')
grid on

% %-----------------------------------------------% 
%%%% Cardinal Spline 3D Interpolation %%%%%%%%%%
% % We have 3D data (control points)
 Px=[35  35  16 15 25 40 65 50 60 80 80];	
 Py=[47  47  40 15 36 15 25 40 42 27 27];	
 Pz=[-17 -17 20 15 36 15 25 20 25 -7 -7];	

% Note first and last points are repeated so that spline curve passes
% through all points

figure, hold on
Tension=0; 
for k=1:length(Px)-3
    
    [XiYiZi]=crdatnplusoneval([Px(k),Py(k),Pz(k)],[Px(k+1),Py(k+1),Pz(k+1)],[Px(k+2),Py(k+2),Pz(k+2)],[Px(k+3),Py(k+3),Pz(k+3)],Tension,n);
    % % XiYiZi is 3D interpolated data
    
    % Between each pair of control points plotting n+1 values of first three rows of MatOut 
     plot3(XiYiZi(1,:),XiYiZi(2,:),XiYiZi(3,:),'b','linewidth',2) 
     plot3(Px,Py,Pz,'ro','linewidth',2) 
end

title('\bf 3D Cardinal Spline')
xlabel('\bf X-axis')
ylabel('\bf Y-axis')
zlabel('\bf Z-axis')
legend('\bf Interpolated Data','\bf Control Points','Location','NorthEast')
grid on

view(3);
box;
% %-----------------------------------------------% 

% % Using similar approach you can do Cardinal Spline interpolation for
% % N-Dimensional data


% % --------------------------------
% % This program or any other program(s) supplied with it does not provide any
% % warranty direct or implied.
% % This program is free to use/share for non-commerical purpose only. 
% % Kindly reference the author.
% % Author: Dr. Murtaza Khan
% % Author Reference : http://www.linkedin.com/pub/dr-murtaza-khan/19/680/3b3
% % Research Reference: http://dx.doi.org/10.1007/978-3-642-25483-3_14
% % --------------------------------
