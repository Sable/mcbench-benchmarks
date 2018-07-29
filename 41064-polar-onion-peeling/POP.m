function s=POP(im, bParams, cartImage)
% Apply polar onion peeling method for analyzing VMI images. The code
% implements the method shown at G.M. Roberts et-al Rev. Sci. Instr. 80, 053104 (2009)
% The code is limited to images no larger than 1024x1024 pixels, and uses arbitrary (even) beta parameters
%
% Inputs:
%   im        - a Velocity map image, the image is assumed to be square matrix,
%               centered and corrected for elliptisity, tilt, etc.
%   bParams   - a vector which each beta paramter to fit for (excluding 0
%               which is always included), e.g. [2 4] for beta2 & beta4
%   cartImage - the kind of cartesian image to return, acceptable value are
%               'sim' for the simulated (fit) image
%               'exp' for the experimental image
%               0    for no cartesian image (this speeds up run time)
%
% Outputs:
%   s             -   A Matlab structure that contains the following:
%   s.iraraw      - a 2d triagular array (polar) of the raw data folded to (0,pi/2) - G(R,alpha)
%   s.iradecon    - a 2d triagular array (polar) of the simulated deconvolved data folded to (0,pi/2) - g_fit(r;R,alpha)
%   s.iradeconExp - a 2d triagular array (polar) of the experimental deconvolved data folded to (0,pi/2) - g_fit(r;R,alpha)
%   s.PESId       - a 1d vector of the radial projection of the (simulated) deconvolved data
%   s.PESIdExp    - a 1d vector of the radial projection of the (experimental) deconvolved data
%   s.Betas       -  a matrix containing each beta parameters (as specified in
%                    bParams, e.g. if bParams=[2 4] then s.Betas(1,:) gives b2 and s.Betas(2,:) gives b4
%
% And depending on the option selected for cartImage:
%    s.simImage -  a 2d reconstruction after the onion peeling in cartesian
%                  coordinates of the simulated image
%    s.expImage -  a 2d reconstruction after the onion peeling in cartesian
%                  coordinates of the experimental image
%
%   Example:
%       load('testimg.mat');
%       s=POP(im,[2 4], 'sim');
%       figure;
%       subplot(1,2,1);imagesc(im); axis square
%       subplot(1,2,2);image(s.simImage); axis square
%       figure;
%       subplot(2,2,1);imagesc(im);
%       subplot(2,2,2);imagesc(s.iraraw);
%       subplot(2,2,3);imagesc(s.iradecon);
%       subplot(2,2,4); plot(s.PEDSIdExp)
%
%   Comments \ improvements are welcomed
%   Natan (nate2718281828@gmail.com)
%   Adam  (a.s.chatterley@dur.ac.uk)

%% defaults
if (nargin < 3);                 cartImage = 0; end ;
if (nargin < 2);  bParams=[2 4]; cartImage = 0; end ;

%% Check that beta Params are in the scope of the code
for i=bParams
    if (mod(i, 2) ~= 0 || i <= 0 || i > 24)
        error('Only even positive beta parameters <=24 supported!');
    end
end

%% inital steps
x0=size(im,1)/2;y0=size(im,2)/2; % Assuming image is centered
load('delta_lut.mat');  % loads lut - impulse response basis set  (delta functions)
RR=(0:size(im)/2);
PPR=single(floor(0.5*pi*(RR+1))-1); % calc the  # of pixels per radius
AngleInc = single(0.5*pi./PPR'); % angle incremet per radius
AngleInc(1)=0; % avoid inf at origin

l = min([x0,y0,(size(im) - [x0,y0])]);  %set radius of square matrix around center

a4 = im(x0:x0+l-1,y0:y0+l-1) + im(x0:-1:x0-l+1,y0:y0+l-1) + ...
    im(x0:x0+l-1,y0:-1:y0-l+1) + im(x0:-1:x0-l+1,y0:-1:y0-l+1); % fold image to a quadrant


ira = zeros(l-2,PPR(l));  % initialize the  matrix
ira(1,1) = a4(1,1);       % origin pixel remains the same unlike polar pixels
PESR = zeros(l-2,PPR(l)); % initialize the reconstracted matrix
PESR(1,1) = a4(1,1);

%% creating the 2d triagular array polar image
for rp=2:l-2
    nainc=PPR(rp); % determine # polar pix in radius
    ainc=AngleInc(rp);    % the angular incremet per radius
    qp=0:nainc;
    xp=rp*sin(ainc*qp)+1;  % polar x-coordinate
    yp=rp*cos(ainc*qp)+1;  % polar y-coordinate
    xc=round(xp);yc=round(yp); % define scale fractional weight of cart pixels in polar pixels
    xd=1-abs(xc-xp);
    yd=1-abs(yc-yp);
    ira(rp,1:nainc+1) = xd.*yd.*a4(xc+(yc-1)*l); % ira = intensity per radius per angle
    ira(rp,2:nainc) = ira(rp,2:nainc) + ...
        xd(2:nainc).*(1-yd(2:nainc)).*a4(xc(2:nainc)+(yc(2:nainc)-1+(-1).^(yp(2:nainc)<yc(2:nainc)))*l) + ...
        (1-xd(2:nainc)).*yd(2:nainc).*a4(xc(2:nainc)+(-1).^(xp(2:nainc)<xc(2:nainc))+yc(2:nainc)*l) + ...
        (1-xd(2:nainc)).*(1-yd(2:nainc)).*a4(xc(2:nainc)+(-1).^(xp(2:nainc)<xc(2:nainc))+l*(yc(2:nainc)+(-1).^(yp(2:nainc)<yc(2:nainc))));
    
    PESR(rp,1:nainc+1) = rp - 1 + ira(rp,1:nainc+1);
end

iraraw = ira; % save to compare later onion peeling

%initialize some more  parameters
betas = zeros(length(bParams),l-2);
PESId = zeros(1,l-2);
iradecon = zeros(l-2,PPR(l));
iradeconExp = zeros(l-2,PPR(l));
PESIdExp = zeros(1,l-2);

%% Onion peel:
for rp = l-2:-1:2
    B = zeros(1,numel(bParams+1));
    nainc=PPR(rp); % # of polar pixles in radius -1
    qp=0:nainc;
    y = ira(rp,qp+1); % assign row of all pixles in radius rp
    
    B(1)=sum(y);
    
    fitCoefs = ones(numel(bParams + 1), PPR(rp)+1); % one fit coefficient for each B param
    for i=(1:numel(bParams))
        fitCoefs(i+1,:) = leg(bParams(i), cos(AngleInc(rp)*qp)); % assign relevenat legendre polinomials to fitCoef
        B(i+1) = y*fitCoefs(i+1,:)'; % fill B matrix
    end
    
    A = fitCoefs * fitCoefs'; % matrix A for least square fitting
    A(1,1)=nainc+1;
    Ain = inv(A);
    
    Beta = zeros(1,length(bParams+1));
    Beta(1)=B*Ain(:,1);
    for i=(1:length(bParams))
        Beta(i+1)=B*Ain(:,i+1)/Beta(1); % generate beta matrix
    end
    
    for i=(1:length(bParams))
        betas(i,rp) = Beta(i+1); % copy for output betas
    end
    
    if 0==Beta(1)
        PESId(rp)=0;
        continue;
    end
    
    % generate matrices for alpha; R/rp * cos(alpha); and the basis set scaled by pixels per radius
    alphaMat = (AngleInc(1:rp) * (0:PPR(rp)));
    rrpCosAlphaMat = repmat((1:rp)'/rp, 1, PPR(rp)+1).*cos(alphaMat);
    itMat = repmat((lut(rp,1:rp)*(nainc+1)./ (PPR(1:rp)+1))', 1, PPR(rp)+1);
    
    bContrib = ones(rp, PPR(rp)+1);
    for i=(1:length(bParams))
        bContrib = bContrib + Beta(i+1)*leg(bParams(i), rrpCosAlphaMat); % add each beta contribution
    end
    
    factMat = Beta(1).*itMat.*bContrib; % generate the simulated image for this radius
    
    PESId(rp) = PESId(rp) + sqrt(rp)*factMat(end,:)*sin(alphaMat(end,:))'; % save the simulated data
    iradecon(rp,1:PPR(rp)+1)=factMat(end,1:PPR(rp)+1)/sqrt(rp);
    
    PESIdExp(rp) = PESId(rp) + sqrt(rp)*ira(rp,1:PPR(rp)+1)*sin(alphaMat(end,:))'; % save the experimentala data
    iradeconExp(rp,1:PPR(rp)+1)=ira(rp,1:PPR(rp)+1)/sqrt(rp);
    
    ira(1:rp,1:PPR(rp)+1) = ira(1:rp,1:PPR(rp)+1)-factMat; % subtract away the simulated image
end

%% 2d transform to cartesian coordinates of the simulated\experimental image

if strcmp(cartImage, 'sim')
    
    x = [];
    y = [];
    z = [];
    for rp = 1:l-10
        qp = 0:PPR(rp);
        x = [x rp*cos(qp*AngleInc(rp))];
        y = [y rp*sin(qp*AngleInc(rp))];
        z = [z iradecon(rp,qp+1)];
    end
    
    %F = TriScatteredInterp(double(x'),double(y'),double(z'),'natural'); 
    % previous version TriScatteredInterp will not be supported in future matlab releases
    F = scatteredInterpolant(double(x(:)),double(y(:)),double(z(:)),'natural');
    
    [xx,yy] = meshgrid(0:l-2,0:l-2);
    zz = F(xx,yy);
    zz = max(zz,zeros(size(zz)));
    zz = [zz(end:-1:1,end:-1:1) zz(end:-1:1,:); zz(:,end:-1:1) zz];
    
    s=struct('iraraw',iraraw,'iradecon',iradecon, 'iradeconExp', iradeconExp, 'PESId',PESId,'PESIdExp',PESIdExp,'Betas',betas,'simImage',zz);
    return
    
elseif (strcmp(cartImage,'exp'))
    x = [];
    y = [];
    z = [];
    for rp = 1:l-10
        qp = 0:PPR(rp);
        x = [x rp*cos(qp*AngleInc(rp))];
        y = [y rp*sin(qp*AngleInc(rp))];
        z = [z iradeconExp(rp,qp+1)];
    end
    
    %  F = TriScatteredInterp(double(x'),double(y'),double(z'),'natural');
    % previous version TriScatteredInterp will not be supported in future matlab releases
    F = scatteredInterpolant(double(x(:)),double(y(:)),double(z(:)),'natural');
    
    [xx,yy] = meshgrid(0:l-2,0:l-2);
    zz = F(xx,yy);
    zz = max(zz,zeros(size(zz)));
    zz = [zz(end:-1:1,end:-1:1) zz(end:-1:1,:); zz(:,end:-1:1) zz];
    
    s=struct('iraraw',iraraw,'iradecon',iradecon, 'iradeconExp', iradeconExp, 'PESId',PESId,'PESIdExp',PESIdExp,'Betas',betas,'expImage',zz);
    return
end
s=struct('iraraw',iraraw,'iradecon',iradecon,'iradeconExp', iradeconExp, 'PESId',PESId,'PESIdExp',PESIdExp, 'Betas',betas);


function p=leg(m,x)
%  This function returns Legendre polynomial P_m(x) where m is the degree
%  of polynomial and X is the variable.
%  The x2=x.*x ... is a perforance optimization that minimizes the # of operations.
switch m
    case 0
        p=ones(size(x));
        return
    case 1
        p=x;
        return
    case 2
        p=(3*x.*x -1)/2;
        return
    case 4
        % p=(35 *(( x ).^2).^2 - 30 * x .^2 + 3)/8;
        x2=x.*x;
        p = ((35.*x2-30).*x2+3)/8;
        return
    case 6
        %p=(231 *( x.*x.*x).^2 - 315 * ((x).^2).^2 + 105 * x .^2 -5)/16;
        x2=x.*x;
        p = (((231.*x2-315).*x2+105).*x2-5)/16;
        return
    case 8
        % p=(6435 * x .^2.^2.^2 -12012 *( x .* x .* x ).^2 + 6930 *  x .^2.^2 -1260 *  x .^2 +35)/128;
        x2=x.*x;
        p = ((((6435.*x2-12012).*x2+6930).*x2-1260).*x2+35)/128;
        return
    case 10
        x2=x.*x;
        p = (((((46189.*x2-109395).*x2+90090).*x2-30030).*x2+3465).*x2-63)/256;
        %p=(46189 * x .^10 - 109395 * x .^8 +90090 * x .^6 -30030 *  x .^4 +3465 *  x .^2 -63)/256;
        return
    case 12
        x2=x.*x;
        p = ((((((676039.*x2-1939938).*x2+2078505).*x2-1021020).*x2+225225).*x2-18018).*x2+231)/1024;
        %p=(676039 * x .^12 -1939938 * x .^10 +2078505 * x .^8 -1021020 * x .^6 +225225 *  x .^4 -18018 *  x .^2 +231)/1024;
        return
    case 14
        x2=x.*x;
        p = (((((((5014575.*x2-16900975).*x2+22309287).*x2-14549535).*x2+4849845).*x2-765765).*x2+45045).*x2-429)/2048;
        %p=(5014575*x.^14-16900975*x.^12+22309287*x.^10-14549535*x.^8+4849845*x.^6-765765*x.^4+45045*x.^2-429)/2048 ;
        return
    case 16
        x2=x.*x;
        p = ((((((((300540195.*x2-1163381400).*x2+1825305300).*x2-1487285800).*x2+669278610).*x2-162954792).*x2+19399380).*x2-875160).*x2+6435)/32768;
        %p=(300540195 *x.^16-1163381400 *x.^14+1825305300 *x.^12-1487285800 *x.^10+669278610 *x.^8-162954792 *x.^6+19399380 *x.^4-875160 *x.^2+6435)/32768;
        return
    case 18
        x2=x.*x;
        p = (((((((((2268783825.*x2-9917826435).*x2+18032411700).*x2-17644617900).*x2+10039179150).*x2-3346393050).*x2+624660036).*x2-58198140).*x2+2078505).*x2-12155)/65536;
        %p= (2268783825 *x.^18-9917826435 *x.^16+18032411700 *x.^14-17644617900 *x.^12+10039179150 *x.^10-3346393050 *x.^8+624660036 *x.^6-58198140 *x.^4+2078505 *x.^2-12155)/65536;
        return
    case 20
        x2=x.*x;
        p = ((((((((((34461632205.*x2-167890003050).*x2+347123925225).*x2-396713057400).*x2+273491577450).*x2-116454478140).*x2+30117537450).*x2-4461857400).*x2+334639305).*x2-9699690).*x2+46189)/262144;
        %p=(34461632205 *x.^20-167890003050 *x.^18+347123925225 *x.^16-396713057400 *x.^14+273491577450 *x.^12-116454478140 *x.^10+30117537450 *x.^8-4461857400 *x.^6+334639305 *x.^4-9699690 *x.^2+46189)/262144;
        return
    case 22
        x2=x.*x;
        p = (((((((((((263012370465.*x2-1412926920405).*x2+3273855059475).*x2-4281195077775).*x2+3471239252250).*x2-1805044411170).*x2+601681470390).*x2-124772655150).*x2+15058768725).*x2-929553625).*x2+22309287).*x2-88179)/524288;
        %p=(263012370465 *x.^22-1412926920405 *x.^20+3273855059475 *x.^18-4281195077775 *x.^16+3471239252250 *x.^14-1805044411170 *x.^12+601681470390 *x.^10-124772655150 *x.^8+15058768725 *x.^6-929553625 *x.^4+22309287 *x.^2-88179)/524288;
        return
    case 24
        x2=x.*x;
        p = ((((((((((((8061900920775.*x2-47342226683700).*x2+121511715154830).*x2-178970743251300).*x2+166966608033225).*x2-102748681866600).*x2+42117702927300).*x2-11345993441640).*x2+1933976154825).*x2-194090796900).*x2+10039179150).*x2-202811700).*x2+676039)/4194304;
        %p=(8061900920775 *x.^24-47342226683700 *x.^22+121511715154830 *x.^20-178970743251300 *x.^18+166966608033225 *x.^16-102748681866600 *x.^14+42117702927300 *x.^12-11345993441640 *x.^10+1933976154825 *x.^8-194090796900 *x.^6+10039179150 *x.^4-202811700 *x.^2+676039)/4194304;
        return
end

