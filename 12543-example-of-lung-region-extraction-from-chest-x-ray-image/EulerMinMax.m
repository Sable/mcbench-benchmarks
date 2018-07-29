function c = EulerMinMax(i,b)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function extract a binary image from gray scale image
% using auto-tuned threshold value obtained from the correlation
% of Image euler numbers. This work had been published in 
%
% L.P Wong, H.T Ewe. 
% A Study of Lung Cancer Detection using Chest X-ray Images. 
% 3rd APT Telemedicine Workshop 2005, 27-28th January 2005, Kuala Lumpur, 
% Malaysia. Pages 210-214.
%
% c is the binary image output from the calculation 
% i is the input Gray Scale Image (E.g unit8 image)
% b is then number of level used to calculate the threshold (E.g 255)
%
% Example:
% a = imread('case1_pa_wo.tif');
% c = eulerminmax(a,255); 
% imshow(c);
%
% This function works for Matlab 7.0 with bweuler() and histeq() function
% from Image Processing Toolbox. No further validation for other version. 
%
% Wong Lip Pang 2006
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = histeq(i);
trans_thresh = mrdivide(0:1:b,b); % Here is to set an array for 
                                  %  calculating different euler number      
        for j=1:(b+1)
            value_trans1 = trans_thresh(1,j);
            result4_trans1(j,1) = bweuler(im2bw(a,value_trans1),4);
        end
max_result4_trans1 = max(result4_trans1); % Calculating max of euler number  
min_result4_trans1 = min(result4_trans1); % Calculating min of euler number
m = 0;
n = 0;
max_sum_result4_trans1 = 0;
min_sum_result4_trans1 = 0;
for j = 1:(b+1)
    if result4_trans1(j,1) == max_result4_trans1
        m = m+1;
        max_sum_result4_trans1 = max_sum_result4_trans1 + j;
    
    elseif result4_trans1(j,1) == min_result4_trans1
        n = n+1;
        min_sum_result4_trans1 = min_sum_result4_trans1 + j;
    
    else
        %Should Do Nothing Here
    end
end
% Getting the mean of the threshold
threshold_I1 = ((max_sum_result4_trans1)+(min_sum_result4_trans1))/(m+n);
c =  im2bw(a,threshold_I1/(b+1));
