clear all;
close all;
clc;
% (c) 2010 Nikos Papamarkos
% Democritus University of Thrace, Greece.
% papamark@ee.duth.gr
% This program performs Multithresholding (gray-scale reduction).
% The program is based on the algorithm described in the following paper:  
% N. Papamarkos and B. Gatos "A new approach for multithreshold selection"
% Computer Vision, Graphics, and Image Processing-Graphical Models and Image 
% Processing, Vol. 56, No. 5, pp. 357-370, Sept. 1994 

warning('off');
img = imread('lena.bmp');
figure(1), imshow(img);
title('Initial Image');
%   If the image is color it is converted  to grayscale
if (size(img,3)~=1)
    Y = rgb2gray(img);
    figure(2), imshow(Y);
    title('Grayscale Image');
else
    Y = img;
end;

% Histogram calculation
Im_Histy = imhist(Y);

figure(3);
imhist(Y);
axis([0 256 0 max(Im_Histy)]);
title('Histogram');
%Apply Hill-Clustering to find the peaks
ITER=0;
lastIter = 1;
flag=0;
while (flag==0)
    M0 = input('Give the proper number of peaks: ');
    disp(' ');
    if ((isempty(M0))||(M0<2))
        disp('Please give a valid number of peaks (larger or equal of two).');
        disp(' ');
    else
        Regions = M0+1;   
        peaks = zeros(1,M0);
        copyPeak = 0;
        g = Im_Histy;
        %This loop is terminated when we found a number of peaks less than M0 
        %or if the sige of g is less thna 15
        while((Regions>M0)&&(length(g)>15)) 
            ITER = ITER+1;
            d = zeros(size(g));
            for i=2:length(g)-1
                if ((g(i)~=0)&&(g(i-1)>g(i+1))&&(g(i-1)>=g(i)))
                    d(i)=1;
                elseif ((g(i)~=0)&&(g(i+1)>g(i-1))&&(g(i+1)>=g(i)))
                    d(i)=-1;
                elseif (g(i-1)==g(i+1))
                    d(i) = d(i-1);
                end
            end
            if (((d(end-2)==-1)&&(d(end-1)==0))||(d(end-1)==-1))
                d(end) = 1;
            end
            ind1=find(d==0);
            if (~isempty(ind1))
                if(ind1(end)==length(d))
                    ind1 = ind1(1:end-1);
                end
                ind2 = find(d(ind1+1)==1);
                peak1= ind1(ind2);
            else
                peak1 = [];
            end
            ind1=find(d==-1);
            if (~isempty(ind1))
                if(ind1(end)==length(d))
                    ind1 = ind1(1:end-1);
                end
                ind2 = find(d(ind1+1)==1);
                peak2= ind1(ind2);
            else
                peak2 = [];
            end
            Regions = length(peak1)+length(peak2);
            if ((M0>=Regions)&&(ITER==1))
                disp('The number of peaks is too big!!!');
                disp(' ');
                break;
            end;
            flag=1;
            % The peaks are stored if their number is greater or equal to MO
            % In the case when the number of peaks are less than MO we use 
            % the peaks obtained from the previous iteration.
            if (Regions>=M0)
                copyPeak = [peak1;peak2];
                lastIter = ITER;
            end
            g = g(1:2:end);
            g = (g(1:end-1)+g(2:end)).*0.5;
        end
    end
end

newPeaks = [peak1;peak2];
flag = 0;
newM0 = 0;

if (length(copyPeak)>M0)
    if ((length(newPeaks)<M0)&&(length(newPeaks)~=1))
        str1 = sprintf('The recommended number of Thresholds is %d or %d',length(newPeaks),length(copyPeak));
        disp(str1);
        disp('You can select one of them or insist to your initial choice.');  
        str1 = sprintf('Select number of Thresholds (%d,%d,%d): ',length(newPeaks),M0,length(copyPeak));
        newM0 = input(str1);
        while((newM0~=length(newPeaks))&&(newM0~=length(copyPeak))&&(newM0~=M0))
            str1 = sprintf('You should select one of these numbers: %d,%d,%d',length(newPeaks),M0,length(copyPeak));
            disp(str1)
            newM0 = input('Please give a valid number: ');
        end
        if (newM0==length(copyPeak))
            flag = 1;
        elseif (newM0==length(newPeaks))
            flag=1;
            copyPeak = newPeaks.*2;
        end
    else
        str1 = sprintf('The recommended number of Thresholds is %d',length(copyPeak));
        disp(str1);
        disp('You can select one of them or insist to your initial choice.');  
        str1 = sprintf('Select the number of Thresholds (%d,%d): ',M0,length(copyPeak));
        newM0 = input(str1);
        while((newM0~=length(copyPeak))&&(newM0~=M0))
            str1 = sprintf('You should select one of these numbers: %d,%d',M0,length(copyPeak));
            disp(str1)
            newM0 = input('Please give a valid number: ');
        end
        if (newM0==length(copyPeak))
            flag = 1;
        end
    end
end
peaks = zeros(1,M0);
if (flag==1)
    peaks = OrderPeaks(copyPeak,Regions);
    peaks = peaks.*2^(lastIter-1);
else
    % If the number of peaks are less than MO we will use and some peaks 
    % obtained in the previous iteration. 
    % The additional peaks are obtained as the M0 - length(newPeaks)
    % elements of array copyPeak. 
    
    if ((length(copyPeak)>M0)&&(length(newPeaks)<=M0))
        newPeaks = newPeaks.*2;
        index1 = zeros(size(copyPeak));
        index2 = zeros(size(copyPeak));
        count1 = 1;
        count2 = 1;
        for i=1:length(copyPeak)
            var1 = find(newPeaks==copyPeak(i));
            if (isempty(var1)==1)
                var1 = find(newPeaks==copyPeak(i)+1);
                if (isempty(var1)==1)
                    var1 = find(newPeaks==copyPeak(i)-1);
                end
            end
            if (isempty(var1)==1)
                index2 (count2) = i;
                count2 = count2+1;
            else
                index1 (count1) = i;
                count1= count1+1;
            end

        end
        index1 = index1(1:count1-1);

        index2 = index2(1:count2-1);
        copyPeak = copyPeak.*2^(lastIter-1);
        while (length(index1)+length(index2)>M0)
            ind = find(Im_Histy(copyPeak(index2))==min(Im_Histy(copyPeak(index2))));
            index2(ind) = [];
        end
        peaks = [copyPeak(index1);copyPeak(index2)];
        peaks = OrderPeaks(peaks,Regions);
    elseif(length(newPeaks)>M0)
        peaks = OrderPeaks(copyPeak,Regions);
        peaks = peaks.*2^(lastIter-1);
        while (length(peaks)>M0)
            ind = find(Im_Histy(peaks)==min(Im_Histy(peaks)));
            peaks(ind) = [];
        end
    else
        peaks = OrderPeaks(copyPeak,Regions);
        peaks = peaks.*2^(lastIter-1);
    end
end

disp('The peaks of the histogram are at:');
disp(peaks);
disp(' ');
figure(3);
hold on;
for i=1:length(peaks)
    p1 = line([peaks(i),peaks(i)],[0,max(Im_Histy)],'Color',[1 0 0],'LineWidth',2);
end
Regions = length(peaks);

if (Regions==1)
    Thresh = 0;
else
    Thresh = zeros(1, Regions-1);
end

disp('Press return, to compute the thresholds');
disp(' ');
pause;

%Thresholds calculation

for i=1:length(Thresh)
    x = [1:peaks(i+1)-peaks(i)+1]';
   % The polyval function is used for fitting
    LMS = bestPol(x,Im_Histy(peaks(i):peaks(i+1)));
    hold on;
    p2 = plot(x+peaks(i)-1,LMS,'g','LineWidth',2);
    % Find the local minimum
    n = findmins(LMS);
    % Find the global minimum
    min_ = n(find(LMS(n)==min(LMS(n))));
    min_ = min_(1);
    % Obtain the Threshold
    Thresh(i) = peaks(i)+min_ -1;
    p3 = line([Thresh(i),Thresh(i)],[0,max(Im_Histy)],'Color',[1 0 1],'LineWidth',2);
end
figure(3);
legend([p1,p2,p3],'Peaks','Histogram Approximation', 'Thresholds',1);
hold off;
disp('The thresholds of the histogram are at:');
disp(Thresh);
disp(' ');

disp('Press return, to display the image after segmentation');
disp(' ');
pause;
% Convert the image 
PixVal = round(256/length(Thresh));
copy_img = Y;
for i=1:length(Thresh)
    if (i==1)
        copy_img(find(Y<Thresh(i))) = 1;
    else
        copy_img(find(Y<Thresh(i))) = (i-1)*PixVal;
    end
    Y(find(Y<Thresh(i))) = 255;
end
Y(find(Y==255)) = 1;
copy_img(find(Y>=Thresh(end))) = 256;
figure(4);
imshow(copy_img);
title('Image after Multithresholding');


