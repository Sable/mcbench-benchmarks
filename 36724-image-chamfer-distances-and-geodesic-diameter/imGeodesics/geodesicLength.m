function gl = geodesicLength(img, varargin)
%GEODESICLENGTH Compute geodesic length of particles
%
%   Deprecated: replaced by imGeodesicDiameter
%
%   GL = geodesicLength(IMG)
%   where IMG is a labeled image, returns the geodesic length of each
%   particle.
%   If IMG is a binary image, a labelling is performed.
%   GL is a column vector containing the geodesic length of each particle.
%
%   
%   gl = geodesicLength(IMG, SE)
%   Specifies a structuring element for performing distance transform.
%   Default structuring element is a cross (or a 3D cross) containing all
%   orthogonal pixels (or voxels)
%   
%
%   A definition for the geodesic length can be found in the book from
%   Coster & Chermant : "Precis d'analyse d'images", Ed. CNRS 1989.
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 06/07/2005.
%

%   HISTORY 
%   10/08/2006: add support for 3D images
%   19/04/2007: update doc, allocate memory for result

warning('malimpa:deprecated', ...
    'function "geodesicLength" has been replaced by "imGeodesicDiameter"');


% default structuring element
if ndims(img)==2
    se = [0 1 0;1 1 1;0 1 0];
else
    se = cross3d;
end
    
% get connectivity from input parameter
if ~isempty(varargin)
    var = varargin{1};
    if length(var)==1
        if var == 4
            if ndims(img)==2
                se = [0 1 0;1 1 1;0 1 0];
            else
                se = cross3d;
            end
        elseif var == 8
            if ndims(img)==2
                se = ones(3, 3);
            else
                se = ones([3 3 3]);
            end
        end
    else
        se = var;
    end
end

% switch between image types
if islogical(img)
    img = bwlabeln(img);
end

dim = size(img);

% number of structures in image
n = max(img(:));

gl = zeros(n, 1);
for i=1:n
    im = img==i;
    
    % initialize a random germ inside particle
    im0 = zeros(size(im));
    if ndims(img)==2
        [y x] = ind2sub(dim, find(im, 1, 'first'));
        im0(y, x) = 1;
    else
        [y x z] = ind2sub(dim, find(im, 1, 'first'));
        im0(y, x, z) = 1;
    end    
    imd = im0;
    
    % iterate as long as we can dilate under the mask
    d=1;
    while sum(imd(:))>0
        imd = imdilate(im0>0, se) & im & ~im0;
        
        d = d+1;
        im0(imd)=d;
    end
    
%     % find furthest point
%     maxd = max(im0(:));
%     [y x] = ind2sub(dim, find(im0==maxd, 1, 'first'));
%     
%     im0 = zeros(size(im));
%     im0(y, x) = 1;
%     imd = im0;
    
    % initialize a random germ inside particle
    maxd = max(im0(:));
    if ndims(img)==2
        [y x] = ind2sub(dim, find(im0==maxd, 1, 'first'));
        im0 = zeros(size(im));
        im0(y, x) = 1;
    else
        [y x z] = ind2sub(dim, find(im0==maxd, 1, 'first'));
        im0 = zeros(size(im));
        im0(y, x, z) = 1;
    end    
    imd = im0;

    
    % iterate as long as we can dilate under the mask
    d=1;
    while sum(imd(:))>0
        imd = imdilate(im0>0, se) & im & ~im0;
        
        d = d+1;
        im0(imd)=d;
    end
    
    gl(i) = max(im0(:));
end

% the germ pixel was counted as distance one, so we correct the result
gl = gl-1;
