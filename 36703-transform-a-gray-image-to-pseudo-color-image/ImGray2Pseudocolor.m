function rgb = ImGray2Pseudocolor(gim, map, n)
% IMGRAY2PSEUDOCOLOR transform a gray image to pseudocolor image
%   GIM is the input gray image data
%   MAP is the colormap already defined in MATLAB, for example:
%      'Jet','HSV','Hot','Cool','Spring','Summer','Autumn','Winter','Gray',
%      'Bone','Copper','Pink','Lines'
%   N specifies the size of the colormap 
%   rgb is the output COLOR image data
%
% Main codes stolen from:
%       http://www.alecjacobson.com/weblog/?p=1655
%       %% rgb = ind2rgb(gray2ind(im,255),jet(255));                      %
%                                                                           


[nr,nc,nz] = size(gim);
rgb = zeros(nr,nc,3);

if ( ~IsValidColormap(map) )
    disp('Error in ImGray2Pseudocolor: unknown colormap!');
elseif (~(round(n) == n) || (n < 0))
    disp('Error in ImGray2Pseudocolor: non-integer or non-positive colormap size');
else
    fh = str2func(ExactMapName(map));
    rgb = ind2rgb(gray2ind(gim,n),fh(n));
    rgb = uint8(rgb*255);
end

if (nz == 3)
    rgb = gim;
    disp('Input image has 3 color channel, the original data returns');
end

function y = IsValidColormap(map)

y = strncmpi(map,'Jet',length(map)) | strncmpi(map,'HSV',length(map)) |...
    strncmpi(map,'Hot',length(map)) | strncmpi(map,'Cool',length(map)) |...
    strncmpi(map,'Spring',length(map)) | strncmpi(map,'Summer',length(map)) |...
    strncmpi(map,'Autumn',length(map)) | strncmpi(map,'Winter',length(map)) |...
    strncmpi(map,'Gray',length(map)) | strncmpi(map,'Bone',length(map)) |...
    strncmpi(map,'Copper',length(map)) | strncmpi(map,'Pink',length(map)) |...
    strncmpi(map,'Lines',length(map));

function emapname = ExactMapName(map)

if strncmpi(map,'Jet',length(map))
    emapname = 'Jet';
elseif strncmpi(map,'HSV',length(map))
    emapname = 'HSV';
elseif strncmpi(map,'Hot',length(map))
    emapname = 'Hot';
elseif strncmpi(map,'Cool',length(map))
    emapname = 'Cool';
elseif strncmpi(map,'Spring',length(map))
    emapname = 'Spring';
elseif strncmpi(map,'Summer',length(map))
    emapname = 'Summer';
elseif strncmpi(map,'Autumn',length(map))
    emapname = 'Autumn';
elseif strncmpi(map,'Winter',length(map))
    emapname = 'Winter';
elseif strncmpi(map,'Gray',length(map))
    emapname = 'Gray';
elseif strncmpi(map,'Bone',length(map))
    emapname = 'Bone';
elseif strncmpi(map,'Copper',length(map))
    emapname = 'Copper';
elseif strncmpi(map,'Pink',length(map))
    emapname = 'Pink';
elseif strncmpi(map,'Lines',length(map))
    emapname = 'Lines';
end
