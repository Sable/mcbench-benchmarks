% Original code: Eero Simoncelli, 5/97.
% Modified by Javier Portilla to generate complex bands in 9/97.

function coeff = buildSCFpyrLevs(lodft,log_rad,Xrcos,Yrcos,angle,ht,nbands)

if (ht <= 1)
    lo0 = ifft2(ifftshift(lodft));
    coeff={real(lo0)};
else
    
    % shift origin of lut by 1 octave, VERY IMPORTANT, subsampling
    Xrcos = Xrcos - log2(2); 

    % ================= Orientation bandpasses =========================
    lutsize = 1024;
    Xcosn = pi*[-(2*lutsize+1):(lutsize+1)]/lutsize;  % [-2*pi:pi]
    order = nbands-1;
    % divide by sqrt(sum_(n=0)^(N-1)  cos(pi*n/N)^(2(N-1)) )
    % Thanks to Patrick Teo for writing this out :)
    const = (2^(2*order))*(factorial(order)^2)/(nbands*factorial(2*order));
    % analityc version: only take one lobe
    alfa=	mod(pi+Xcosn,2*pi)-pi;
    Ycosn = 2*sqrt(const) * (cos(Xcosn).^order) .* (abs(alfa)<pi/2);
    himask = pointOp(log_rad, Yrcos, Xrcos);

    orients=cell(1,nbands);
    for b = 1:nbands
        anglemask = pointOp(angle, Ycosn, Xcosn+pi*(b-1)/nbands);
        banddft = ((-1i)^(nbands-1)) .* lodft .* anglemask .* himask;
        band = ifft2(ifftshift(banddft));
        orients{b}=band;
    end

    % =================== Lowpass is subsampled ========================
    
    %Get the center part of freq domain
    dims = size(lodft);
    lostart = ceil((dims+0.5)/2)-ceil((ceil((dims-0.5)/2)+0.5)/2)+1;
    loend = lostart+ceil((dims-0.5)/2)-1;

    log_rad = log_rad(lostart(1):loend(1),lostart(2):loend(2));
    angle = angle(lostart(1):loend(1),lostart(2):loend(2));
    lodft = lodft(lostart(1):loend(1),lostart(2):loend(2));
    YIrcos = abs(sqrt(1.0 - Yrcos.^2));
    lomask = pointOp(log_rad, YIrcos, Xrcos);

    lodft = lomask .* lodft;

    temp = buildSCFpyrLevs(lodft, log_rad, Xrcos, Yrcos, angle, ht-1, nbands);
  
    % ================ Put together in cell =============================
    coeff=[{orients} temp];
end

