function im_hatchC = applyhatch_plusC(h,patterns,patterncolors,colorlist,dpi,hatchsc)
%APPLYHATCH_PLUSC Apply colored hatched patterns to a figure
%  im_hatch = applyhatch_plusC(h,patterns,patterncolors,colorlist,dpi,hatchsc)
%
%  APPLYHATCH_PLUSC(H,PATTERNS) creates a new figure from the figure H by
%  replacing distinct colors in H with the black and white
%  patterns in PATTERNS. The format for PATTERNS can be
%    a string of the characters '/', '\', '|', '-', '+', 'x', '.'
%    a cell array of matrices of zeros (white) and ones (black)
%
%  By default the lines are of uniform thickenss. hatch patterns line
%  thickness can be modified using a direct call to MAKEHATCH_PLUS using
%  the following syntax: makehatch_plus('HHn',m) where;
%       HH 	the hatch character written twice, '//', '\\', '||', '--', '++'
%       n   integer number for thickness
%       m   integer number for the matrix size (n<=m)
% Ex. makehatch_plus('\\4',9)
%
%  APPLYHATCH_PLUSC(H,PATTERNS,COLORS) maps the colors in the n by 3
%  matrix COLORS to PATTERNS. Each row of COLORS specifies an RGB
%  color value. COLORS can also be a character string list.
%
%  Note this function makes a bitmap image of H and so is limited
%  to bitmap output.
%
%  Example 1: basic operation using color char string
%       bar(rand(3,6));
%       im_hatchC = applyhatch_plusC(1,'\-x.\x','rkgrgb');%
%
%  Example 2: basic operation using color matrix
%       bar(rand(3,4));
%       im_hatchC = applyhatch_plusC(1,'\-x.',[1 0 0;0 1 0;0 0 1;0 1 1]);
%
%  Example 3: basic operation using resolution modification
%    pie(rand(6,1));
%    legend('Jan','Feb','Mar','Apr','May','Jun');
%    im_hatch = applyhatch_plusC(gcf,'|-+.\/','rgbcmy',[],150,0.5);
%    imwrite(im_hatch,'im_hatch.tiff','tiff')
%  Note : have not been able to understand exactly how colors are assigned
%  for some plot functions, so better to leave COLORLIST empty for
%  starters
%
%  Example 4: basic operation with user defined patterns
%       bar(rand(3,3));
%       im_hatch = applyhatch_plusC(gcf,{makehatch_plus('\',6),1-makehatch_plus('\',6),makehatch_plus('\',1)},'ggg');%
%
% Example 5: using variable thickness hatches
%       bar(rand(3,3));
%       im_hatch = applyhatch_plusC(gcf,{makehatch_plus('\',9),makehatch_plus('\\4',9),makehatch_plus('\\8',9)},'rgb');%
%
%  Example 6: basic operation using IMAGE plot
%   data = reshape([randperm(8) randperm(8) randperm(8)],4,6)
%   image(data)
%   im_hatch = applyhatch_plusC(1,'|-+.\/x/','rgbcmykr',colormap);
% Note : do not use imagesc, as you need an indexed image if you want to
% control the hatch assignments related to data values.
%
% Modification of APPLYHATCH_PLUS to allow colored patterns
% Modified Brian FG Katz    25-feb-2010
%  im_hatch = applyhatch_plusC(h,patterns,patterncolors,colorlist,dpi,hatchsc)
%
%   input   patterncolors   RGB matrix of colors for patterns
%                           (length(PATTERNS) X 3) or string of color char
%                           'r' 'g' 'b' 'c' 'm' 'y' of length = length(PATTERNS)
%           DPI             allows specification of bitmap resolution, making plot resolution
%                           better for printing
%           HATCHSC         multiplier for hatch scale to increase size of pattern for better operation
%                           at higher resolutions (not used when PATTERNS
%                           defines pattern matrix)
%                           default [] uses screen resolution as in APPLYHATCH
%   output  IM_HATCH        RGB bitmap matrix of new figure
%                           use IMWRITE to output in desired format
%
% Modified Brian FG Katz    21-sep-11
%   Variable line thickness
%
%  See also: APPLYHATCH, APPLYHATCH_PLUS

%  By Ben Hinkle, bhinkle@mathworks.com
%  This code is in the public domain. 
  
oldppmode = get(h,'paperpositionmode');
oldunits = get(h,'units');
oldcolor = get(h,'color');
oldpos = get(h,'position');
set(h,'paperpositionmode','auto');
set(h,'units','pixels');
set(h,'color',[1 1 1]);
figsize = get(h,'position');

if nargin < 6; hatchsc = 1      ; end
if nargin < 5; dpi = 0          ; end     % defaults to screen resolution
if nargin < 4; colorlist = []   ; end

if length(patterns) ~= length(patterncolors)
    error('PATTERN and PATTERNCOLORS must be the same length')
end

if ischar(patterncolors),
    patterncolors = charcolor2rgb(patterncolors);
end

bits = hardcopy(h,'-dzbuffer',['-r' num2str(dpi)]);
    bitsC = ones(size(bits))*0;
    blackpixels = intersect(find(bits(:,:,1)==255), (intersect(find(bits(:,:,1)==bits(:,:,2)),find(bits(:,:,1)==bits(:,:,3)))) ) ;
    
set(h,'paperpositionmode',oldppmode);
set(h,'color',oldcolor);

bwidth = size(bits,2);
bheight = size(bits,1);
bsize = bwidth * bheight;
if ~isempty(colorlist)
  colorlist = uint8(floor(255*colorlist));
  [colors,colori] = nextnonbw(0,colorlist,bits);
else
  colors = (bits(:,:,1) ~= bits(:,:,2)) | ...
	   (bits(:,:,1) ~= bits(:,:,3));
end
pati = 1;
colorind = find(colors);
while ~isempty(colorind)
  colorval(1) = bits(colorind(1));
  colorval(2) = bits(colorind(1)+bsize);
  colorval(3) = bits(colorind(1)+2*bsize);
  if iscell(patterns)
    pattern = patterns{pati};
  elseif isa(patterns,'char')
    pattern = makehatch_plus(patterns(pati),6*hatchsc);
  else
    pattern = patterns;
  end
  patternC = uint8(255*pattern);
  pattern = uint8(255*(1-pattern));
  pheight = size(pattern,2);
  pwidth = size(pattern,1);
  ratioh = ceil(bheight/pheight);
  ratiow = ceil(bwidth/pwidth);
  bigpattern = repmat(pattern,[ratioh ratiow]);
  if ratioh*pheight > bheight
    bigpattern(bheight+1:end,:) = [];
  end
  if ratiow*pwidth > bwidth
    bigpattern(:,bwidth+1:end) = [];
  end
  bigpattern = repmat(bigpattern,[1 1 3]);
  % Create RGB pattern
    pat_size = size(pattern,1)*size(pattern,2) ;
    pat_id = find(patternC);
    patternCrgb = repmat(ones(size(patternC))*255,[1 1 3])  ;
    for rgbLOOP = 1:3,
        patternCrgb(pat_id+(pat_size*(rgbLOOP-1)))=patternCrgb(pat_id+(pat_size*(rgbLOOP-1)))*patterncolors(pati,rgbLOOP) ;
    end % rgbLOOP
    bigpatternC = repmat(patternCrgb,[ratioh ratiow 1]);
    bigpatternC = bigpatternC(1:size(bigpattern,1),1:size(bigpattern,2),:)    ;
%       if ratioh*pheight > bheight
%         bigpatternC(bheight+1:end,:,:) = [];
%       end
%       if ratiow*pwidth > bwidth
%         bigpatternC(:,bwidth+1:end,:) = [];
%       end
  
  color = (bits(:,:,1) == colorval(1)) & ...
	  (bits(:,:,2) == colorval(2)) & ...
	  (bits(:,:,3) == colorval(3));
  color = repmat(color,[1 1 3]);
  bits(color) = bigpattern(color);
    bitsC(color) = bigpatternC(color);
  if ~isempty(colorlist)
    [colors,colori] = nextnonbw(colori,colorlist,bits);
  else
    colors = (bits(:,:,1) ~= bits(:,:,2)) | ...
	     (bits(:,:,1) ~= bits(:,:,3));
  end
  colorind = find(colors);
  pati = (pati + 1);
  if pati > length(patterns)
    pati = 1;
  end
end

bitsC(blackpixels)= 255;
bitsC(blackpixels+(bheight*bwidth))= 255;
bitsC(blackpixels+(2*(bheight*bwidth)))= 255;


newfig = figure('units','pixels','visible','off');
imaxes = axes('parent',newfig,'units','pixels');
im = image(bitsC/255,'parent',imaxes);
%fpos = get(newfig,'position');
%set(newfig,'position',[fpos(1:2) figsize(3) figsize(4)+1]);
set(newfig,'position',oldpos)
set(imaxes,'position',[0 0 figsize(3) figsize(4)+1],'visible','off');
set(newfig,'visible','on');

set(newfig,'units','normalized');
set(imaxes,'units','normalized');
set(imaxes,'DataAspectRatio',[1 1 1],'DataAspectRatioMode','manual');


if nargout == 1,    im_hatchC = bitsC; end

function [colors,out] = nextnonbw(ind,colorlist,bits)
out = ind+1;
colors = [];
while out <= size(colorlist,1)
  if isequal(colorlist(out,:),[255 255 255]) | ...
	isequal(colorlist(out,:),[0 0 0])
    out = out+1;
  else
    colors = (colorlist(out,1) == bits(:,:,1)) & ...
	     (colorlist(out,2) == bits(:,:,2)) & ...
	     (colorlist(out,3) == bits(:,:,3));
    return
  end
end

function colors_rgb = charcolor2rgb(colors_char);
for LOOP = 1:length(colors_char),
    switch colors_char(LOOP)
        case 'r'
            colors_rgb(LOOP,:) = [1 0 0]    ;
        case 'g'
            colors_rgb(LOOP,:) = [0 1 0]    ;
        case 'b'
            colors_rgb(LOOP,:) = [0 0 1]    ;
        case 'c'
            colors_rgb(LOOP,:) = [0 1 1]    ;
        case 'm'
            colors_rgb(LOOP,:) = [1 0 1]    ;
        case 'y'
            colors_rgb(LOOP,:) = [1 1 0]    ;
        case 'k'
            colors_rgb(LOOP,:) = [0 0 0]    ;
        otherwise
            error('Invalid folor char string')
    end
end
