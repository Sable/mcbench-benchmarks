% This is a simple example of how to fit 
% an ellipse with arbitrary orientation 
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

% number of data points and outliers
num_data=100;
num_outlier=10;
noise=5;

% ground truth parameters
x0=250+(rand(1)-0.5)*100;
y0=200+(rand(1)-0.5)*100;
a0=120+(rand(1)-0.5)*50;
b0=60+(rand(1)-0.5)*50;
phi0=rand(1)*pi;

% image blur parameters
sigma1=20;
sigma2=5;

%% 2. generate data

% generate data points and outliers
theta=rand(num_data,1)*2*pi;
x=x0+a0*cos(theta)*cos(phi0)-b0*sin(theta)*sin(phi0)+noise*randn(size(theta));
y=y0+a0*cos(theta)*sin(phi0)+b0*sin(theta)*cos(phi0)+noise*randn(size(theta));
x=[x;rand(num_outlier,1)*cols];
y=[y;rand(num_outlier,1)*rows];
x(x<1)=1;
x(x>cols)=cols;
y(y<1)=1;
y(y>rows)=rows;
x=round(x);
y=round(y);

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
I=double(I);

%% 3. GVF field

I2=gaussianBlur(I,sigma1);
[u,v] = GVF(I2, 1 , 0.1, 50);
dx=u;dy=v;

I3=gaussianBlur(I,sigma2);
[u,v] = GVF(I3, 1 , 0.1, 50);

%% 4. ellipse fitting

init=[250,200,120,100,0]; % initial parameters
increment=[0.2,0.2,0.2,0.2,pi/180*0.2]; % increment in each iteration
threshold=[0.000001,0.000001,0.000001,0.000001,0.000001]; % threshold for forces/torques
bound=[10,200,10,200]; % the lower/upper bounds of a and b

disp('Fitting the ellipse...');
tic
% stage 1: big sigma
[xc yc a b phi]=fit_arb_ellipse_force(init,increment,...
    threshold,bound,dx,dy,300,1);

% stage 2: small sigma

dx=u;dy=v;

[xc yc a b phi]=fit_arb_ellipse_force([xc yc a b phi],increment,...
    threshold,bound,dx,dy,50,0);

fprintf('Running time of 2-stage ellipse fitting: ');
toc

phi=mod(phi,pi);

% correction of curvature
r1=correctCurve(b^2/a,sigma2,100);
r2=correctCurve(a^2/b,sigma2,100);
a=(r1*r2^2)^(1/3);
b=(r1^2*r2)^(1/3);

% display fitting results
figure;
plot(x,y,'.');
axis equal;
axis([1 cols 1 rows]);
hold on;
theta=0:0.01:2*pi;
plot(xc+a*cos(theta)*cos(phi)-b*sin(theta)*sin(phi),...
    yc+a*cos(theta)*sin(phi)+b*sin(theta)*cos(phi),'-.r','LineWidth',2);
plot(x,y,'.');
legend('noisy data points and outliers','active geometric shape model fit');
title('fitting an ellipse using active geometric shape model');
xlabel('x');
ylabel('y');
drawnow;

%% 5. error analysis

% get errors
error_xc=abs(xc-x0);
error_yc=abs(yc-y0);
error_a=abs(a-a0);
error_b=abs(b-b0);
error_phi=abs(phi-phi0);

% display errors
fprintf('num_data=%d    num_outlier=%d \n',num_data,num_outlier);
fprintf('------------------------------------------------------\n');
fprintf('        xc       yc       a        b        phi\n');
fprintf('True:   %-6.2f   %-6.2f   %-6.2f   %-6.2f   %-6.4f    \n',x0,y0,a0,b0,phi0);
fprintf('Fit:    %-6.2f   %-6.2f   %-6.2f   %-6.2f   %-6.4f    \n',xc,yc,a,b,phi);
fprintf('Error:  %-6.2f   %-6.2f   %-6.2f   %-6.2f   %-6.4f    \n',error_xc,error_yc,error_a,error_b,error_phi);

