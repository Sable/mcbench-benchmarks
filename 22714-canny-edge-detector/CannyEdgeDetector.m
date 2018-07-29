function varargout = CannyEdgeDetector(varargin)
% CannyEdgeDetector Detects edges in the intensity image.
%     imo = CannyEdgeDetector(imi) takes the intensity image imi as input
%     and returns a binary image imo with the same size as imi, where 1's
%     are the edge pixels detected by Canny's method (default). The default
%     value for the thresholds are specified as
%     0.3*max(GradientMagnitudeImage), 0.1*max(GradientMagnitudeImage) and
%     1 for high and low thresholds and sigma for Gaussian kernel,
%     respectively. There are also some additional features listed as
%     below:
%     
%     imo = CannyEdgeDetector(imi,method) takes an additional string 
%     'method' as input which specifies the function to detect the edges 
%     whether using Canny's method, or Laplacian of Gaussian. The possible 
%     valid entries for method input are 'canny' and 'log'. The default 
%     threshold value for log method is automatically chosen by 'edge' 
%     function, which is present in "Image Processing Toolbox".
%     
%     imo = CannyEdgeDetector(imi,sigma) returns the same output as 
%     described at the top, only with the specified sigma value for
%     Gaussian kernel in stead of the default value. The default value for
%     method is 'canny'.
%     
%     imo = CannyEdgeDetector(imi,sigma,method) returns the edge detected 
%     binary image imo, with the specified sigma value and the specified 
%     method, in stead of the defaults.
%     
%     imo = CannyEdgeDetector(...,Th) returns the same output as described
%     above, with an additional input to specify the threshold for 'log'
%     method, or the high threshold for 'canny'. In the second case, the
%     low threshold is 1/3 of Th by default.
%         
%     imo = CannyEdgeDetector(...,Th,Tl) takes an additional input Tl,
%     which specifies the low threshold in case of Canny's method. When the
%     method input is 'log', this usage is invalid and the function will
%     return an error message.
%     
%     imo = CannyEdgeDetector(...,Th,Tl,feature) In the case of Canny's
%     method, there are two distinct ways to apply hysteresis thresholding
%     defined. The first one is a recursive search (namely, depth first
%     search), and the second one is to use some morphological operations.
%     Obviously, the recursive method takes longer to operate. The string
%     input 'feature' specifies which one to use. Valid options for this
%     input are 'dfs' and 'morph'. It is defined as 'dfs' by default. In
%     the case of log method, this usage is invalid and will return an
%     error message.
% 
%     CannyEdgeDetector(...) usage (without the output arguments) plots the
%     binary image using imshow, in stead of making any assignments.
%     
%     Author: Halim Can ALBASAN
%     
%     Written for the term project of the course "Robot Vision" (EE701)
%     given in Middle East Technical University, Ankara, Turkey; by the 
%     lecturer A. Aydin Alatan.
%     
%     Date: 15/06/2008 


[imi,sigma,method,Th,Tl,feature] = parse_inputs (varargin{:});

switch method
    case 'canny'
        
%% Detection of Gaussian kernel size ( 3 <= N <= 15 )

G = gaussmf (-10:10,[sigma 0]);
ind = find (G<=.1);
if length(ind)<=6
    N = 15;                             % Upper boundary
    warning('MATLAB:LargeSigma','Sigma too large!')
    
elseif length(ind)>=18
    N = 3;                              % Lower boundary
    warning('MATLAB:SmallSigma','Sigma too small!')
else
    G(ind) = [];
    N = length (G);
end

%% Gaussian kernel and its first derivatives ( horizontal (Gh) and vertical
%% (Gv) )

G = fspecial ('gaussian', [N N], sigma);
[Gh,Gv] = gradient(G);

%% Applying the operators to the image and obtaining the gradient
%% magnitudes and directions

imx = conv2(double(imi),Gh);
imx = imx ((N-1)/2+1:size(imx,1)-(N-1)/2,(N-1)/2+1:size(imx,2)-(N-1)/2);
imy = conv2(double(imi),Gv);
imy = imy ((N-1)/2+1:size(imy,1)-(N-1)/2,(N-1)/2+1:size(imy,2)-(N-1)/2);

gra_mag = sqrt(imx.^2+imy.^2);
gra_dir = atan2(imy,imx);

%% Gradient direction discretization

[r c] = size (gra_dir);

for i=1:r
    for j=1:c
        if ( gra_dir(i,j)<pi/8 && gra_dir(i,j)>=0 ) ...
                || ( gra_dir(i,j)<=2*pi && gra_dir(i,j)>=15*pi/8 ) ...
                || ( gra_dir(i,j)<9*pi/8 && gra_dir(i,j)>=7*pi/8 )
            gra_dir(i,j) = 0;
        elseif ( gra_dir(i,j)>=pi/8 && gra_dir(i,j)<3*pi/8 ) ...
                || ( gra_dir(i,j)>=9*pi/8 && gra_dir(i,j)<11*pi/8 )
            gra_dir(i,j) = 45;
        elseif ( gra_dir(i,j)>=3*pi/8 && gra_dir(i,j)<5*pi/8 ) ...
                || ( gra_dir(i,j)>=11*pi/8 && gra_dir(i,j)<13*pi/8)
            gra_dir(i,j) = 90;
        else
            gra_dir(i,j) = 135;
        end
    end
end

%% Nonmaxima suppression

gra_mag_s = gra_mag;
gra_mag_s(1,:) = zeros (1,c);
gra_mag_s(r,:) = zeros (1,c);
gra_mag_s(:,1) = zeros (r,1);
gra_mag_s(:,c) = zeros (r,1);             % Suppress boundaries first

for i=2:r-1
    for j=2:c-1
        if gra_dir(i,j)==0
            if ( gra_mag(i,j)<=gra_mag(i,j+1) ) ...
                    || ( gra_mag(i,j)<=gra_mag(i,j-1) )
                gra_mag_s(i,j) = 0;
            end
        elseif gra_dir(i,j)==45
            if ( gra_mag(i,j)<=gra_mag(i-1,j+1) ) ...
                    || ( gra_mag(i,j)<=gra_mag(i+1,j-1) )
                gra_mag_s(i,j) = 0;
            end
        elseif gra_dir(i,j)==90
            if ( gra_mag(i,j)<=gra_mag(i+1,j) ) ...
                    || ( gra_mag(i,j)<=gra_mag(i-1,j) )
                gra_mag_s(i,j) = 0;
            end
        else
            if ( gra_mag(i,j)<=gra_mag(i+1,j+1) ) ...
                    || ( gra_mag(i,j)<=gra_mag(i-1,j-1) )
                gra_mag_s(i,j) = 0;
            end
        end
    end
end

%% Hysteresis thresholding and forming the output image

if isempty(Th)
    Tl = .10*max(max(gra_mag_s));
    Th = .30*max(max(gra_mag_s));
end

h_thr_im = gra_mag_s;
h_thr_im(gra_mag_s<Th) = 0;

l_thr_im = gra_mag_s;
l_thr_im(gra_mag_s<Tl) = 0;

        switch feature
            case 'morph'
            
h_thr_im = logical(h_thr_im);
l_thr_im = logical(l_thr_im);

[ii jj] = find(h_thr_im);

imo = bwselect(l_thr_im , jj , ii , 8);
imo = bwmorph(imo , 'thin' , 1);

            case 'dfs'
                
for i=2:r-1
    for j=2:c-1
        if h_thr_im (i,j)>0
            h_thr_im = edge_follow(h_thr_im,l_thr_im,i,j);
        end
    end
end

imo = logical(h_thr_im);

        end
        
    case 'log'
        
imo = edge(imi,method,Th,sigma);

end

if nargout<1
    imshow(imo)
else
    varargout{1} = imo;
end


function thr_h = edge_follow(thr_h,thr_l,i,j)
    
    x = [-1  0  1 -1 1 -1 0 1];               % Relative coordinates of 8 neighbors
    y = [-1 -1 -1  0 0  1 1 1];
    
    
    for k=1:8
        if thr_h(i+x(k),j+y(k))==0 && thr_l(i+x(k),j+y(k))~=0
            thr_h(i+x(k),j+y(k)) = -thr_l(i+x(k),j+y(k));
            thr_h = edge_follow(thr_h,thr_l,i+x(k),j+y(k));
        end
    end

end

function [imi,sigma,method,Th,Tl,feature] = parse_inputs(varargin)
   
    imi = varargin{1};
    sigma = 1;                  % defaults
    method = 'canny';
    Th = [];                    % the defaults for the thresholds will be 
    Tl = [];                    % specified after the gradient magnitude is 
    feature = 'dfs';            % calculated.
    
    methods = {'canny','log'};
    features = {'dfs','morph'};
    sigma_default = false;
    
    if nargin<1
        error('Not enough input arguments.')
    end
    
    if nargin>=2
        
        if ischar(varargin{2})
            if length(strmatch(varargin{2},methods))~=1
                error('Wrong input for edge detection method')
            else
                method=varargin{2};
                sigma_default = true;
            end
            
        else
            sigma=varargin{2};
        end
    end
        
    if nargin>=3
        
        if sigma_default
            Th = varargin{3};
            Tl = Th/3;
        else
            if length(strmatch(varargin{3},methods))~=1
                error('Wrong input for edge detection method')
            else
                method=varargin{3};
            end
        end
    end
    
    if nargin>=4
        
        if sigma_default
            if strcmp(method,'canny')
                Tl = varargin{4};
            else
                error('Wrong sequence or number of inputs for "log" method')
            end
        else
            Th = varargin{4};
        end
    end
    
    if nargin>=5
        if strcmp(method,'log')
            error('Too many input arguments!')
        else
            if sigma_default
                if ischar(varargin{5})
                    if length(strmatch(varargin{5},features))~=1
                        error('Wrong input for hysteresis thresholding method')
                    else
                        feature = varargin{5};
                    end
                else
                    error('Wrong usage of input argument "feature"!')
                end
            else
                Tl = varargin{5};
            end
        end
    end
    
    if nargin>=6
        if sigma_default
            error('Too many input arguments!')
        else
            if ischar(varargin{6})
                if length(strmatch(varargin{6},features))~=1
                    error('Wrong input for hysteresis thresholding method')
                else
                    feature = varargin{5};
                end
            else
                error('Wrong usage of input argument "feature"!')
            end
        end
    end
    
    if nargin>6
        error('Too many input arguments')
    end
end

end