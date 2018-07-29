function [img, map, alpha, filename, pathname, allFileNames] = uiselectim(varargin)
% Syntax:
% [img, map, alpha, filename, pathname, allFileNames] = uiselectim('start_path');
%
%
% Provides functionality for visually selecting a single image from an array
% of images. All images must be in a common directory. Calls uigetfile with
% the multi-select option enabled, allowing the user to select any number
% of images. The layout tool will automatically display images in a subplot 
% array. If you single-click an image, a background patch is highlighted to
% show the selection. Double-clicking (or selecting the "Okay" button)
% finalizes the selection, and returns the selected image (and map and
% alpha value, where appropriate), the filename, and the pathname. 
%
% INPUT:
%    start_path (optional): start_path specifies the directory to display
%    when the dialog is first opened. If start_path is a string
%    representing a valid directory path, the dialog box opens in the
%    specified directory. If start_path is an empty string ('') or is not
%    provided, the dialog box opens in the current working directory.
%
% OUTPUTS:
%    Output arguments 1--3 map to the output arguments of IMREAD. Note that
%    MAP and ALPHA may be empty. FILENAME and PATHNAME, not surprisingly,
%    return the filename and pathname of the selected image. ALLFILENAMES
%    returns a (sorted) list of the names of all images selected for
%    display in UISELECTIM. (See help for IMREAD for additional information
%    about the first three output arguments.) 
%
% EXAMPLES:
% [img, map, alpha, filename, pathname, allFileNames] = uiselectim('C:\mfiles'); 
% img = uiselectim; 


% Written 05/2006 by Brett Shoelson, PhD
% brett.shoelson@mathworks.com
% Ver 1.0

% Parse formats from IMFORMATS
formats = imformats;
nformats = length(formats);
desc = cell(nformats+1,1);
[desc{2:end}] = deal(formats.description);
ext = cell(nformats+1,1);
[ext{2:end}] = deal(formats.ext);
% Add other formats that are not part of IMFORMATS
desc{end+1} = 'Dicom (DCM)';
ext{end+1} = {'dcm'};
nformats = size(desc,1);
allext=[formats.ext,'dcm'];
ext{1} = sprintf('*.%s;',allext{:});
desc{1} = 'All Image Formats';

filterspec = cell(nformats,2);
filterspec{1,1} = ext{1};
filterspec{1,2} = desc{1};
for ii = 2:nformats
	filterspec{ii,1} = sprintf('*.%s;',ext{ii}{:});
	filterspec{ii,2} = sprintf('%s',desc{ii});
end


if nargin == 1 && ~isempty(varargin{1})
	currPath = pwd;
	tmp = pwd;
	try
		cd(varargin{1});
	catch
		error('If you provide an input argument, it must be a string representation of a valid search path.');
	end
end
[f,pathname] = uigetfile(filterspec,'MultiSelect', 'on');
if nargin == 1 && ~isempty(varargin{1})
	cd(currPath);
end

if ischar(f) %Single file selected
	filename = f;
	[img,map,alpha] = imread([pathname f]);
	allFileNames = f;
	return
end

if ~iscell(f) && f==0
	filename = []; pathname = []; img = [];map = [];alpha = [];allFileNames = [];
	return
end


nFrames = numel(f);
subim = zeros(nFrames,1);

if nargout > 5
	allFileNames=sort(f);
end

ptch=zeros(1,nFrames); %Preallocate patch variable
for ii = 1:nFrames
	[k,map,alpha] = imread([pathname f{ii}]);
	[nRows,nCols,nBands] = size(k);
	if ii == 1
		% Estimate nSubColumns and nSubRows given the desired ratio of
		% Columns to Rows to be one (square montage).
		aspectRatio = 1;
		nSubCols = sqrt(aspectRatio * nRows * nFrames / nCols);
		% Make sure Subplot rows and columns are integers. The order in the adjustment
		% matters because the Subplot image is created horizontally across columns.
		nSubCols = ceil(nSubCols);
		nSubRows = ceil(nFrames / nSubCols);
		tmpfig = figure('numbertitle','off','units','normalized',...
			'pos',[0.05 0.1 0.9 0.8],'name','Select Image','closerequestfcn',@mycloserequestfcn);
		okaybutton = uicontrol('style','pushbutton','string','Okay','units','normalized','position',[0.2 0.025 0.275 0.05],...
			'callback',@okay,'enable','off');
		uicontrol('style','pushbutton','string','Cancel','units','normalized','position',[0.525 0.025 0.275 0.05],...
			'callback',@mycloserequestfcn);
	end

	subplot(nSubCols,nSubRows,ii);
	subim(ii) = imshow(k,map);
	hold on
	% Pad x- and y-lim of current axis to include patch; create patch, and
	% send it behind the image
	x_aug = 0.05*diff(get(gca,'xlim'));
	y_aug = 0.05*diff(get(gca,'ylim'));
	ptch(ii) = patch([-x_aug nCols+x_aug nCols+x_aug -x_aug],[-y_aug -y_aug nRows+y_aug nRows+y_aug],...
		[1 0 0],'visible','off','edgecolor','none');
	set(gca,'children',flipud(get(gca,'children')),...
		'xlim',get(gca,'xlim')+[-x_aug x_aug],...
		'ylim',get(gca,'ylim')+[-y_aug y_aug]);
	set(subim(ii),'userdata',ii);
	title(f{ii});
end
set(subim,'buttondownfcn',@imsel);
uiwait(tmpfig);

%NESTED FUNCTIONS
	function selected = imsel(varargin)
		% SelectionType
		% normal: Click left mouse button
		% extend: Shift - click left mouse button or click both left and right mouse buttons
		% alt: Control - click left mouse button or click right mouse button
		% open: Double click any mouse button
		seltype = get(gcf,'SelectionType');
		selected = get(varargin{1},'userdata');
		switch seltype
			case {'normal','extend'}
				set(ptch,'visible','off');
				set(ptch(selected),'visible','on');
				set(okaybutton,'enable','on');
			case 'open'
				% Finalize selection; delete figure, store selection number
				% in main figure
				finalizeSelection(selected);
			case 'alt'
				tmp = get(gcbo,'cdata');
				tmppos = get(gcf,'pos');
				tmpunits = get(gcf,'units');
				tmpfig = figure('units',tmpunits);
				imshow(tmp);
				set(tmpfig,'pos',tmppos);
				uiwait(tmpfig);
		end
	end

	function okay(varargin)
		tmp = get(ptch,'visible');
		selected = find(strcmp(tmp,'on'));
		finalizeSelection(selected);
	end

	function finalizeSelection(varargin)
		selected = varargin{1};
		filename = f{selected};
		img = imread([pathname filename]);
		delete(gcf);
		drawnow;
	end

	function mycloserequestfcn(varargin)
		img=[];
		filename = [];
		pathname = [];
		closereq;
	end

end

