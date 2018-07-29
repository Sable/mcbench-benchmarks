
% =======================================================================
%     Improved adaptive complex diffusion despeckling filter (NCDF)
% =======================================================================
% DESCRIPTION: Filters out speckle noise from a noisy image
%
% INPUTS:
%        imgIn - noisy image
%        TMAX  - diffusion time
%
%
%
% OUTPUTS:
%        imgOut - filtered image
%        nIter  - number of iterations made by the process
%        dTT    - vector with the step in time for each iteration
%
% _________________________________________________________________________
% REFERENCES:
% [1] Rui Bernardes, Cristina Maduro, Pedro Serranho, Adérito Araújo,
%     Sílvia Barbeiro, and José Cunha-Vaz,
%     "Improved adaptive complex diffusion despeckling filter,"
%     Opt. Express 18, 24048-24059 (2010).
% 
% Work developed under the research project supported by Fundação para a
% Ciência e a Tecnologia (FCT): PTDC/SAU-BEB/103151/2008 and program 
% COMPETE (FCOMP-01-0124-FEDER-010930)
%
% http://www.opticsinfobase.org/oe/abstract.cfm?URI=oe-18-23-24048
% http://www.aibili.pt
%
%
% DEPENDENCIES:
% needs the matlab image processing toolbox
% _________________________________________________________________________
% Example of usage:
%
% Img_noisy    = imread('img.jpg');
% TMAX         = 0.75; % diffusion time in seconds
%
% % Aply filter
% [Img_filtered, nIter, dTT] = twodncdf(Img_noisy, TMAX);
%
% imshow(Img_noisy),    title('original image');
% imshow(Img_filtered), title('filtered image');
%
%
% 
% AIBILI - Association for Innovation and Biomedical Research on Light and
% Image
%
%
%
%
% MODIFICATION HISTORY:
%   March    2010 -     creation:   R. Bernardes
%   November 2010 - modification:   C. Maduro
%   April    2012 - modification:   P. Rodrigues
%

function [imgOut, nIter, dTT] = twodncdf(imgIn, TMAX)

% diffusion time (default)
if nargin < 2 ; 
    TMAX  = 3.0 ; 
end 

% process constants (eq. 6 [Bernardes 2010])
THETA     = pi/30;    
j         = sqrt(-1);
e_jxtheta = exp(j*THETA);

% process constants (eq. 9 [Bernardes 2010])
KAPPAMIN  =   2.0;
KAPPAMAX  =  28.0;
MAXIMG    = 255;

% g filter (eq. 10 [Bernardes 2010])
fSIZE     = 3;
fSIGMA    = 10;
hFiltD    = fspecial('gaussian', fSIZE, fSIGMA); 


% diffusion filter coefficient
fSIGMA2    = 0.5;
hFilterD  = fspecial('gaussian', fSIZE, fSIGMA2);


lapKernel      = [0 1 0; 1 -4 1; 0 1 0]; % ....... laplacian kernel
gradKernel     = [-1/2 0 +1/2]; % ................ gradiente kernel
[xSize, ySize] = size(imgIn); % .................. signal size

BORDER = 2; % .............. to a null gradient at the image borders 
indexX = 1+BORDER:xSize+BORDER;
indexY = 1+BORDER:ySize+BORDER;


% data conversion and processing
yNCDF = double(imgIn);

% process variables
tIter = 0;
nIter = 0;


while (TMAX - tIter) > eps
    nIter = nIter + 1;
    
    
    % get real/imaginary parts
    ryNCDF = real(yNCDF);
    iyNCDF = imag(yNCDF);
    
    
    %  (eq. 10 [Bernardes 2010])
    localAvg = filter2(hFiltD, ryNCDF, 'same');
    minlocalAvg = min(localAvg(:));
    
    % (eq. 9 [Bernardes 2010])
    k_mod = KAPPAMAX + (KAPPAMIN-KAPPAMAX)* ...
        (localAvg - minlocalAvg) / (max(localAvg(:)) - minlocalAvg);
    
    % (eq. 6 [Bernardes 2010])
    coefDif = e_jxtheta ./ (1 + ( (iyNCDF/THETA) ./ k_mod ).^2);
    coefDif = filter2(hFilterD, coefDif, 'same');
    
    
    % compute laplacian and gradient
    % lap(yNCDF)
    yAux  = zeros(xSize+2*BORDER, ySize+2*BORDER);
    yAux(indexX, indexY) = yNCDF;
    del2Y = conv2(yAux, lapKernel, 'same');
    del2Y = del2Y(indexX, indexY);
    
    % grad(yNCDF)
    dAux  = conv2(yAux, gradKernel, 'same');
    dYx   = dAux(indexX, indexY);
    dAux  = conv2(yAux, gradKernel', 'same');
    dYy   = dAux(indexX, indexY);
    
    % grad(coefDif)
    dDx   = conv2(coefDif, gradKernel, 'same');
    dDy   = conv2(coefDif, gradKernel', 'same');
    
    dIdt  = coefDif.*del2Y + dDx.*dYx + dDy.*dYy;
    
    
    % compute adaptative time step (eq. 11 [Bernardes 2010])
    dT = (1/4)* ...
        ( 0.25 + 0.75*exp(- max(max( abs(real(dIdt)) ./ ryNCDF ))) );
    
    dTT(nIter) = dT;
    
    % update diffusion step in time for next iteration
    if tIter + dT > TMAX ; dT = TMAX - tIter ; end
    
    % update processed diffusion time 
    tIter = tIter + dT;
    
    
    % update yNCDF (eq. 2 [Bernardes 2010])
    yNCDF = yNCDF + dT.*dIdt;
    
end % while (TMAX - tIter) > eps


imgOut = real(yNCDF);

end
