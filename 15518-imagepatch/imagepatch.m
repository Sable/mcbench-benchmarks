function [newimage neworigin] = ...
    imagepatch(Ibig,Ismall,origin,offset,padval)
% IMAGEPATCH writes one image over another at location specified by offset.
% I = imagepatch(image1,image2,[originx originy],[offsetx offsety]) returns
% a new image, I, containing image1 overwritten by image 2 at the location
% specified by the offset and origin coordinates.
% 
% [I origin] = imagepatch(im1,im2,[origin_x origin_y],[offset_x offset_y])
% returns a new image, I, and a vector, origin, containing the pixel
% coordinates corresponding to the origin in the new image.
% 
% I = imagepatch(im1,im2,[origin_x origin_y],[offset_x offset_y],padval) 
% returns a new image, where padval specifies the padding value used by
% PADARRAY if it is necessary to expand im1 to accomodate im2 at the offset
% coordinates.
% 
% Example:
%             moon = imread('moon.tif');
%             pout = imread('pout.tif');
%             %centered image
%             origin = round(flipdim(size(moon),2)./2);
%             offset = [200 250];
%             imshow(imagepatch(moon,pout,origin,offset));
% 
% See also IMAGESC, IMAGE, IMREAD, IMWRITE

% written by David Sedarsky
% July, 2007

if nargin == 0
    %if true, show example of use
    padval = 0;
    help imagepatch
    Ibig = ones(10);        %initialize example bigframe
    Ibig(1:2:end,:)=0.7;    %draw some stripes for fun
    Ismall = 0.5 .* ones(6);%initialize example subframe
    origin = [5 5];         %set example origin coordinates
    offset = [5 -4];        %set example offset for subframe
elseif nargin < 4
    error(['4 inputs, (imagematrix,imagematrix,xycoords,xyoffsets)'...
        ', required.']);
elseif nargin == 4
    padval = 0;  %set default pad value for use of PADARRAY below
elseif nargin > 5
    %crude padval check
    if ischar(padval)
        if ~strcmpi(padval,'circular')||strcmp(padval,'c')
            if ~strcmpi(padval,'replicate')||strcmp(padval,'r')
                if ~strcmpi(padval,'symmetric')||strcmp(padval,'s')
                    error(['Invalid pad value. See HELP PADARRAY for'...
                        ' valid pad value input format.']);
                end
            end
        end
    elseif isscalar(padval)
        %scalar value is fine
    else
        error(['Invalid pad value. See HELP PADARRAY for'...
                        ' valid pad value input format.']);
    end        
end

bigframe = Ibig;

%get image dimensions
[ydim xdim] = size(Ismall);
[ybig xbig] = size(Ibig);

%get origin
xorig = origin(1);
yorig = origin(2);

%get offsets and offset directions
xoff = offset(1);
if xoff > 0
    xdir = 'positive';
elseif xoff < 0
    xdir = 'negative';
else
    xdir = 'zero';
end
yoff = offset(2);
if yoff > 0
    ydir = 'positive';
elseif yoff < 0
    ydir = 'negative';
else
    ydir = 'zero';
end

%spacer is the distance between origin and edge of subframe
xspacer = abs(xoff)-floor(xdim./2);
yspacer = abs(yoff)-floor(ydim./2);


%distance: Origin to side of new frame in pixels
if strcmp(xdir,'positive')
    right_side = xspacer + xdim;
    left_side = xspacer + 1;
elseif strcmp(xdir,'negative')
    right_side = -xspacer;
    left_side = -xspacer - (xdim-1)
else
    %do zero case
%     right_side = floor(xdim./2);
%     left_side = -floor(xdim./2);
    right_side = xspacer + xdim;
    left_side = xspacer + 1;
end
if strcmp(ydir,'positive')
    top_side = yspacer + 1;
    bottom_side = yspacer + ydim;
elseif strcmp(ydir,'negative')
    top_side = -yspacer - (ydim-1);
    bottom_side = -yspacer;
else
    %do zero case
%     top_side = -floor(ydim./2);
%     bottom_side = floor(ydim./2);
    top_side = yspacer + 1;
    bottom_side = yspacer + ydim;
end

%make a copy of the origin to modify later when we change bigframe
neworigin = origin;

%Check that subframe lies within bigframe, pad bigframe if it's too small
%checking RIGHT
if xorig + right_side > xbig
    %if true, need to expand bigframe
    right_padsize = [0 xorig+right_side-xbig];
    bigframe = padarray(bigframe,right_padsize,padval,'post');
end
%checking LEFT
if xorig + left_side < 1
    %if true, need to expand bigframe
    left_padsize = [0 abs(xorig+left_side)+1];
    bigframe = padarray(bigframe,left_padsize,padval,'pre');
    %adjust origin -- leftside padding moves the origin wrt first pixel
    neworigin = neworigin + left_padsize(end:-1:1)
end
%checking BOTTOM
if yorig + bottom_side > ybig
    %if true, need to expand bigframe
    bottom_padsize = [yorig+bottom_side-ybig 0];
    bigframe = padarray(bigframe,bottom_padsize,padval,'post');
end
%checking TOP
if yorig + top_side < 1
    %if true, need to expand bigframe
    top_padsize = [abs(yorig+top_side)+1 0];
    bigframe = padarray(bigframe,top_padsize,padval,'pre');
    %adjust origin -- topside padding moves the origin wrt first pixel
    neworigin = neworigin + top_padsize(end:-1:1);
end

nxorig = neworigin(1);
nyorig = neworigin(2);

%distance: new Origin to side of new frame in pixels
right = nxorig + right_side;
left = nxorig + left_side;
top = nyorig + top_side;
bottom = nyorig + bottom_side;

%place new frame inside expanded bigframe
bigframe(top:bottom,left:right) = Ismall;

if nargin == 0
    figure('Name','''imagepatch'' demonstration image.');
    imshow(bigframe,'InitialMagnification', 'fit');
    title(['offset:  x = ' num2str(xoff) ' ,  y = ' num2str(yoff)])
else
    newimage = bigframe;
end