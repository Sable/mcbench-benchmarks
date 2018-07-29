%   Kernel Wiener Filter (Kernel Dependency Estimation) using Canonical
%   Correlation Analysis Framework.
%
%   AUTHOR:    Makoto Yamada
%              (myamada@ism.ac.jp)
%   DATE:       12/25/07
% 
%  DESCRIPTION:
% 
%   This program compute the preimage by using kernel Wiener filter 
%   (kernel Dependency Estimation) with Canonical Correlation Analysis
%   framework. We applied the method to filtering problem with USPS dataset.
% 
%  INPUTS:
%       ninput:     "ninput" is an unknown m times 1 dimensional vector.
%
%            X:     "X" is a (n times N) dimensional input matrix,
%                   where "n" is the vector dimension and N is the number
%                    of samples.
%
%            Y:     "Y" is a (m times N) dimensional output matrix.
%                    where "m" is the vector dimension and N is the number
%                    of samples.
%
%       kcoeff:      "kcoeff" is a structure variable which contains 
%                    the coefficient of kernel Wiener filter.
%
%        param:      1. "param.s" is a parameter for Gaussian kernel, 
%                       exp(-norm(x - y)^2/s).
%                    2. "param.rnk" is a rank of kernel Wiener Filter.
%                    3. "param.nnear" is the Number of nearest nighbor
%                       vectors to estimate a pre-image.
%
%  Example:  
%              >demo_kwiener
%              
%              
%  Reference:  1. J. Weston et.al. ``Kernel Dependency Estimation,'' NIPS
%                 2003
%
%              2. M. Yamada and M. R. Azimi-Sadjadi, ``Kernel Wiener Filter
%                 using Canonical Correlation Analysis Framework,''
%                 IEEE SSP'05, Bordeaux, France, July 17-20, 2005. 
%
%              3. C. Cortes et.al. ``A General Regression Technique for
%                 Learning Transductions,'' ICML, Bonn, Germany, Aug 7-11.
%
%              4. M. Yamada and M. R. Azimi-Sadjadi, ``Kernel Wiener Filter
%                 with Distance Constraint,'' ICASSP,  Toulouse, France,
%                 May 14-19, 2006
%    
%              5. Zhe Chen et.al, ``Correlative Learning: A Basis for Brain and Adaptive
%                 Systems,'' Wiley, Oct. 2007 (Section 4.6)

clear all;
close all;

%Load USPS dataset.
load usps; 
%X is a latent variable, and Y are corresponding output variable
%Y = X + N. (A is a non-linear coefficient matrix and N is a noise

param.nnear = 20;      %Number of nearest nighbor vectors to estimate a pre-image.
param.s     = 256*0.7; %Gaussian Kernel Parameter


kcoeff = kwiener_train(X,Y,param.s);%Training Kernel Wiener Filter

%Rank of kernel Wiener filter.
rnk = [10 25 50 75 100 200 300 400 500 600 700 800 900 1000];
rnkmse = zeros(size(rnk));
rnkmsez = zeros(size(rnk));

%Predicting Pre-images
for kk = 1:size(rnk,2)
    param.rnk = rnk(kk);
    
    tic
    for ii = 1:100
        ninput = Ytest(:,ii); %Unknown noisy input
        pimage = kwiener_predict(ninput,X,Y,kcoeff,param);%Predicting the pre-image of "ninput".

        if ii == 1
            Z1 = pimage;
            mse = mean((pimage - Xtest(:,ii)).^2);
            msez = mean((Ytest(:,ii) - Xtest(:,ii)).^2);
        else
            zt1 = pimage;
            mse = [mse mean((zt1 - Xtest(:,ii)).^2)];
            msez = [msez mean((Ytest(:,ii) - Xtest(:,ii)).^2)];
            Z1 = [Z1 zt1];
        end
    end

    image = zeros(160,160);  %Input images.
    nimage = zeros(160,160); %Noisy images.
    zimage = zeros(160,160); %Preimages.
    
    %Change 1-D signal to 2-D signal.
    for ii = 1:10  
        for jj = 1:10
            tempx = mycol2im(Xtest(:,((ii -1)*10 + jj)),[1 1],[16 16]);
            image(((ii-1)*16 +1):16*(ii), ((jj-1)*16+1):16*(jj)) = -tempx;
        
            tempy = mycol2im(Ytest(:,((ii -1)*10 + jj)),[1 1],[16 16]);
            nimage(((ii-1)*16 +1):16*(ii), ((jj-1)*16+1):16*(jj)) = -tempy;
        
            tempz = mycol2im(Z1(:,((ii -1)*10 + jj)),[1 1],[16 16]);
            pre= -tempz;
            zimage(((ii-1)*16 +1):16*(ii), ((jj-1)*16+1):16*(jj)) = pre;
        end
    end

      figure; imagesc(zimage); colormap(gray); axis off;
      sstr = sprintf('Preimage with rank %d, MSE = %d', param.rnk, mean(mse));
      title(sstr);
    
    toc
    rnkmse(kk) = mean(mse);
    rnkmsez(kk) = mean(msez);
    clear mse;
    clear msez;
    disp(sstr);
end

figure; imagesc(image); colormap(gray);axis off;
figure; imagesc(nimage); colormap(gray);axis off;

figure;
plot(rnk,rnkmse); hold on;
plot(rnk,rnkmsez,'r'); hold off;
legend('Kernel Wiener Filter','Original Noise Level');
xlabel('Rank of Kernel Wiener Filter');
ylabel('MSE');
