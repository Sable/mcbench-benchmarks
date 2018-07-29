%Tristan Ursell
%Relative Noise Transform
%(c) November 2012
%
%Iout=relnoise(Iin,sz,sigma);
%Iout=relnoise(Iin,sz,sigma,'field');
%[Iout,Ivar]=relnoise(Iin,sz,sigma,...);
%[Iout,Ivar,Imean]=relnoise(Iin,sz,sigma,...);
%
%Iin = the input image, of any numerical class.
%
%sz = (3 < sz < min(size(Iin))) is the size of the filter block used to
%calculate means and variances.  This value must be odd.
%
%sigma (sigma > 0) is the weighting parameter that defines the standard
%deviation relative to the filter block's standard deviation around which
%the center pixel will be Gaussian weighted. Setting sigma = 1 weights the
%current pixel using the STD of the current filter block. Lower values
%bring the current pixel closer to the mean, while high values are more
%tolerant of variations.  As sigma -> Inf, Iout = Iin.
%
%The field 'plot' will create an output plot comparing this transform to
%the original image, a Gaussian blur with STD = sz/2, and median filter 
%with block size equal to sz.  At first glance, this filter appears similar
%to a median transform, but it does a better job of preserving local
%intensity extrema.  Comparison with the median filter requires the Image
%Processing Toolbox, but the rest of the script does not.
%
%The field 'disk' or 'square' will choose between using a disk or square
%filter block shape, where sz is the disk diameter or square side length.
%The default is square.
%
%The field 'custom' may be followed by a user-defined logical matrix or
%strel, e.g. relnoise(Iin,sz,sigma,'custom',strel('line',30,45)).  In this
%case 'sz' will be unused.
%
%Iout is the transformed output image.
%
%Ivar is the variance of the pixel intensities in the filter block at every
%point in the image -- essentially the spatially varying variance of the
%image.
%
%Imean is the mean smoothed image using the filter block, equivalent to a
%convolution averaging filter with the specified neighborhood.
%
%see also: wiener2  filter2
%
%Example:
%
%Iin=imread('spot_test.tif');
%
%Iout=relnoise(Iin,3,0.5,'square','plot');
% %OR
%Iout=relnoise(Iin,3,0.5,'custom',strel('line',30,0),'plot');
%
%figure;
%subplot(1,2,1)
%imagesc(Iout-double(Iin))
%title('What was removed from the original image.')
%axis equal tight
%box on
%
%subplot(1,2,2)
%imagesc(abs(fftshift(fft(Iout-double(Iin)))))
%title('FFT of difference between original and filtered images.')
%axis equal tight
%box on
%

function [varargout]=relnoise(Iin,sz,sigma,varargin)

%Nans
Inan=isnan(Iin);
if sum(Inan(:))>0
    error('Input matrix contains NaNs.')
end

%convert type
Iin=double(Iin);

%check filter size
if or(sz<1,sz>min(size(Iin)))
    error('The filter size is out of bounds.')
end

if mod(sz,2)~=1
    error('The filter size must be an odd integer.')
end

%parse field input
f1=find(strcmp('plot',varargin),1);
f2=find(strcmp('disk',varargin),1);
f3=find(strcmp('custom',varargin),1);

%choose plot option
if ~isempty(f1)
    plotq=1;
else
    plotq=0;
end

%choose filter type
if ~isempty(f3)
    hood_temp=varargin{f3+1};
    if strcmp(class(hood_temp),'strel')
        hood=hood_temp.getnhood;
    else
        hood=hood_temp;
    end
    
    sz=round(mean(size(hood)));
elseif ~isempty(f2)
    %disk filter block
    Xdisk = ones(sz,1)*(-(sz-1)/2:(sz-1)/2);
    Ydisk = (-(sz-1)/2:(sz-1)/2)'*ones(1,sz);
    Zdisk = sqrt(Xdisk.^2 + Ydisk.^2);
    
    hood=zeros(sz,sz);
    hood(Zdisk<=(sz-1)/2)=1;
else
    %square filter block
    hood=ones(sz,sz);
end

%convert hood class
hood=single(hood);

%calcualte means and variances
hood_sz=sum(hood(:));

%perform convolultion and normalization
Imean0=conv2(Iin,hood,'same')/hood_sz;
Inorm=conv2(ones(size(Iin)),hood,'same')/hood_sz;
Imean=Imean0./Inorm;
Ivar=conv2(Iin.^2,hood,'same')./Inorm*1/hood_sz-Imean.^2;

%compute weight matrix
W=exp(-(Iin-Imean).^2./(2*sigma^2*Ivar));

%correct for zero variance pixels
W(Ivar==0)=0;

%compute output image
if sigma==0
    Iout=Imean;
else
    Iout=Iin.*W+(1-W).*Imean;
end

%handle outputs
if nargout==1
    varargout{1}=Iout;
elseif nargout==2
    varargout{1}=Iout;
    varargout{2}=Ivar;
elseif nargout==3
    varargout{1}=Iout;
    varargout{2}=Ivar;
    varargout{3}=Imean;
elseif nargout==0
else
    error('Incorrect number of output arguments.')   
end

%plot comparisons
if plotq==1  
    
    figure;
    subplot(2,2,1)
    imagesc(Iin)
    xlabel('X')
    ylabel('Y')
    box on
    axis equal tight
    title('Original Image')
    
    subplot(2,2,2)
    imagesc(Iout)
    xlabel('X')
    ylabel('Y')
    box on
    axis equal tight
    title(['Relative Noise Reduction (this filter), size = ' num2str(sz) ', sigma = ' num2str(sigma)])
    
    subplot(2,2,3)
    %look for image processing toolbox
    boxes=ver;
    gotit=strfind([boxes.Name],'Image Processing Toolbox');
    if ~isempty(gotit)
        Iout2=medfilt2(Iin,[sz,sz],'symmetric');
    else
        disp('Sorry, you do not have the Image Processing Toolbox.')
        disp('The medfilt2 comparison image cannot be generated.')
        disp('Disabling `plot` will stop this message.')
        Iout2=Imean;
    end
    imagesc(Iout2)
    xlabel('X')
    ylabel('Y')
    box on
    axis equal tight

    if ~isempty(gotit)
        title(['Median Filter of size ' num2str(sz)])
    else
        title(['Mean Filter of size ' num2str(sz)])
    end
    
    %construct Gaussian filter (without Image Processing Toolbox)
    sz2=round(3/2*sz);
    Xgauss = ones(sz2,1)*(-(sz2-1)/2:(sz2-1)/2);
    Ygauss = (-(sz2-1)/2:(sz2-1)/2)'*ones(1,sz2);
    Zgauss = exp(-(Xgauss.^2+Ygauss.^2)/(2*(sz/2)^2));
    Zgauss = Zgauss/sum(Zgauss(:));
    Iout3=conv2(Iin,Zgauss,'same');
    
    subplot(2,2,4)
    imagesc(Iout3)
    xlabel('X')
    ylabel('Y')
    box on
    axis equal tight
    title(['Gaussian Blur with STD = ' num2str(sz/2)])
    pause(0.1)
end
    
    
    
    
    
    
