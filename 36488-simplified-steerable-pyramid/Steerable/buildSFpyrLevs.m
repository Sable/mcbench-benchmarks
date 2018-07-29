function coeff = buildSFpyrLevs(lodft,log_rad,angle,Xrcos,Yrcos,ht,nbands)
% Recursive function for constructing levels of a steerable pyramid.
% This is called by buildSFpyr, and is not usually called directly.
% Input
%
%   Signal
%       lodft:      image in frequency domain
%   Filter:
%       log_rad:    radius base
%         angle:    angle base
%  Xrcos, Yrcos:    1D profile
%
%            ht:    height of the pyramid
%        nbands:    number of orientations
%
% Output:
%         coeff:    steerable pyramid

if (ht <= 1) 
% Only lowpass left
    lo0 = ifft2(ifftshift(lodft));
    coeff ={real(lo0)};

else
    
    % shift origin of lut by 1 octave,VERY IMPORTANT, subsampling.
    Xrcos = Xrcos - log2(2);  
    
    % ================= Orientation bandpasses ==========================
    himask = pointOp(log_rad, Yrcos, Xrcos); % bandpass filter
    % Orientation filters
    lutsize = 1024;
    Xcosn = pi*[-(2*lutsize+1):(lutsize+1)]/lutsize;  % [-2*pi:pi]
    order = nbands-1;
    % divide by sqrt(sum_(n=0)^(N-1)  cos(pi*n/N)^(2(N-1)) )
    const = (2^(2*order))*(factorial(order)^2)/(nbands*factorial(2*order));
    Ycosn = sqrt(const) * (cos(Xcosn)).^order;

    orients=cell(1,nbands);
    
    for b = 1:nbands
        anglemask = pointOp(angle, Ycosn, Xcosn+pi*(b-1)/nbands);
        banddft = ((-sqrt(-1))^order) .* lodft .* anglemask .* himask;
        band = ifft2(ifftshift(banddft));
        orients{b} = real(band);
    end

    % ================ Lowpass is subsampled =============================
    dims = size(lodft);
    
    lostart = ceil((dims+0.5)/2)-ceil((ceil((dims-0.5)/2)+0.5)/2)+1;
    loend = lostart+ceil((dims-0.5)/2)-1;
    
    % Downsample: frequency content expand by 2
    log_rad = log_rad(lostart(1):loend(1),lostart(2):loend(2));
    angle = angle(lostart(1):loend(1),lostart(2):loend(2));
    lodft = lodft(lostart(1):loend(1),lostart(2):loend(2));
    YIrcos = abs(sqrt(1.0 - Yrcos.^2));
    lomask = pointOp(log_rad, YIrcos, Xrcos);

    lodft = lomask .* lodft;

    temp = buildSFpyrLevs(lodft, log_rad, angle, Xrcos, Yrcos, ht-1, nbands);

    % ============== Put together in cell ==============================
    coeff=[{orients} temp];
end

