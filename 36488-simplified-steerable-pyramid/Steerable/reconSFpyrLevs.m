function out = reconSFpyrLevs(coeff,log_rad,Xrcos,Yrcos,angle,nbands)
% Recursive function for constructing levels of a steerable pyramid.
% This is called by buildSFpyr, and is not usually called directly.
% Input
%   Signal
%         coeff:    steerable pyramid
%   Filter:
%       log_rad:    radius base
%         angle:    angle base
%  Xrcos, Yrcos:    1D profile
%
%            ht:    height of the pyramid
%        nbands:    number of orientations
%
% Output:
%           out:    output image

if (length(coeff)==1)
% Only lowpass left
    out = fftshift(fft2(coeff{1}));
    
else
    
    % shift origin of lut by 1 octave, VERY IMPORTANT, subsampling.
    Xrcos = Xrcos - log2(2);  
    
    %========================== Orientation residue==============================
    himask = pointOp(log_rad, Yrcos, Xrcos); % bandpass filter
    
    % Orientation filters
    lutsize = 1024;
    Xcosn = pi*[-(2*lutsize+1):(lutsize+1)]/lutsize;  % [-2*pi:pi]
    order = nbands-1;
    % divide by sqrt(sum_(n=0)^(N-1)  cos(pi*n/N)^(2(N-1)) )
    const = (2^(2*order))*(factorial(order)^2)/(nbands*factorial(2*order));
    Ycosn = sqrt(const) * (cos(Xcosn)).^order;

    orientdft=zeros(size(coeff{1}{1}));
    
    for b = 1:nbands
        anglemask = pointOp(angle,Ycosn,Xcosn+pi*(b-1)/nbands);
        banddft = fftshift(fft2(coeff{1}{b}));
        orientdft = orientdft + (sqrt(-1))^(nbands-1) * banddft.*anglemask.*himask;
    end
  
  
    %==============Lowpass component are upsampled and convoluted ===========
    dims = size(coeff{1}{1});
    lostart = ceil((dims+0.5)/2)-ceil((ceil((dims-0.5)/2)+0.5)/2)+1;
    loend = lostart+ceil((dims-0.5)/2)-1;
    
    nlog_rad = log_rad(lostart(1):loend(1),lostart(2):loend(2));
    nangle = angle(lostart(1):loend(1),lostart(2):loend(2));
    YIrcos = sqrt(abs(1.0 - Yrcos.^2));
    lomask = pointOp(nlog_rad, YIrcos, Xrcos);
    
    nresdft = reconSFpyrLevs( coeff(2:length(coeff)),nlog_rad, Xrcos, Yrcos, nangle, nbands);
      
    resdft = zeros(dims);
    %upsample, shrink the frequency content by 2
    resdft(lostart(1):loend(1),lostart(2):loend(2)) = nresdft .* lomask; 
    
    out=orientdft+resdft;
end



