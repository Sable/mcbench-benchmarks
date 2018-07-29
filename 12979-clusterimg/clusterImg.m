function varargout = clusterImg(imgin,Clusters,varargin)

% Copyright 2010 The MathWorks, Inc.
% [IDX,C,sumd,D] = clusterImg(imgin,nClusters,inMask,labels)
%
% This function implements kmeans clustering on an input RGB (m x n x 3)
% image. The user inputs at least two inputs: IMGIN and
% NCLUSTERS, and this
% function will step through an interactive color segmentation using kmeans
% clustering. It is interactive in that the user will be prompted to
% click-define the target colors in the segmentation. (There will be
% NCLUSTERS prompts.) Optionally, the user can also input a third argument
% containing a binary mask of the input image, in which case the program
% will operate on a subimage defined by the BOUNDING BOX of the (true)
% inMask.
%
% NOTE 1: Following segmentation (clustering), the user can EXPORT THE CLUSTERED
% IMAGE TO THE WORKSPACE, along with its corresponding colormap. Additionally,
% the user can opt to EXPORT A BINARY MASK OF A SINGLE COLOR CLUSTER TO THE
% WORKSPACE. Both of these options are initiated by press of a uicontrol
% pushbutton. The naming convention is automatic; the clustered image and
% corresponding colormap will be named CLUSTERED1 and CLUSTEREDMAP1,
% respectively. If those variables already exist in the workspace, they
% will NOT be overwritten. Rather, the names will be modified by
% incrementing the integer value on the end (e.g., CLUSTERED2,
% CLUSTERMAP2). Similarly, the binary mask on a cluster will be named
% CLUSTERMASK, CLUSTERMASK1, CLUSTERMASK2,....
%
% NOTE 2: To reconstruct the image from workspace variables, use the command:
%       imshow(clustered,clusterMap);
% 
% ***************************************
% SYNTAX:
%
% [IDX,C,sumd,D] = clusterImg(imgin,nClusters,inMask,labels);
%
% ***************************************
% INPUTS:
%
% Imgin:
%     an m x n x 3 (RGB) image
%
% Clusters:
%     Either A) an integer number of target clusters. (Note
%     that you will be prompted to click-define--using
%     IMPIXEL syntax--at least one pixel in each target
%     color cluster; you probably want this to be a
%     "reasonable" number (more than 1, less than, say,
%     20); or B) an nx3 array of predefined colors. Using
%     option B will skip the interactive selection process
%     and use the colors in Clusters as the bin targets.
%
% inMask (OPTIONAL)
%     a binary mask of size m x n. If a mask is included, this function
%     will operate on a sub-image defined by IMCROP(imgin,BoundingBox),
%     where BoundingBox is the rectangular extent of the true mask.
%
% labels (OPTIONAL)
%     a cell array of labels for the colormap display of the
%     segmented image. Note that the number of strings must
%     be equal to the number of colors.
%
% ***************************************
% OUTPUTS:
%
% IDX, C, sumd, D
%     All as returned by KMEANS. Please refer to the help for that
%     function. Note, however, that the size of the outputs may be modified
%     by the inclusion of optional inMask input argument. (See NOTE 2
%     below.) 
%
% clustered
%     an indexed image of size p x q x 1 (see NOTE 4 below), segmented using kmeans
%     clustering. (See description of optional inMask input argument). If no
%     mask is provided, the CLUSTERED image is m x n x 1.
%
% clusteredMap
%     an Clusters x 3 matrix of RGB colors. These colors comprise the mean
%     values returned by each IMPIXEL selection when the user defines the
%     target cluster colors.
%    
% clusterMask
%     a binary mask of size p x q x 1 (see NOTE 2 below). Once the input has been
%     clustered, it will be displayed in a figure with a pushbutton prompt
%     to create a mask on a clustered color. If the button is pressed, the
%     user will be prompted to click-select a single cluster color (using
%     IMPIXEL syntax). CLUSTER_MASK will return a binary image with ones in
%     the location of the selected color, and zeros elsewhere.
%
% NOTE 3: OUTPUT ARGUMENTS [CLUSTERED, CLUSTEREDMAP, CLUSTERMASK] ARE
% PROMTED BY UICONTROLS, and do not require the presence of output
% arguments. Nomenclature is automatic, as described in NOTE 1 above.)
%
% NOTE 4: OUTPUT IMAGE (AND MAP) SIZES are p x q, if a binary mask is provided
% as an optional input, where p and q are defined by the extent of the
% bounding box of the (true) input mask. If no input mask is provided, p=m
% and q=n. 
%
%
% ***************************************
% EXAMPLES:
%
% 1)
% clusterImg(imread('peppers.png'),6);
%     segments the image in 'peppers.png' into 6 color
%     clusters.
% 2)
% a=[0.2902    0.1647    0.2824;
%    0.9137    0.7922    0.6784;
%    0.3725    0.4392    0.1412;
%    0.5961    0.1529    0.2039;
%    1.0000    0.7843    0.0431;
%    0.9686    0.5294         0];
% clusterImg(imread('peppers.png'),a,[],{'One','Two','Three','Four','Five','Six'});
%
% 3)
% [IDX, C, sumd, D] = clusterImg(x, 5, x(:,:,1) < 100);
%     masks image x with "red plane less than 100", finds the bounding box
%     of the resulting (logically true) inMask, and segments the IMCROPped
%     image x(inMask) into 5 color clusters. Returns the variables IDX, C,
%     sumd, and D, as described by the documentation for KMEANS.
% 
% ***************************************

% ***************************************
% DEPENDENCIES:
% Image Processing Toolbox, Statistics Toolbox
%
% ***************************************
% Written by Brett Shoelson, PhD
% brett.shoelson@mathworks.com
%
% Ver 2.0
% Revisions:
% Ver 1.1; 11/12/06. Bounding box detection on imcrop modified.
% Ver 1.2; 1/31.07. The second input argument has been
%    renamed from nClusters to Clusters to reflect the fact
%    that one can now either A) specify the number of clusters
%    and select them interactively (as before); or B)input an
%    nx3 array of colors, skipping the interactive
%    selection. ALSO, the function now takes an additional
%    optional input argument to specify the labels on the
%    colormap of the segmented image.
% Ver 2.0; 11/29/07. Now includes a pushbutton for the auto-generation of
%    all segmented colormap. Also, included description of LABELS as input
%    argument, and fixed incorrect capitalization of "clusterMaskn"
%    indicator. 
% ***************************************

%Parse and initialize input and output arguments
if ndims(imgin)~=3
	error('Input image must be m x n x 3 (RGB)');
end
if nargin == 3
	inMask = varargin{1};
	if all(inMask(:))
		%NO OP: inMask is all 1's...no masking performed
		inMask = [];
	end
else
	inMask = [];
end	

if ~isempty(inMask) %at least one excluded point; operate on masked sub-image
	[r,c]=find(inMask);
	bb = [min(c) min(r) max(c)-min(c) max(r)-min(r)];
	imgin = imcrop(imgin,bb);
	%bb = regionprops(bwlabel(inMask),'BoundingBox');
	%imgin = imcrop(imgin,bb.BoundingBox);
end

%Operate on image as double, regardless of input type
if ~isa(imgin,'double')
	imgin = im2double(imgin);
end

%Get individual RGB colors included in segmentation
rc = imgin(:,:,1);
gc = imgin(:,:,2);
bc = imgin(:,:,3);
tmpimg = imgin;
segcolors = double([rc(:) gc(:) bc(:)]);

tmpfig=figure('numbertitle','off','name','Cluster RGB Image','visible','off');
imshow(tmpimg);
set(tmpfig,'units','pixels','position',[0 0 1000 800]);
centerfig(tmpfig);
set(tmpfig,'visible','on');

if numel(Clusters)==1
	% Prompt for target cluster colors
	colors = zeros(Clusters,3);
	for ii=1:Clusters
		figure(tmpfig);
		title(sprintf('Select sample pixel(s) in cluster %d of %d:',ii,Clusters));
		tmp = impixel;
		colors(ii,:) = mean(tmp,1);
	end
elseif size(Clusters,2) == 3
	% User passed in the target colors; skip interactive
	% selection
	colors = Clusters;
	Clusters = size(colors,1);
end
title('Segmenting. Please wait.......');
drawnow;
%Operate on colors (and image) as doubles()
colors = im2double(colors);

% CALL KMEANS with appropritate output arguments.
if nargout < 2
	Idx = kmeans(segcolors,Clusters,'distance','sqEuclidean','start',colors,'emptyaction','singleton');
elseif nargout == 2
	[Idx,varargout{2}] = ...
	   kmeans(segcolors,Clusters,'distance','sqEuclidean','start',colors,'emptyaction','singleton');
elseif nargout == 3
	[Idx, varargout{2}, varargout{3}] = ...
		kmeans(segcolors,Clusters,'distance','sqEuclidean','start',colors,'emptyaction','singleton');
elseif nargout == 4
		[Idx, varargout{2}, varargout{3}, varargout{4}] = ...
		kmeans(segcolors,Clusters,'distance','sqEuclidean','start',colors,'emptyaction','singleton');
else
	error('Inappropriate number of outputs requested in ClusterImg.');
end
if nargout >= 2
	varargout{1} = Idx;
end

pixel_labels = reshape(Idx,size(rc));
imshow(pixel_labels,[]);
title('Image labeled by cluster index');
set(tmpfig,'units','pixels','position',[0 0 1000 800]);
centerfig(tmpfig);

colormap(colors);
tmp = colorbar;
set(tmp,'ytick',1:Clusters);
if nargin == 4
	set(tmp,'yticklabel',varargin{2});
end
uicontrol('style','pushbutton','string','Export Clustered Image and Map to Workspace','units','normalized',...
	'pos',[0.05 0.05 0.3 0.05],'callback',@exportMain);
uicontrol('style','pushbutton','string','Export Mask on Single Color','units','normalized',...
	'pos',[0.35 0.05 0.3 0.05],'callback',@exportClusterMask);
uicontrol('style','pushbutton','string','Export All Color Masks','units','normalized',...
	'pos',[0.65 0.05 0.3 0.05],'callback',{@exportAllClusterMasks,colors});

%Subfunctions local to clustering only. Isn't MATLAB wonderful?
	function exportMain(varargin)
		n = 0; tmp = 1;
		while tmp
			n = n + 1;
			tmp = evalin('base',['exist(''clustered', num2str(n), ''')']);
		end
		fprintf('Image written to clustered%d and associated colormap written to clusteredMap%d\n',n,n);
		fprintf('Display with:    imshow(clustered%d,clusteredMap%d);\n',n,n);
		assignin('base',['clustered' num2str(n)],pixel_labels);
		assignin('base',['clusteredMap' num2str(n)],colors);
	end

	function exportClusterMask(varargin)
		title('Click on any pixel in the desired region.');
		p=impixel;
		if ~all(p(:)==p(1))
			beep;
			disp('Select a SINGLE region!!!');
		else
			n = 0; tmp = 1;
			while tmp
				n = n + 1;
				tmp = evalin('base',['exist(''clusterMask', num2str(n), ''')']);
			end
			title('Image labeled by cluster index');
			fprintf('Mask of region %d written to clusterMask%d\n',p(1),n);
			assignin('base',['clusterMask' num2str(n)],pixel_labels==p(1));
		end
    end

    function exportAllClusterMasks(varargin)
        colors = varargin{3};
        n = 0; tmp = 1;
        while tmp
            n = n + 1;
            tmp = evalin('base',['exist(''clusterMask', num2str(n), ''')']);
        end
        for ii = 1:size(colors,1)
            fprintf('Mask of region %d written to clusterMask%d\n',ii,n+ii-1);
            assignin('base',['clusterMask' num2str(n+ii-1)],pixel_labels==ii);
        end
    end

end
