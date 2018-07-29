function [L,C,U,LUT,H]=FastFCMeans(im,c,q)
% Segment N-dimensional grayscale image into c classes using a memory 
% efficient implementation of the fuzzy c-means (FCM) clustering algorithm. 
% The computational efficiency is achieved by using the histogram of the 
% image intensities during the clustering process instead of the raw image
% data.
%
% INPUT ARGUMENTS:
%   - im  : N-dimensional grayscale image in integer format. 
%   - c   : positive interger greater than 1 specifying the number of
%           clusters. c=2 is the default setting. Alternatively, c can be
%           specified as a k-by-1 array of initial cluster (aka prototype)
%           centroids.
%   - q   : fuzzy weighting exponent. q must be a real number greater than
%           1.1. q=2 is the default setting. Increasing q leads to an
%           increased amount of fuzzification, while reducing q leads to
%           crispier class memberships.
%
% OUTPUT  :
%   - L   : label image of the same size as the input image. For example,
%           L==i represents the region associated with prototype C(i),
%           where i=[1,k] (k = number of clusters).
%   - C   : 1-by-k array of cluster centroids.
%   - U   : L-by-k array of fuzzy class memberships, where k is the number
%           of classes and L is the intensity range of the input image, 
%           such that L=numel(min(im(:)):max(im(:))).
%   - LUT : L-by-1 array that specifies the defuzzified intensity-class 
%           relations, where L is the dynamic intensity range of the input 
%           image. Specifically, LUT(1) corresponds to class assigned to 
%           min(im(:)) and LUT(L) corresponds to the class assigned to
%           max(im(:)). See 'apply_LUT' function for more info.
%   - H   : image histogram. If I=min(im(:)):max(im(:)) are the intensities
%           present in the input image, then H(i) is the number of image 
%           pixels/voxels that have intensity I(i). 
%
% AUTHOR    : Anton Semechko (a.semechko@gmail.com)
% DATE      : Apr.2013
%

% Default input arguments
if nargin<2 || isempty(c), c=2; end
if nargin<3 || isempty(q), q=2; end

% Basic error checking
if nargin<1 || isempty(im)
    error('Insufficient number of input arguments')
end
msg='Revise variable used to specify class centroids. See function documentaion for more info.';
if ~isnumeric(c) || ~isvector(c)
    error(msg)
end
if numel(c)==1 && (~isnumeric(c) || round(c)~=c || c<2)
    error(msg)
end
if ~isnumeric(q)|| q<1.1 || numel(q)~=1
    error('Third input argument must be a real number > 1.1')
end

% Check image format
if isempty(strfind(class(im),'int'))
    error('Input image must be specified in integer format (e.g. uint8, int16)')
end
if sum(isnan(im(:)))~=0 || sum(isinf(im(:)))~=0
    error('Input image contains NaNs or Inf values. Remove them and try again.')
end

% Intensity range
Imin=double(min(im(:)));
Imax=double(max(im(:)));
I=(Imin:Imax)';

% Compute intensity histogram
H=hist(double(im(:)),I);
H=H(:);

% Initialize cluster centroids
if numel(c)>1
    C=c;
    c=numel(c);
else
    [~,C]=FastCMeans(im,c);
end

% Update fuzzy memberships and cluster centroids
I=repmat(I,[1 c]); dC=Inf;
while dC>1E-6
    
    C0=C;
    
    % Distance to the centroids
    D=abs(bsxfun(@minus,I,C));
    D=D.^(2/(q-1))+eps;
    
    % Compute fuzzy memberships
    U=bsxfun(@times,D,sum(1./D,2));
    U=1./(U+eps);
    
    % Update the centroids
    UH=bsxfun(@times,U.^q,H);
    C=sum(UH.*I,1)./sum(UH,1);
    C=sort(C,'ascend'); % enforce natural order
    
    % Change in centroids 
    dC=max(abs(C-C0));
    
end

% Defuzzify and create a label image
[Umax,LUT]=max(U,[],2);
L=LUT2label(im,LUT);

