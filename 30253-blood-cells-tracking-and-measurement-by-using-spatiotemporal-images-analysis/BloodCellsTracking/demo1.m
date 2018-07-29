%-----------------------------------------------------------------------
% This demo use a nailfold video (demo1.avi) to show that blood cells
% tracking and velocity measurement by using one trackpath.
% Written by Yuan Chen,Nanjing university of aeronautic and astronautic(2010)
%-----------------------------------------------------------------------
clear all;
% read the nailfold avi file;
video = aviread('demo1.avi');
video = {video.cdata};
% change 'color' video to gray;
for i=1:length(video);                    
    video{i}=rgb2gray(video{i}); 
end

% read the trackpath image;
I = imread('trackpath.bmp');   

% finding the start point of the trackpath;
[x,y] = startpoint(I);

% order the trackpath's points;
ind = ord_line_indx(I,x,y);      

% generate the spatiotemporal image;
for i = 1:length(video)         
    for j = 1:length(ind)       
        line = video{i}(ind);   
        map(j,i) = line(j);     
    end
end
figure,subplot(3,2,1);imshow(map,[]),title('raw spatiotemporal image');

% Jacob filter enhancement;
[F,Theta,angle] = J4(map,2);
subplot(3,2,2);imshow(F,[]),title('Jacob enhancement result');

% applying the noise supression function(nsf);
Idenoised = nsf(F);
subplot(3,2,3);imshow(Idenoised,[]),title('noise supression result');

% applying the orientation filtering function;
h = fspecial('gaussian');
sTheta  = round(imfilter(Theta,h));
K = angfilter(Idenoised,sTheta,angle,20);
sK = imfilter(K,h);
subplot(3,2,4);imshow(sK,[]),title('orientation filter result');

% binary the filtered image;
th = graythresh(sK);    % threshold calculation;
if th < 0.003
    th = 0.003;
end

% [cont,Th] = hist(sK(:));
% th = Th(2);           % threshold calculation;

bw = im2bw(sK,th);
subplot(3,2,5);imshow(bw);title('binary result');

% thinning the image and remove small traces;
thin = bwmorph(bw,'thin',inf);
thin = bwareaopen(thin,size(map,1));
subplot(3,2,6);imshow(thin);title('extracted trace i(i=1,2...)from left to right');

%% velocity measurement;
figure;
[L,num] = bwlabel(thin);
[m,n] = size(thin);
for i = 1:num
    % method1: velocity calculated by orientations;
    indx = find(L==i);
    traceTheta = Theta(indx);                       % finding the orientation of the trace;
    V_trace = abs(tan(pi/180*traceTheta));          % velocity calculation;
    t = 2;
    Velocity1 = V_trace(t:length(V_trace)-t);         % do not calculate boundary data;
    Velocity1 = smooth(Velocity1);                  % smoothing the velocity;                                        
    subplot(num,1,i),plot(Velocity1);axis([0 100 0 3]);title(['trace',int2str(i),'Velocity']);
    % method2: velocity calculated by differential;
    [m1,n1] = ind2sub(size(L),indx);
    for j = 1:length(m1)
        [X(j),Y(j)] = ind2sub(size(I),ind(m1(j)));  % finding the position of the trace points in the trackpath;
    end
    del_x = diff(X);     % dx;
    del_y = diff(Y);     % dy;
    Velocity2 = sqrt(del_x.^2 + del_y.^2);          % velocity calculation;
    Velocity2 = Velocity2(t:length(Velocity2)-t);     % do not calculate boundary data;
    Velocity2 = smooth(Velocity2,10);               % smoothing the velocity;      
    hold on;plot(Velocity2,'r');h = legend('Orientation Velocity','Differential Velocity',2);
    xlabel('trace points');ylabel('velocity pixels/s')
    clear X;clear Y;  
end
