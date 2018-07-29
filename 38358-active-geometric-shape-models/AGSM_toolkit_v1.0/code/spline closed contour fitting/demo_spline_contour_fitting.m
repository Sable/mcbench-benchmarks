% This is a simple example of how to fit 
% a cubic spline contour
% to data using active geometric shape model. 

% Copyright (C) 2012 Quan Wang <wangq10@rpi.edu>, 
% Signal Analysis and Machine Perception Laboratory, 
% Department of Electrical, Computer, and Systems Engineering, 
% Rensselaer Polytechnic Institute, Troy, NY 12180, USA
% 
% You are free to use this software for academic purposes if you cite our paper: 
% Quan Wang, Kim L. Boyer, 
% The active geometric shape model: A new robust deformable shape model and its applications, 
% Computer Vision and Image Understanding, Volume 116, Issue 12, December 2012, Pages 1178-1194, 
% ISSN 1077-3142, 10.1016/j.cviu.2012.08.004. 
% 
% For commercial use, please contact the authors. 

clear;clc;close all;
addpath('../force field');
addpath('../math');

%% 1. experiment set up

% image size = 400*500
rows=400;
cols=500;

% number of trials
Num_Of_Trials=10;

% number of data points and outliers
num_data=100;
num_outlier=5;
noise=5;

% number of landmarks for data/model
Nlm=6; % data
NN=6; % model

% ground truth parameters
x0=250+(rand(1)-0.5)*100;
y0=200+(rand(1)-0.5)*100;
D0=60+rand(1,Nlm)*100;

% image blur parameters
sigma1=20;
sigma2=5;

%% 2. generate data

% generate data points and outliers
theta=rand(num_data,1)*2*pi;
lm_theta=linspace(0,2*pi,Nlm+1);
DD=myspline(lm_theta,D0,theta);
x=x0+DD.*cos(theta)+noise*randn(size(theta));
y=y0+DD.*sin(theta)+noise*randn(size(theta));
x=[x;rand(num_outlier,1)*cols];
y=[y;rand(num_outlier,1)*rows];
x=round(x);
y=round(y);
x(x<1)=1;
x(x>cols)=cols;
y(y<1)=1;
y(y>rows)=rows;
xp=x;
yp=y;

% display data points and outliers
plot(x,y,'.');
axis equal;
axis([1 cols 1 rows]);
title('data points and outliers');
xlabel('x');
ylabel('y');
drawnow;

% generate image
I=zeros(rows,cols);
for i=1:max(size(y))
    I(y(i),x(i))=100;
end
[m n]=size(I);

%% 3. GVF field
I2=gaussianBlur(I,sigma1);
[u,v] = GVF(I2, 1 , 0.1, 50);
dx2=u;dy2=v;

I3=gaussianBlur(I,sigma2);
[dx3 dy3]=gradient(I3);

best_fit=Inf;

%% 4. many trials
disp('Fitting the cubic spline contour...');
for trial=1:Num_Of_Trials
    close all;
    fprintf('Trial: %d\n',trial);
    init=[250+(rand(1)-0.5)*100,200+(rand(1)-0.5)*100,60+rand(1,NN)*40];
    increment=[0.2,0.2,0.2];
    threshold=[0.000001,0.000001,0.000001];
    bound=[40,150];
    %% fit a spline contour
    % stage 1: big sigma
    [xc yc D fit_save]=fit_spline_contour_force(...
        init,increment,threshold,bound,dx2,dy2,500,0);
    
    % stage 2: small sigma
    [xc yc D]=fit_spline_contour_force(...
        [xc yc D],increment,threshold,bound,dx3,dy3,100,0);
    
    %% correction
    clear D2;
    for k=1:NN
        dt=2*pi/100000;
        angle=2*pi/NN*(k-1);
        
        lm_theta=linspace(0,2*pi,NN+1);
        distances=myspline(lm_theta,D,[angle-dt angle angle+dt]);
        r=D(k);
        r1=(distances(3)-distances(1)) / (2*dt);
        r2=(distances(3)+distances(1)-2*distances(2)) / (dt^2);
        D2(k)=correctCurve_polar(r,r1,r2,sigma2,100);
    end
    D=D2;
    
    %% fitness function
    beta=0.9;
    fit0=0;
    fit1=0;
    fit2=0;
    [x,y,theta]=spline_contour_in_image(m,n,xc,yc,D);
    [x1,y1,theta1]=spline_contour_in_image(m,n,xc,yc,D*beta);
    [x2,y2,theta2]=spline_contour_in_image(m,n,xc,yc,D/beta);
    for i=1:max(size(theta))
        fit0=fit0+norm([dx2(y(i),x(i)),dy2(y(i),x(i))]);
    end
    for i=1:max(size(theta1))
        fit1=fit1+norm([dx2(y1(i),x1(i)),dy2(y1(i),x1(i))]);
    end
    for i=1:max(size(theta2))
        fit2=fit2+norm([dx2(y2(i),x2(i)),dy2(y2(i),x2(i))]);
    end
    fit0=fit0/max(size(theta));
    fit1=fit1/max(size(theta1));
    fit2=fit2/max(size(theta2));
    current_fit=fit0-fit1/2-fit2/2;
    
    if current_fit<best_fit
        best_fit=current_fit;
        best_xc=xc;
        best_yc=yc;
        best_D=D;
        best_fit_save=fit_save;
    end
end

% display fitting results
close all;

figure;
plot(xp,yp,'.');
axis equal;
axis([1 cols 1 rows]);
hold on;
theta=0:0.01:2*pi;
[x2,y2,temp]=spline_contour_in_image(rows,cols,best_xc,best_yc,best_D);
plot(x2,y2,'-.r','LineWidth',2);
plot(xp,yp,'.');
legend('noisy data points and outliers','active geometric shape model fit');
title('fitting a cubic spline contour using active geometric shape model');
xlabel('x');
ylabel('y');

%% 5. show numerical results
fprintf('num_data=%-4d    num_outlier=%-4d    \n',num_data,num_outlier);
fprintf('Nlm(data)=%-4d   Nlm(model)=%-4d    \n',Nlm,NN);
fprintf('------------------------------------------------------------\n');
fprintf('         xc        yc        D   \n');
fprintf('True:  ');
disp([x0 y0 D0]);
fprintf('Fit:   ');
disp([best_xc best_yc best_D]);

%% 6. show fitness function
figure;hold on;
plot(1:500,best_fit_save,'b','LineWidth',2);
legend('fitness function');
grid on;
xlabel('iteration');
ylabel('fitness function');
title('fitness function in each iteration');