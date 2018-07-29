function [nsigma]=Nsigmaest1(Nimg)
% nsigma = Nsigmaest1 (Nimg);
% 
% estimates the noise standard deviation from an (MRI) image (2D) corrupted with
% Rician noise based on the skewness of the distribution. This method
% dosen't depend on the background for noise estimation. Can be used for
% MR images with and without background.
%
% Input : Nimg is the noisy image;
% 
% Ref : Jeny Rajan, Dirk Poot, Jaber Juntu and Jan Sijbers, "Noise
% measurement from magnitude MRI using local estimates of variance and
% skewness", Physics in Medicine and Biology, Vol 55, N441-N449,2010.
%
% This program uses the lookup table as explained in the paper and
% Nsigmaest2 uses the corresponding polynomial expression.
%
% Created by Jeny Rajan, University of Antwerp
% 
% if you have any comments, send to jenyrajan@gmail.com or
% jeny.rajan@ua.ac.be

load index22a %loading the lookup table
[x y]=size(Nimg);
P=zeros(x,y);
w=7; %default window size (change the window size according to the resolution of the image, for an image with a dimension
%less than 128x128, a window size of 5 can give more accurate value than 7.
%for an image with dimension above 256x256, window size of 7 or 9 might be
%better.
sk=colfilt(Nimg,[w w],'sliding',@skewness);%local estimation of skewness
sd=colfilt(Nimg,[w w],'sliding',@var);%local estimation of variance
for i=1:x
    for j=1:y
        [f3 f4]=min(abs(S-sk(i,j)));
        C=E(f4(1));
        P(i,j)=sqrt(sd(i,j)*C);              
    end
end
% histogrmA1 = histc(P(:),[1:0.01:max(P(:))]);
% histogrmA1=colfilt(histogrmA1,[3 1],'sliding',@mean);
% [row,col] = find(histogrmA1==max(histogrmA1));
% nsigma = row(1,1)/100;
nsigma = mode(round(P(P>0)));%(P>0 is to avoid artifical background introduced by masking)
end




