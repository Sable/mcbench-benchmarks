function hasil=imagerotation(img_in,rotDeg);
%IMAGEROTATION Rotate image 
%   IMAGEROTATION rotate an image by any angle in degree. 
%   This is a simple implementation of IMROTATE. 
%   Implementation based on affine transformation matrix.
%   The rotated image is cropped, some pixels are missing
%   Example:
%            imin   = imread('cameraman.tif');
%            imout30 = imagerotation(imin, 30); % rotate image by 30 degree
%            imoutS = imagerotation(imin, 45) % rotate image by 45 degree
%
%Created by Archezus at Yahoo dot Com - 20110318
%Department of Computer Engineering
%University of Indonesia


[row col]=size(img_in);

for i=1:row
    for j=1:col
        xyRot = [i-floor((col+1)/2) -j+floor((row+1)/2)]*[cos(rotDeg*pi/180)  sin(rotDeg*pi/180);-sin(rotDeg*pi/180) cos(rotDeg*pi/180)];
        xRot=round(xyRot(1,1));
        yRot=round(xyRot(1,2));
        
        test=[i j;
        i -j;
        i-floor((col+1)/2) -j+floor((row+1)/2);
        xRot yRot;
        xRot+floor((col+1)/2) floor((row+1)/2)-yRot];
    
        if (1 <=test(5,2)) & (test(5,2)<=row) & (1 <=test(5,1)) & (test(5,1)<=col)
            img_out(j,i)=img_in(test(5,2),test(5,1));
            %disp('good');
        else
            % this is where the cropping happens
            img_out(j,i)=0; % set offside element to zero 
            %disp('bad')
        end
    
    end
end

imshow(img_in); title('original image');
figure; imshow(img_out); title ('rotated image');
truesize(size(img_out)); 