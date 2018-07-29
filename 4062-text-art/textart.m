function chararray_out=textart(image_data, varargin)
%TEXTART - Conert digital image to ASCII text image
%   TEXTART(IMAGE) returns a character array based on IMAGE, which may be
%     either a filename of an image file, or the pixel data of an image
%     (2-D or 3-D)
%   TEXTART(...,PROPERTIES) allows the caller to specifiy PROPERTIES, pair-wise:
%     'zoom' - enlarges (or reduces) image (default 1.0)
%     'aspect' - Aspect correction ratio (default 1.0)
%     'gamma' - Skews the intensity levels (default 1.0)
%     'file' - Specifies (text) file to which to write character data (default none)
%     'bg' - Specifies background color of original image, typically 0. (default none)
%     'interp' - Interpolate per 1969 I.D.G. MacLead algorithm
%
%   Example:
%     chardata = textart('c:\matlab6p5\bin\win32\matlab.ico','zoom',8,'bg',0);

% 02/05/09 jaj Add 'interp' function per 1969 I.D.G. MacLead algorithm,
%   "Pictorial Output with a Line Printer", IEEE Transactions on Computers,
%   Volume 19 ,  Issue 2  (February 1970), Pages 160-162

% Default properties
properties = struct('zoom',1.0,'aspect',1.0,'gamma',1.0,'file',[],'bg',[],'interp',false);

if nargin == 0
  error('Missing image file name to convert')
end

properties = getopt(properties,varargin{:});

% Load/convert the image data
if ischar(image_data)
  image_data = imread(image_data);
end

image_data = double(image_data); % Some images are uint8, etc.

% If 3-D image (color) convert to black/white
if ndims(image_data) == 3
  image_data = mean(image_data,3);
end

if ~isempty(properties.bg)
  image_data(image_data == properties.bg) = 255;
end


% Process then input arguments

% Define the set of ASCII characters to use, and compute their denisties
% (intensities) by drawing them, capuring the images, and counting the
% number of pixels lit up.
% (Need do this only once.)
[density_table,h_char_pix,w_char_pix] = get_density_data;

A = 1-image_data/255; % Convert image to B/W, negate, normalize

% Make the size of a divisibale by the number of characters
h_im_pix = size(A,1); % height of image, in pixels
w_im_pix = size(A,2); % width of image, in pixels

h_im_char = round(properties.aspect*properties.zoom*h_im_pix/h_char_pix); % height of image, in characters
w_im_char = round(properties.zoom*w_im_pix/w_char_pix); % width of image, in characters

h_step_pix = h_im_pix/h_im_char;
w_step_pix = w_im_pix/w_im_char;

% Gamma adjustment
A = A.^properties.gamma;
% hist(A(:),100) % View inensity distribution

h_step_idx_list = round(h_step_pix*(1:h_im_char));
w_step_idx_list = round(w_step_pix*(1:w_im_char));

h_step_idx_list = max(h_step_idx_list,1);
w_step_idx_list = max(w_step_idx_list,1);

% This filtering technique is just a convenient means to average
% the intensity of pixels in sucessive blocks.
filt_len_h = floor(h_step_pix);
filt_len_w = floor(w_step_pix);

filtcoef_h = [ones(filt_len_h,1);h_step_pix-filt_len_h];
filtcoef_w = [ones(filt_len_w,1);w_step_pix-filt_len_w];

filtcoef_h = filtcoef_h ./ sum(filtcoef_h); % Normalize
filtcoef_w = filtcoef_w ./ sum(filtcoef_w); % Normalize

A1 = filter(filtcoef_h, 1, A, [], 2);
A1 = filter(filtcoef_w, 1, A1, [], 1);
A1 = A1(h_step_idx_list,w_step_idx_list); % decimate

% % This section provides (a very slow) preview
% for h=1:h_im_char
%   for w=1:w_im_char
%     c = 1-A1(h,w);
%     try
%       plot(w,h,'.','color',[c c c]); hold on
%     catch
%       fprintf('uh oh\n');
%     end
%   end
% end
% hold off;axis equal;axis tight;set(gca,'ydir','reverse');
% set(gca,'DataAspectRatio',[h_char_pix w_char_pix 1])

density = [density_table.density];
ch_list = {density_table.ch_list};
nchar   = [density_table.nchar];
% A1 is the density of each block in the picture. No compare against the
% character densities, using clever(?) vector processing.
d_im = repmat(A1,[1 1 length(ch_list)]); % Now a 3-d matrix
d_ch = repmat(reshape(density,[1 1 length(ch_list)]),[size(A1),1]);

% 03/05/09 jaj Use I.D.G. MacLeod algorithm per 1969 paper "Pictorial
% output with a line printer"

if ~properties.interp
  % Original implementation
  [dif,ind] = min(abs(d_im-d_ch),[],3); % Find closest density match: block to character
else
  dist = d_im-d_ch;
  [junk,ind] = min(abs(dist),[],3); % Find closest density match: block to character
  dif = A1-density(ind);
  ind0 = ind - (dif <= 0);
  ind1 = ind + (dif > 0);
  ind1(ind0 == 0) = ind1(ind0 == 0)+1;
  ind0(ind0 == 0) = ind0(ind0 == 0)+1;
  % Linear interpolation
  d0 = A1-density(ind0);
  d1 = density(ind1)-A1;
  p = d0./(d0+d1);
  r = rand(size(A1));
  sel = r <= p;
  ind(sel) = ind0(sel);
  ind(~sel) = ind1(~sel);
end
chararray = repmat(' ',size(A1));
for ii=1:numel(A1)
  ix = ind(ii);
  chararray(ii) = ch_list{ix}(ceil(nchar(ix)*rand(1)));
end
%chararray=ch_list(ind);

% Return the character data only under certain conditions
if nargout > 0 || isempty(properties.file)
  chararray_out = chararray;
end

% Write character data to file, if requested
if ~isempty(properties.file)
  fid=fopen(properties.file,'wt');
  if fid <= 0
    error(['Unable to open file ',properties.file]);
  end
  for y=1:size(chararray,1);
    fprintf(fid,'%s\n',chararray(y,:));
  end
  fclose(fid);
end

%---------------------------------------------------------------
function [density_table_out,h_char_pix_out,w_char_pix_out] = get_density_data

persistent h_char_pix w_char_pix density_table
fontname = 'courier'; % Must be fixed width font
if isempty(density_table)
  ch_list = char(32:126);
  figure; subplot(1,1,1); cla; reset(gca)
  for ii=1:length(ch_list);
    ch = ch_list(ii);
    h=text(0.5,0.5,ch);
    set(h,'Interp','none','FontName',fontname,'FontUnits','pixels',...
      'FontSize',10,'units','pixels','margin',1);
    set(gca,'xlim',[0 1],'ylim',[0 1]);
    rect = get(h,'extent');
    F = getframe(gca,rect+[0 2 -2 0]);
    %   x=[char(183),'o'];
    bw = ~F.cdata(:,:,1); % Black(1) and white(0) pixel array
    chardata{ii} = bw;
    density(ii) = sum(sum(bw));
    delete(h)
  end
  close(gcf)
  density = density./max(density);
  ch_list_save = ch_list;
  fontname_save = fontname;
  % 03/05/09 sort by density
  [density,order] = sort(density);
  ch_list = ch_list(order);
  chardata = chardata(order);
  %03/05/09 Create a table, based on unique densities
  density_table = struct(...
    'density',0,... % Density, 0..1
    'nchar',0,... % number of characters having this density
    'ch_list',''); % List of characters (of length nchar)
  [u,m,n] = unique(density);
  density_table = repmat(density_table,1,length(u));
  for ii=1:length(m)
    f = find(density == u(ii));
    density_table(ii).density = u(ii);
    density_table(ii).nchar = length(f);
    density_table(ii).ch_list = ch_list(f);
  end
  h_char_pix = size(chardata{1},1); % Height of a character, in pixels
  w_char_pix = size(chardata{1},2); % Width of a character, in pixels
    
end
density_table_out = density_table;
h_char_pix_out = h_char_pix;
w_char_pix_out = w_char_pix;

function properties = getopt(properties,varargin)
%GETOPT - Process paired optional arguments as 'prop1',val1,'prop2',val2,...
%
%   getopt(properties,varargin) returns a modified properties structure,
%   given an initial properties structure, and a list of paired arguments.
%   Each argumnet pair should be of the form property_name,val where
%   property_name is the name of one of the field in properties, and val is
%   the value to be assigned to that structure field.
%
%   No validation of the values is performed.
%
% EXAMPLE:
%   properties = struct('zoom',1.0,'aspect',1.0,'gamma',1.0,'file',[],'bg',[]);
%   properties = getopt(properties,'aspect',0.76,'file','mydata.dat')
% would return:
%   properties = 
%         zoom: 1
%       aspect: 0.7600
%        gamma: 1
%         file: 'mydata.dat'
%           bg: []
%
% Typical usage in a function:
%   properties = getopt(properties,varargin{:})

% Process the properties (optional input arguments)
prop_names = fieldnames(properties);
TargetField = [];
for ii=1:length(varargin)
  arg = varargin{ii};
  if isempty(TargetField)
    if ~ischar(arg)
      error('Propery names must be character strings');
    end
    f = find(strcmp(prop_names, arg));
    if length(f) == 0
      error('%s ',['invalid property ''',arg,'''; must be one of:'],prop_names{:});
    end
    TargetField = arg;
  else
    % properties.(TargetField) = arg; % Ver 6.5 and later only
    properties = setfield(properties, TargetField, arg); % Ver 6.1 friendly
    TargetField = '';
  end
end
if ~isempty(TargetField)
  error('Property names and values must be specified in pairs.');
end
