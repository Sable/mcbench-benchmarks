%Tristan Ursell
%March 2012
%
%Create an image with randomly positioned, diffraction-limited spots with 
%full data on actual spot positions and parameters.  Useful for testing a
%spot finding algorithm.
%
%[Iout,Inoise,spot_data]=spotmaker([im_sz],num_spots);
%[Iout,Inoise,spot_data]=spotmaker([im_sz],num_spots,'field',value);
%
%im_sz = two column vector specifying the size (rows,columns) of the output
%image.
%
%num_spots = integer value number of spots to appear in the image.
%
%Iout = full output image, with spots and noise according to all specified
%parameters.
%
%Inoise = only the noise that appears in Iout.
%
%The output 'spot_data' is a structure array with fields:
%
% spot_data.Xcent(i) = x-center of the Gaussian spot i.
% spot_data.Ycent(i) = y-center of the Gaussian spot i.
% spot_data.ints(i) = peak height (intensity) of the Gaussian spot i.
% spot_data.stds(i) = peak width (STD) of the Gaussian spot i.
%
% length(spot_data.Xcent) = number of spots
%
%The possible field entries are:
%
%'spot_pos' is an optional specification of where the spots should occur in
%the image.  The input should be a two column matrix of X and Y positions.
%Regardless of the value of 'num_spots', the script will use:
%
%   num_spots = length(X);
%
%'noise_mu' (-Inf < noise_mu < Inf) is the mean intensity of Gaussian noise
%in the output image.  The default value is 0.
%
%'noise_std' (0 < noise_std < Inf) is the standard deviation of the
%Gaussian noise in the output image.  The default value is 0.
%
%'int_mu' (0 < int_mu < Inf) is the mean spot intensity.  The default value
%is 1.
%
%'int_std' (0 < int_std < Inf) is the standard deviation in spot intensity.
%The default value is 0.
%
%'wid_mu' (0 < wid_mu < Inf) is the mean width of the spot intensity
%distribution.  The default value is 4.
%
%'wid_std' (0 < wid_std < Inf) is the standard deviation in the widths of
%the spot intensity distributions.  The default value is 0.
%
%'plot' with value 1 will produce an output plot of Iout with the spot
%centers marked by red circles.
%
%Simple Example:
%[Iout,Inoise,spot_data]=spotmaker([400,500],200,'plot',1);
%
%More Complex Example:
%[Iout,Inoise,spot_data]=spotmaker([400,500],200,'plot',1,'noise_mu',100,...
%'noise_std',20,'int_mu',100,'int_std',20,'wid_std',1);
%
%Specified Position Example:
%Xin=linspace(10,400,10)';
%Yin=linspace(10,300,10)';
%
%[Iout,Inoise,spot_data]=spotmaker([320,420],200,'spot_pos',[Xin,Yin],'plot',1,...
%'noise_mu',100,'noise_std',20,'int_mu',100,'int_std',20,'wid_std',1);
%
%%write to 8 bit output image:
%imwrite(uint8(255*mat2gray(Iout)),'spot_test.tif','Compression','none')
%

function [Iout,Inoise,spot_data]=spotmaker(im_sz,num_spots,varargin)

%parse and check inputs
if or(im_sz(1)<5,im_sz(2)<5)
    error('The image size must be greater than 5 x 5 pixels.')
end

num_spots=round(num_spots);
if num_spots<1
    error('The number of spots in the image must be greater zero.')
end

%number of input fields
f1=find(strcmp('noise_mu',varargin));
f2=find(strcmp('noise_std',varargin));
f3=find(strcmp('int_mu',varargin));
f4=find(strcmp('int_std',varargin));
f5=find(strcmp('wid_mu',varargin));
f6=find(strcmp('wid_std',varargin));
f7=find(strcmp('plot',varargin));
f8=find(strcmp('spot_pos',varargin));

if ~isempty(f1)
    noise_mu=varargin{f1+1};
else
    noise_mu=0;
end

if ~isempty(f2)
    noise_std=varargin{f2+1};
    if noise_std<0
        error('The noise standard deviation must be positive.')
    end
else
    noise_std=0;
end

if ~isempty(f3)
    int_mu=varargin{f3+1};
    if int_mu<0
        error('The mean spot intensity must be positive.')
    end
else
    int_mu=1;
end

if ~isempty(f4)
    int_std=varargin{f4+1};
    if int_std<0
        error('The spot intensity standard deviation must be positive.')
    end
else
    int_std=0;
end

if ~isempty(f5)
    wid_mu=varargin{f5+1};
    if wid_mu<0
        error('The mean spot width must be positive.')
    end
else
    wid_mu=4;
end

if ~isempty(f6)
    wid_std=varargin{f6+1};
    if wid_std<0
        error('The standard deviation in spot width must be positive.')
    end
else
    wid_std=0;
end

if ~isempty(f7)
    plotq=varargin{f7+1};
    if and(plotq~=0,plotq~=1)
        error('Invalid plot option.')
    end
else
    plotq=0;
end

if ~isempty(f8)
    pos_in=varargin{f8+1};
    posq=1;
    if or(size(pos_in,1)<1,size(pos_in,2)~=2)
        error('Input spot position matrix must be N x 2 with N>0.')
    end
    
    %spot position conditions
    cond1=min(pos_in(:,1)<1);
    cond2=min(pos_in(:,2)<1);
    cond3=max(pos_in(:,1)>im_sz(2));
    cond4=max(pos_in(:,2)>im_sz(1));
    
    if or(or(cond1,cond2),or(cond3,cond4))
        error('Spot positions and image dimensions do not match.')
    end
else
    posq=0;
end

%*************************************************************************
%compute position matrices
Xpos = ones(im_sz(1),1)*(1:im_sz(2));
Ypos = (1:im_sz(1))'*ones(1,im_sz(2));
   
%create centroid list
if posq==0
    spot_data.Xcent=im_sz(2)*rand(1,num_spots);
    spot_data.Ycent=im_sz(1)*rand(1,num_spots);
else
    spot_data.Xcent=pos_in(:,1);
    spot_data.Ycent=pos_in(:,2);
    num_spots=size(pos_in,1);
end

%generate intensities
spot_data.ints=abs(normrnd(int_mu,int_std,[1,num_spots]));

%generate standard deviations
spot_data.stds=abs(normrnd(wid_mu,wid_std,[1,num_spots]));

%generate noise image
Inoise=normrnd(noise_mu,noise_std,[im_sz(1),im_sz(2)]);

%create basal image
Iout=Inoise;

%construct output image
h0=waitbar(0,'Computing light field ...');
for p=1:num_spots
    Itemp=spot_data.ints(p)*exp(-((Xpos-spot_data.Xcent(p)).^2....
        +(Ypos-spot_data.Ycent(p)).^2)/(2*spot_data.stds(p)^2));
    Iout=Iout+Itemp;
    waitbar(p/num_spots,h0);
end
close(h0)

if plotq==1
    figure;
    hold on
    imagesc(Iout)
    axis equal tight
    box on
    colormap(gray)
    xlabel('X')
    ylabel('Y')
    plot([spot_data.Xcent],[spot_data.Ycent],'ro')
    title(['spotmaker.m, spots: ' num2str(num_spots)])
end           

      


    










