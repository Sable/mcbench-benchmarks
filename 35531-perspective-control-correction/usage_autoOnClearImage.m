clear all;
close all;
clc;

targetFolder = './images/';
candidateImages = {'skewed1.gif', 'trapezoid.jpg'};
candidateChoice = 1;

targetImageFile = strcat(targetFolder , char(candidateImages(candidateChoice )));
targetImageData = imread(targetImageFile);

%level = graythresh(targetImageData);
%targetImageData = im2bw(targetImageData, level);

%targetImageData = rgb2gray(targetImageData); % Convert to gray scale 
%targetImageData = gray2ind(targetImageData);
    %%%level = graythresh(targetImageData)
    %%%targetImageData = im2bw(targetImageData, level);

    %%%figure; imshow(targetImageData)
    
%Make image greyscale
if length(size(targetImageData)) == 3
	im =  double(targetImageData(:,:,2));
else
	im = double(targetImageData);
end

cs = fast_corner_detect_9(im, 30);
%c = fast_nonmax(im, 30, cs);

% get the corners
%[x_cooridnatesOfCorners y_cooridnatesOfCorners ] = GetOuter4Corners( cs );

image(im/4)
axis image
colormap(gray)
hold on
plot(cs(:,1), cs(:,2), 'r.')
%plot(c(:,1), c(:,2), 'g.')

% -------------------- TEST AREA ----------------------------
BW = im2bw (targetImageData);

[B,L,N] = bwboundaries(BW);
%figure; 
%imshow(BW); hold on;
for k=1:length(B),
    boundary = B{k};
    %if(k > N)
    if(k == 2)
        zoom on 
        hold on
        %plot(boundary(:,2),...
        %    boundary(:,1),'r','LineWidth',2); 
        size(boundary)
       
        plot(boundary(:,2),boundary(:,1),'o');         
        
        %plot(99,48,'x');      
        %plot(297,48,'x');           
        %plot(232,223,'x');         
        %plot(34,223,'x');   
                
    else
    %    plot(boundary(:,2),...
    %        boundary(:,1),'r','LineWidth',2);
    end
end

B{2} = fliplr (B{2});

% use boundary points (boundary) to find concurrency of points at corner points (cs)
concurrencyPoints = traceConcurrencyPoints( B{2}, cs);
%concurrencyPoints = traceConcurrencyPoints2( B, cs);
plot(concurrencyPoints(:,1), concurrencyPoints(:,2), 'g')

concurrencyPoints = Get4Points (concurrencyPoints);
figure
plot(concurrencyPoints(:,1), concurrencyPoints(:,2), 'x')

% -------------------- TEST AREA ----------------------------

%legend('9 point FAST corners', 'nonmax-suppressed corners')
%legend('9 point FAST corners', 'Outer Most Corners')
title('9 point FAST corner detection on an image')

% --------------------------
% The Perspective Correction
% --------------------------
X = concurrencyPoints(:,1);
Y = concurrencyPoints(:,2);
[X Y] = sortPolyFromClockwiseStartingFromTopLeft( X, Y );

x=[1;210;210;1];
y=[1;1;210;210];

% c)
A=zeros(8,8);
A(1,:)=[X(1),Y(1),1,0,0,0,-1*X(1)*x(1),-1*Y(1)*x(1)];
A(2,:)=[0,0,0,X(1),Y(1),1,-1*X(1)*y(1),-1*Y(1)*y(1)];

A(3,:)=[X(2),Y(2),1,0,0,0,-1*X(2)*x(2),-1*Y(2)*x(2)];
A(4,:)=[0,0,0,X(2),Y(2),1,-1*X(2)*y(2),-1*Y(2)*y(2)];

A(5,:)=[X(3),Y(3),1,0,0,0,-1*X(3)*x(3),-1*Y(3)*x(3)];
A(6,:)=[0,0,0,X(3),Y(3),1,-1*X(3)*y(3),-1*Y(3)*y(3)];

A(7,:)=[X(4),Y(4),1,0,0,0,-1*X(4)*x(4),-1*Y(4)*x(4)];
A(8,:)=[0,0,0,X(4),Y(4),1,-1*X(4)*y(4),-1*Y(4)*y(4)];

v=[x(1);y(1);x(2);y(2);x(3);y(3);x(4);y(4)];

u=A\v;
%which reshape

U=reshape([u;1],3,3)';

w=U*[X';Y';ones(1,4)];
w=w./(ones(3,1)*w(3,:));

% d)
%which maketform
T=maketform('projective',U');

%which imtransform
P2=imtransform(targetImageData, T,'XData',[1 210],'YData',[1 210]);

% e)
figure
imshow(P2)

