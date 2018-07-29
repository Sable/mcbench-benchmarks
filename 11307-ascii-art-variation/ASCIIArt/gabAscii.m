function asciimg = gabAscii(img,axelWidth,outWidth,mustRescale,gamma,filename)
%GABASCII  Converts an image in ASCII art
%
%  This function converts in ASCII art an image using set of grayscale
% palettes selected by valutating the distribution of the graylevels in the
% pixel subregion that generates an ASCII pixel.
%
%  Params:
%
%  img          = The image
%  axelWidth    = The width of a single ASCII pixel (def=2)
%  outWidth     = The output image width (def=size(img)/axelWidth)
%  mustRescale  = Must rescale? (def=false)
%  gamma        = Optional: gamma value
%  filename     = Optional: txt file to be written
%
%  asciimg      = The ascii image (character matrix)

%  Declaring the grayscale palettes as cell of:
%  - threshold gradient vector
%  - graylevel ASCII palette
th = 0.01;
flat.grad  = [0,0];   flat.grays =  'M#H@OI+è):=-. ';
left.grad  = [-th,0]; left.grays =  'W#B@GJ?>];j-, ';
right.grad = [th,0];  right.grays = 'E#K£bk%<[|f-. ';
up.grad    = [0,-th]; up.grays =    'P#ARYTò?!*"°'' ';
down.grad  = [0,th];  down.grays =  'W#VbUI+ç|:=_. ';
% To be tested and revisited
palettes = {flat,left,right,up,down}; 
% Width/height aspect ratio of characters
charAspect = 0.45;

% Resizing the input image
if nargin<2 axelWidth = 2; end
if nargin<3 outWidth = ceil(size(img,2)/axelWidth); end
% Final size
wa = outWidth;
ha = ceil(charAspect*wa*size(img,1)/size(img,2));
% Actual size
w = wa*axelWidth;
h = ha*axelWidth;
img = imresize(img,[h,w]);

% Filter the input image
% Gray
if size(img,3)>1 img = rgb2gray(img); end
% Rescale
if nargin<4 mustRescale = false; end
if mustRescale
    img = double(img)-double(min(min(img)));
    img = img/max(max(img)); % Now values are in [0,1]
elseif max(max(img))>1
    img = double(img)/255.0;
end
% Gamma
if nargin>=5 && gamma>0 && gamma~=1
    img = img.^gamma;
end

% Computing the gradients
dx = img-[img(:,2:w),img(:,w)];
dy = img-[img(2:h,:);img(h,:)];

% Create the output image
asciimg = char(zeros(ha,wa));
aw = axelWidth;
% DEBUG stats = [];
for y=1:ha
    for x=1:wa
        % Obtaining the mean gradient of the pice
        mdx = mean(mean(dx((y-1)*aw+1:y*aw,(x-1)*aw+1:x*aw)));
        mdy = mean(mean(dy((y-1)*aw+1:y*aw,(x-1)*aw+1:x*aw)));
        mimg = mean(mean(img((y-1)*aw+1:y*aw,(x-1)*aw+1:x*aw)));
        % The gradient
        grad = [mdx,mdy];
        % Searching for the best palette
        i = 1; errv = norm(grad-palettes{1}.grad);
        for j=2:size(palettes,2)
            errl = norm(grad-palettes{j}.grad);
            if errl<errv
                i = j;
                errv = errl;
            end
        end
        % Computing the value of the pixel
        pos = ceil(size(palettes{i}.grays,2)*mimg);
        if pos>size(palettes{i}.grays) pos = size(palettes{i}.grays); end
        if pos<1 pos=1; end
        asciimg(y,x) = palettes{i}.grays(pos);
        % DEBUG stats = [stats,i];
    end
end
% DEBUG hist(stats);

% Saving in a file
if nargin>=6
    % Open the file
    fp = fopen(filename,'w');
    if fp==-1 error(sprintf('Cannot write file "%s"!',filename)); end
    % Write line by line
    for i=1:ha
        % Write a line with \n at the end
        fprintf(fp,'%s\n',asciimg(i,:));
    end
    % Closing
    fclose(fp);
end
