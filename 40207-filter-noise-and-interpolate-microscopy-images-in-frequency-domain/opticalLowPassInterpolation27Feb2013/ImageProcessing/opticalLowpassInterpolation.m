function [out,outscale]=opticalLowpassInterpolation(in,inscale,fcut,IntFac) 
% opticalLowpassInterpolation Filter and interpolate microscopy image while avoiding artifacts.
%
% Images acquired with lenses (microscope, camera) can possess fine
% features only upto the spatial frequency cut-off of the optics. Any fine
% features beyond that are due to noise. A simple and effective noise
% removal strategy is to remove the above-cutoff spatial frequencies.
% 
% opticalLowpassInterpolation implements filtering of the imaging data with
% super-gaussian filter in such a way that filtering artifacts are
% minimized.
% 
% The image can be optionally interpolated in frequency domain while
% maintaining physical variation in intensity.
% 
% USAGE: [out, outpix] =
% opticalLowpassInterpolation(in,inpix,fcut,IntFac)
% 
% OUTPUTS: 
% out - filtered and interpolated output image. 
% outpix - pixel-size in the output image.
%
% INPUTS: 
% in - raw image 
% inpix - pixel-size in the input image (numerical
% value in your chosen units of distance). 
% fcut - spatial-frequency cutoff
% (numerical value in the inverse units of distance). 
% IntFac - Interpolation factor. 
% 
% Author and Copyright: Shalin Mehta (www.mshalin.com)
% License: BSD 
% Version history: April 2012, initial implementation with gaussian filter.
%                  August 2012, use super-gaussian filter.
%                  Feb 10, 2013, added functionality to interpolate in
%                  frequency domain.
%                  Feb 27, 2013, Order of super-gaussian is intelligently estimated from the sampling. 
%                               Resolved bug that caused the center of
%                               intensity to shift (phase-shift in space)
%                               when interpolation is used.
    
    %% Pad the input image to avoid edge artifacts.
    
    padsize=floor(0.5*size(in));
    inpadded=padarray(in,padsize,'replicate','both');
    inpadded=double(inpadded);
 
    %% Obtain the spectrum with DC at center of image.
    spec=fftshift(fft2(ifftshift(inpadded))); 
    %% Pad the spectrum to achieve spatial interpolation.
    specpadsize=floor(0.5*size(spec)*(IntFac-1));
    specpad=padarray(spec,specpadsize,'replicate','both');
   
    
    %% Generate frequency grid for padded spectrum.
    outscale=inscale/IntFac;
    mcut=1/(2*outscale); %Cut-off of frequency grid.
    [ylen, xlen]=size(specpad); % The first return value is the height and the second is the width.
    mx=linspace(-mcut,mcut,xlen);
    my=linspace(-mcut,mcut,ylen);
    mxx=repmat(mx,[ylen 1]);
    myy=repmat(my',[1 xlen]);
    mrr=sqrt(mxx.^2+myy.^2);
    
    %% Estimate the sharpness of supergaussian and generate filter over above grid.
    %
    % Equation of supergaussian is a=exp(-(f/fo)^(1/2n)).
    %
    % I choose the transition of the filter response from 0.99 to 0.01 to
    % be sampled over 5 frequency bins.
    % The filter response is equal to a, when 
    % f/fo =  -Log[a]^(1/2n).
    % 
    % The super-gaussian filter is = 1/e when f=fo. 
    % The transition region normalized by fcut is thus given by,
    % mtrans/fcut = -Log[0.01])^(1/2n) + Log[0.99])^(1/2n).
    % Using Mathematica, above is simplified to
    % mtrans/fcut=E^(0.764/n)-E^(-2.3/n)
    
    % Above value is computed for various integer values of n and tabulated
    % here. To estimate n from given mtrans/fcut, we just find the index
    % where required mtrans/fcut is closest to the entry in the table.
    nrange=1:100;
    mtransbyfoTable=exp(0.764./nrange)-exp(-2.3./nrange);
    
    % Size of frequency step in radial direction.
    dm=sqrt( (mx(2)-mx(1))^2 + (my(2)-my(1))^2 );
    
    % We want transition period to be atleast 3 frequency bins and transition region should start at fcut.
 
    mtrans=3*dm;
    fo=fcut+3*dm;
    
    % transition period normalized by fcut.
    mtransbyfo=mtrans/fcut;
    
    % The suitable order of super-gaussian.
    [~,n]=min(abs(mtransbyfoTable-mtransbyfo));
    
    % Use super-gaussian as our frequency filter.
     FiltFreq=exp(-(mrr/fo).^(2*n));
   
    %% Filter the padded spectrum and obtain interpolated spatial image.
   SpecFilt=specpad.*FiltFreq;
   % Compute filtered, interpolated, zero-padded output.
   outpad=IntFac^2*fftshift(ifft2(ifftshift(SpecFilt),'symmetric'));
   
   % Crop the center of the output image.
   outCenter=floor(0.5*size(outpad)+1);
   outLen=size(in)*IntFac;
   cenlen2idx=@(cen,len) cen-ceil((len-1)/2):cen+floor((len-1)/2);
   idy=cenlen2idx(outCenter(1),outLen(1));
   idx=cenlen2idx(outCenter(2),outLen(2));
   out=outpad(idy,idx);
   out=cast(out,class(in));
   
end
