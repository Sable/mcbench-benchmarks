function I_est=MRI_lmmse(Im,Ws,varargin)

%MRI_LMMSE Linear minimum Mean Square error Estimation of MRI data
%
% Filter assumes a Rician distribution with a Rayleigh Background
% Noise estimation is automatically performed using the background.
%
% Usage
%
%   I_est=MRI_lmmse(Im,[7,7],[Noise method]);
%
%
% DEFAULT: 
%
%   I_est=MRI_lmmse(Im,[7,7]);
%         Noise estimationmethod: mode2N
%
%   INPUTS:
%        - Im: input image
%        - Ws: Size [M,N] of the square window used for local estimation
%              Odd number recomended
%   
%  Noise Estimation Method:
%       y= MRI_lmmse(...,'sigma',sigma) Standard deviation of noise given
%                   - sigma: Standar deviation of noise
%       y= MRI_lmmse(...,'bckN2',threshold) Estimate the noise from the
%               background of the image based on order 2 moment
%                   - threshold: Threshold value for the mask
%       y= MRI_lmmse(...,'bckNm',threshold) Estimate the noise from the
%               background of the image based on the mean
%                   - threshold: Threshold value for the mask
%       y= MRI_lmmse(...,'momentN') Estimate the noise using the methods of
%               moments
%
%   The following methods may use a background mask
%
%       y= MRI_lmmse(...,'mask',threshold) A background mask is used.
%                   - threshold: Threshold value for the mask
%       y= MRI_lmmse(...,'histoN') Estimate the noise using the method
%               based on the mode of the histogram [Sijbers06]
%       y= MRI_lmmse(...,'mode2N') Estimate the noise using the mode of the
%               local order 2 moment [Aja06]
%       y= MRI_lmmse(...,'modeMN') Estimate the noise using the mode of the
%               local mean [Aja06]
%       y= MRI_lmmse(...,'modeVN') Estimate the noise using the mode of the
%               local variance [Aja06]
%       y= MRI_lmmse(...,'modeVN_NI') Estimate the noise using the mode of the
%  
%   Uses algorithms developed in
%
%           S. Aja-Fernández, C. Alberola-Lopez and C.-F. Westin. "Noise and Signal 
%           Estimation in Magnitude MRI and Rician Distributed Images: A LMMSE Approach",
%           IEEE Trans. on Image Processing, Vol. 17, No. 8, Aug. 2008, pp. 1383-1398.
%
%   Author: Santiago Aja Fernandez
%   www.lpi.tel.uva.es/~santi
%   Version 2.0  12/06/2012

[mask,thresM,noise,sigma] = parse_inputs(varargin{:});  

%Noise Estimation-------------------------------------------
%LOCAL STATISTICS
%Order 2 moment
En=filter2(ones(Ws), Im.^2) / (prod(Ws));
%Mean
Mn=filter2(ones(Ws), Im) / (prod(Ws));
%Variance
Vn=(prod(Ws)/(prod(Ws)-1)).*(En-Mn.^2);


if noise==0
%Sigma given
    sigma2=sigma.^2;
elseif noise==1
    mask =im2bw(1-double(imfill(Im>thresM,'holes')));
    sigma2=0.5.*(sum((Im(mask)).^2))./sum(mask(:));
    sigma=sqrt(sigma2);
elseif noise==2
    mask =im2bw(1-double(imfill(Im>thresM,'holes')));
    sigma=sqrt(2/pi).*(sum(Im(mask)))./sum(mask(:)); 
    sigma2=sigma^2;
elseif noise==3
    M2=mean(Im(:).^2);
    M4=mean(Im(:).^4);
    sigma2=0.5.*(M2-sqrt(sqrt(abs(2*M2^2-M4)))); 
    sigma=sqrt(sigma2);
elseif noise==4
    if mask==0
        I2=round(Im);
        Tp=max(I2(:));
        Tpm=min(I2(:));
        [h,x]=hist(I2(:),Tp);
        sigma=x(argmax(h));
    else
       mask =im2bw(1-double(imfill(Im>thresM,'holes')));
       Tp=max(I2(mask));
       [h,x]=hist(I2(mask),Tp);
       sigma=x(argmax(h));
    end
    sigma2=sigma^2;
elseif noise==5
    if mask==0
        sigma2=(prod(Ws)/(prod(Ws)-1)).*(moda(En,1000)./2);
    else
       mask =im2bw(1-double(imfill(Im>thresM,'holes'))); 
       sigma2=(prod(Ws)/(prod(Ws)-1)).*(moda(En(mask),1000)./2);  
    end
    sigma=sqrt(sigma2);
elseif noise==6
    if mask==0
        sigma=sqrt(2/pi).*moda(Mn,1000);
    else
        mask =im2bw(1-double(imfill(Im>thresM,'holes')));
        sigma=sqrt(2/pi).*moda(Mn(mask),1000);
    end
    sigma2=sigma^2;
elseif noise==7
    if mask==0
        sigma2=((2/(4-pi)).*moda(Vn,1000));    
    else
        mask =im2bw(1-double(imfill(Im>thresM,'holes')));
        sigma2=(2/(4-pi)).*moda(Vn(mask),1000); 
    end
    sigma=sqrt(sigma2);
elseif noise==8
    if mask==0
        sigma2=((prod(Ws)-1)/(prod(Ws)-3)).*moda(Vn,1000);      
    else
        mask =im2bw(double(imfill(Im>thresM,'holes')));
        sigma2=((prod(Ws)-1)/(prod(Ws)-3)).*moda(Vn,1000);   
    end
    sigma=sqrt(sigma2);
end

%End Noise estimation-----------------------------------------------


%FILTERING-----------------------------------------------

Qua=filter2(ones(Ws),Im.^4)./prod(Ws);
%Squ=filter2(ones(Ws),Im.^2)./prod(Ws);
Squ=En;
%Squ=Squ.*(Squ>2.*sigma2)+(Squ<=2.*sigma2).*2.*sigma2;
%Qua=Qua.*(Qua>8.*sigma2^2)+(Qua<=8.*sigma2^2).*8.*sigma2^2;


K1=1+(4.*sigma2^2-4.*sigma2.*Squ)./(Qua-Squ.^2);
K1=max(K1,0);
I_est=sqrt(Squ-2.*sigma2+K1.*(Im.^2-Squ));
%I_est= sqrt(Im.^2-2.*sigma2+0.5.*(1-K1).*(Squ-Ac.^2));
I_est=abs(I_est);


%--------------------------------------------------------------------------
function [mask,thresM,noise,sigma] = parse_inputs(varargin)
dfsteppos = -1;
mask=0;
thresM=0;
noise=5;
sigma=0;



for i = 1 : length(varargin)
   flag = 0;
   if i == dfsteppos
      flag = 1;
   end
   if strcmp(varargin{i},'mask')
       mask=1;
      thresM = varargin{i+1};
      flag = 1;
      dfsteppos = i+1;
    elseif strcmp(varargin{i},'sigma')
      noise=0;
      sigma = varargin{i+1};
      flag = 1;
      dfsteppos = i+1;
   elseif strcmp(varargin{i},'bckN2')
      noise=1;
      thresM = varargin{i+1};
      flag = 1;
      dfsteppos = i+1;
   elseif strcmp(varargin{i},'bckNm')
      noise=2;
      thresM = varargin{i+1};
      flag = 1;
      dfsteppos = i+1; 
   elseif strcmp(varargin{i},'momentN')
      noise=3;
      flag = 1;
    elseif strcmp(varargin{i},'histoN')
      noise=4;
      flag = 1;
   elseif strcmp(varargin{i},'mode2N')
      noise=5;
      flag = 1;
   elseif strcmp(varargin{i},'modeMN')
      noise=6;
      flag = 1;
   elseif strcmp(varargin{i},'modeVN')
      noise=7;
      flag = 1; 
    elseif strcmp(varargin{i},'modeVN_NI')
      noise=8;
      flag = 1;   
    end
   if flag == 0
      error('Too many parameters !')
      return
   end
end

%--------------------------------------------------------------
function m=moda(u,N)
% MODA   Mode of a distribution
%
%    m=MODE(u,N) calculates the mode of the set of data "u" using the histogram.
%    To avoid outliers, for the calculation are only taken into account those
%    values in [mean-2sigma, mean+2sigma];
%
%    INPUT:
%
%	- u (set of data)
%       - N: Number of points for the histogram. If N=0 then 5000 points are
%            considered
%
%   Author: Santiago Aja Fernandez
%   www.lpi.tel.uva.es/~santi
%   LOCAL STATISTICS TOOLBOX 
%
%   Modified: Feb 01 2008
%
u=double(u);
if N==0
	N=5000;
end
M1=mean(u(:));
V1=std(u(:));
C2=u( (u(:)>=(M1-2*V1)) & (u(:)<=(M1+2*V1)) ) ;
%C2=u;
[h,x]=hist(C2,N);
[M,M2]=max(h);
m=x(M2);
%
