%% Calculating optical flow of a sequence of images or from Video file
%% Author Gurkirt Singh
%% Date 09 June 2011 at Vision Lab IIT DELHI
%% Reading a Video file
clear all
clc
Object=mmreader('1.avi');
lastframe=read(Object, inf);
NumFrames = Object.NumberOfFrames;
%% Initialization of paramEters
%  Alpha
alpha=10;
% Number of iterations.
iterations=3;
% Do you Want to reduce size of Image for less computation? If yes DoYou=1;
DoYou=1;
% Width and Height
U=cell(NumFrames/2-1,1);
V=cell(NumFrames/2-1,1);
n=0;
% Normal Intensity flow

Normal=cell(NumFrames-1,1);

Window=[1/12 1/6 1/12;1/6 0 1/6;1/12 1/6 1/12];

%% Main program Starts here
hsize=[5 5];
sigma=1;
I=rgb2gray(read(Object,1));
h = fspecial('gaussian',hsize,sigma);
% I = imfilter(I,h,'replicate');
PreviousFrame= imfilter(I,h,'replicate');
if DoYou==1
PreviousFrame=impyramid(PreviousFrame,'reduce');
PreviousFrame=impyramid(PreviousFrame,'reduce');
end
[height width]=size(PreviousFrame);
%%
for k = 2:1:NumFrames
   
    I=rgb2gray(read(Object,k));
%     I=imfilter(I,h,'replicate');
    CurrentFrame=imfilter(I,h,'replicate');
    if DoYou==1;
    CurrentFrame=impyramid(CurrentFrame,'reduce');
    CurrentFrame=impyramid(CurrentFrame,'reduce');
    end
    
    [TempU TempV TempNormal]=Opticalflow(CurrentFrame,PreviousFrame,alpha,iterations,height,width);
    n=n+1;
    U{n,1}=single(TempU);
    V{n,1}=single(TempV);
%     Normal{n,1}=single(TempNormal);
    PreviousFrame=CurrentFrame;
    
end
%% Last Part
% myObj = VideoWriter('Ite3.wmv');
% myObj.FrameRate = 10;
% open(myObj);

% for i=1:49-1
% %     u=U{i,1};
% %     v=V{i,1};
% %     temp=mat2gray(sqrt(v.^2+u.^2));
% temp=mat2gray(abs(Normal{i,1}));
%     imshow(temp);
% %     BW =im2bw(I,0.12);
%     currFrame = getframe;
%     writeVideo(myObj,currFrame);
% end
% close(myObj)
