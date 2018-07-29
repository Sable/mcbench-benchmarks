function outputfeature = fastflux2( image, ranges, sigma, pixelspacing)
% Compute the 2D multi-radii spherical (circular) flux responses 
% Usage: 
%  outputresponse = fastflux2(image, radii, sigma, pixelspacing)
% Explanation:
%  outputresponse (3D matrix): The final output response. (size(outputresponse)=[size(image,1) size(image,2) length(ranges)])
%  image (2D matrix): The original image. 
%  radii (N-D vector): A vector containing all interested radii for computation of 2D spherical (circular) flux. 
%  sigma (Scalar): A value that used for image smoothing in during the computation 
%  of spherical flux. 
%  pixelspacing (Scalar or 2D vector): It specifies the pixel size of the input image. This
%  parameter can be omitted if the values of radii and sigma are given in the
%  unit of pixel-length. For isotropic pixel size, pixel-dimension = pixelspace*pixelspace.
%  For anisotropic pixel size, pixelspacing defines the pixel-dimension as [rowwidth columnwidth].
%  Reference:
%  http://www.cse.ust.hk/~maxlawwk/
%  Max W.K. Law, Albert C.S. Chung,
%  [*] “Efficient Implementation for Spherical Flux Computation and Its Application 
%  to Vascular Segmentation”, IEEE Transactions on Image Processing, 18(3), 
%  pp. 596-612, 2009.
%
%  Example:
%  result = fastflux2(I, 1:5, 1);
%  Return the result computed from the radii {1,2,3,4,5} on image I.
%
%  result = fastflux2(I, 0.4:0.4:2.8, 1, 0.4);
%  Return the result computed from the radii (0.4mm,0.8mm,1.2mm,1.6mm,2mm,2.4mm,
%  2.8mm}, where the each pixel is 0.4mmx0.4mm
%
%  result = fastflux2(I, 2:5, 1, [1 1.4]);
%  Return the result computed from the raddi {2mm,3mm,4mm,5mm}, where each pixel
%  has a size of 1mm x 1.4mm (LxW).
%
%  Technical details:
%  The following variables correspond to the symbols in [*]
%  image -> I (After Equation 10)
%  ranges -> M (Equation 29)
%  sigma -> \sigma (Equation 7)
%  pixelspacing -> This is a new feature that is not mentioned in [*].
%  Note1 : This implementation is based on Subband_2 as stated in Fig. 2 in [*]
%  Note2 : An undersize \sigma (<0.5 pixel-length) may cause inaccurate computation. 
%          Please refer to pp.599-601 in [*].
%  Note3 : The 2D closed form computation is slightly different from the 3D 
%          computation as described in [*].
%  Note4 : The coefficient buffering and redundant coefficient elimination techniques in [*]
%          are not implemented in this script.

if (isempty(ranges))
    outputfeature(:, :, length(sigma)) = image;
    marginewidth = ceil(max(sigma(:))*3);
else
    outputfeature(:, :, length(ranges)) = image;
    marginewidth = ceil(max((ranges(:))) + sigma);
end

if exist('sigma', 'var')~=1
    sigma=1;
end
if exist('pixelspacing', 'var')~=1
    pixelspacing=[1 1];
end
if length(pixelspacing)==1
    pixelspacing(2) = pixelspacing(1); 
end
    




image = padarray(image, [marginewidth marginewidth], 'replicate');
fftshiftdummy=image*0;
fftshiftdummy(1,1)=1;
[DCIndexRow DCIndexCol] = find(fftshift(fftshiftdummy));

imgfreq=fftshift(fft2(image));
[frequ freqv]=coormatrix(size(image));
frequ=(frequ-DCIndexRow)/size(image,1)/pixelspacing(1);
freqv=(freqv-DCIndexCol)/size(image,2)/pixelspacing(2);

frequo(:,:,3)=frequ+1/pixelspacing(1);
frequo(:,:,2)=frequ;
frequo(:,:,1)=frequ-1/pixelspacing(1);


freqvo(:,:,3)=freqv+1/pixelspacing(2);
freqvo(:,:,2)=freqv;
freqvo(:,:,1)=freqv-1/pixelspacing(2);



if (isempty(ranges)==1)
    for i=1:length(sigma)
       freqcoeff=hessiancoeff(frequo, freqvo, sigma(i));
       tmp=ifft2(ifftshift(imgfreq.* freqcoeff), 'symmetric');
       outputfeature(:, :, i)=tmp(marginewidth+1:end-marginewidth, marginewidth+1:end-marginewidth);
    end
else
    for i=1:length(ranges)
       freqcoeff=fluxcoeff(frequo, freqvo, ranges(i), sigma);
       tmp=ifft2(ifftshift(imgfreq.* freqcoeff), 'symmetric');
       outputfeature(:, :, i)=tmp(marginewidth+1:end-marginewidth, marginewidth+1:end-marginewidth);
    end
end


end



function featurefreq=fluxcoeff(frequo, freqvo, range, sigma)
   
   featurefreq=zeros([size(frequo,1) size(freqvo, 2)]);
   normalization_counter=0;
   for or=1:3
       for oc=1:3
           normalization_counter=normalization_counter+1;
           frequ=frequo(:,:,or);
           freqv=freqvo(:,:,oc);
           radialDistance=frequ.^2+freqv.^2;
           twoPiScaleR = 2*pi*range*sqrt(radialDistance) + 1e-10;
           
           featurefreq=featurefreq+......
                       4*pi *sqrt(radialDistance).* ......     *(radialDistance)          
                       exp((-radialDistance).*sigma.*sigma.*2.*pi.*pi).* ...........
                       besselj(1, twoPiScaleR);
       end  
   end
   %featurefreq=featurefreq;
end



function featurefreq=hessiancoeff(frequo, freqvo, sigma)
   
   featurefreq=zeros([size(frequo,1) size(freqvo, 2)]);
   normalization_counter=0;
   for or=1:3
       for oc=1:3
           normalization_counter=normalization_counter+1;
           frequ=frequo(:,:,or);
           freqv=freqvo(:,:,oc);
           radialDistance=frequ.^2+freqv.^2;

           featurefreq=featurefreq+......
                       4*pi* radialDistance.*......     *(radialDistance)          
                       exp((-radialDistance).*sigma.*sigma.*2.*pi.*pi);
       end  
   end
   %featurefreq=featurefreq;
end