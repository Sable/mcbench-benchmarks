%**************************************************************************
%**************************************************************************
%   
% MinCE is a function for thresholding using Minimum Cross Entropy
% The code calculates
% 
% input = I ==> Image in gray level 
% output =
%           I1 ==> binary image
%           threshold ==> the threshold choosen by MinCE
%  
% F.Gargouri
%
%
%**************************************************************************
%**************************************************************************

function [threshold I1]=minCE(I)
    h=imhist(I);
    [n,m]=size(I);
    %normalize the histogram ==>  hn(k)=h(k)/(n*m) ==> k  in [1 256]
    hn=h/(n*m);

    % entropy of gray level image
    imEntropy=double(0);
    for i=1:256
        imEntropy=double(imEntropy+(i*hn(i)*log(i)));
    end

    % MCE
    for t=1:256
        % moyenne de Low range image
        lowValue= 0;
        lowSum= 0;
        for i=1:t
            lowValue=lowValue+(i*hn(i));
            lowSum=lowSum+hn(i);
        end
        if lowSum>0
            lowValue=lowValue/lowSum;
        else
            lowValue=1;
        end

        % moyenne de High range image
        highValue= 0;
        highSum= 0;
        for i=t+1 : 256
            highValue=highValue+(i*hn(i));
            highSum=highSum+hn(i);
        end
        if highSum>0
            highValue=highValue/highSum;
        else
            highValue=1;
        end

        % Entropy of low range 
        lowEntropy=0;
        for i=1:t
            lowEntropy=lowEntropy+(i*hn(i)*log(lowValue));
        end      

        % Entropy of high range 
        highEntropy=0;
        for i=t+1 : 256
            highEntropy=highEntropy+(i*hn(i)*log(highValue));
        end

        % Cross Entropy 
        highEntropy;
        lowEntropy;
        imEntropy;
        CE(t)= imEntropy - lowEntropy - highEntropy; 
    end
    %

    % choose the best threshold

    D_min =CE(1);
    entropie(1)=D_min;
    threshold = 0;
    for t=2:256
        entropie(t)=CE(t);
        if entropie(t)<D_min
            D_min=entropie(t);
            threshold=t-1;
        end
    end

    %****************

    % Display    
    I1 = zeros(size(I));
    I1(I<threshold) = 0;
    I1(I>threshold) = 255;
    %imshow(I1) 
end