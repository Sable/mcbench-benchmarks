% Program by Krish Mangal, R Harsha Vardhan and R Umesh Reddy, this program
% will be available for download in MATLAB central forever, on the Harsha's
% Account( http://goo.gl/cd7c ) along with other interesting programs we have 
% developed or will develop in future.
% 
% This program identifies all of the moving objects in a recorded video and
% shows those objects in color while displaying the other stationary
% objects in grayscale. This is a basic program which may be used with
% other programs which use applications of Motion Detection. Details of
% this technique are expained in the project report which comes along with
% this Program. We have used the function mmread also available on matlab
% central in our program, you must download this program also and add its
% location to MATLAB's path.
% 
% see also DSBAM SSBAM Kirsch
% 

clc
disp('Program by Krish Mangal, R Harsha Vardhan and R Umesh Reddy, IIT Patna');
clear all
close all
tic
h = waitbar(0,'Running......');
mov = (mmread('Input.wmv'));clc
disp('Program by Krish Mangal, R Harsha Vardhan and R Umesh Reddy, IIT Patna');
movi = mov.frames;
clear mov;
for i = 2:length(movi)
    movc = movi(i).cdata;
    waitbar(i/length(movi),h);
    movp = movi(i-1).cdata;
    u = motion(movc,movp);
    diff_img(i-1,:,:) = u;
    
end
close(h)


disp('Step 1 is completed Going for step 2 now!!!');
h = waitbar(0,'Running......');

movo = movi;
[a b c] = size(diff_img);
for k = 1:a
for i = 1:int32(b/5)
    for j = 1:int32(c/5)
        s = diff_img(k,(5*(i-1)+1):(5*(i-1)+5),(5*(j-1)+1):(5*(j-1)+5));
        s1(:,:) = s;
        q(i,j) = sum(sum(s1));
        if q(i,j)<500
            p(k,i,j) = false;
        else
            p(k,i,j) = true;
        end
        if(~p(k,i,j))
           temp = rgb2gray( movo(k).cdata((5*(i-1)+1):(5*(i-1)+5),(5*(j-1)+1):(5*(j-1)+5),1:3));
           for w = 1:3
           movo(k).cdata((5*(i-1)+1):(5*(i-1)+5),(5*(j-1)+1):(5*(j-1)+5),w) = temp;    
           end
        end     
    end
end
waitbar(k/a,h);
end
close(h)
clear movc movp diff_img temp q w  b u 
disp('Step 2 is completed Going for final step now!!! This step takes a lot of time ');

for b = 1:a+1
movds(:,:,:,b) = movo(b).cdata;
end

[d e f ] = size(p);
t = 1;
img_path = movi(1).cdata;
for k = 1:d
    for i = 1:e
       for j = 1:f
        if(p(k,i,j))
            x_coe(t) = i;
            y_coe(t) = j;
            t = t+1;
        end
       end 
    end
    xavg = int32(round((min(x_coe)+max(x_coe))/2));
    yavg = int32(round((min(y_coe)+ max(y_coe))/2));
    xcor = (2*xavg-1)*5/2;
    ycor = (2*yavg-1)*5/2;
   if k>1
    if xcor<xprev
        xsm = xcor;
        xlr = xprev;
    else
        
        xlr = xcor;
        xsm = xprev;
    end
    if ycor<yprev
        ysm = ycor;
        ylr = yprev;
    else
        
        ylr = ycor;
        ysm = yprev;
    end
    img_path(xsm:xlr,ysm:ylr,1) = 255;
    img_path(xsm:xlr,ysm:ylr,2) = 0;
    img_path(xsm:xlr,ysm:ylr,3) = 0;
    t=1;
    clear x_coe y_coe
   end
    xprev = xcor;
    yprev = ycor;
    
end
imshow(img_path)
disp('Execution Complete');
toc