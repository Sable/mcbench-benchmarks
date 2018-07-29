function [ seg_map ] = quadtreeseg( im, varargin )
%QUADTREESEG Takes an input image and segments it by Quad-trees
%   segments an image by recursively dividing it into four equal blocks if
%   the variability in its pixels is greater than a certain amount. The 
%   image input is usually square, or the segments output are proportional
%   to the aspect ratio of the input image. This function computes 
%   variability by checking the the std. dev. in pixel values. If given a 
%   color image, the average of these measures is used across the 3 layers.
%   
%   @args:
%       im: the input image (RGB or Grayscale) which needs to be segmented;
%           could be uint8, uint16, or double
%       (thresh_std): maximum allowed standard deviation or range inside a 
%           segment. Value needs to be between 0 and 1. If using uint8 
%           images the value is scaled by 255, and for uint16 it is scaled 
%           by 65535. Default 0.05
%       (min_block_size): Size 2 vector for minimum segment size
%       (min_block_size): Size 2 vector for maximum segment size
%   
%
%   Example:
%       i = imread('josh-brolin.jpg');
%       seg_map = quadtreeseg(i, 0.05, [1 1], [60 60]);
%       imagesc(i);
%
%
%   @author: Ahmad Humayun
%   @email: ahmad.humyn@gmail.com
%   @date: June 2010


    assert( ndims(im) == 2 || (ndims(im) == 3 && size(im,3) == 3), 'The image dimensions are not correct' );
    sz = size(im);
    seg_map = zeros(size(im,1), size(im,2));
    
    checked_list = false(sz(1)*sz(2), 1);           % stores if a certain segment has been checked
    index_list = zeros(sz(1)*sz(2), 1);             % stores segment index no.
    seg_list = zeros([sz(1)*sz(2), 4], 'uint16');
    
    % adjust the inputs
    thresh_var = 0.05;
    if nargin >= 2
        assert(isscalar(varargin{1}), 'Threshold value given should be a scalar');
        thresh_var = varargin{1};
    end
    if isa(im, 'uint8')
        thresh_var = 255*thresh_var;
    elseif isa(im, 'uint16')
        thresh_var = 65535*thresh_var;
    end
    thresh_var = thresh_var^2;
    
    min_block_size = [1 1];
    if nargin >= 3
        assert(isvector(varargin{2}) && numel(varargin{2}) == 2, 'minimum block size given should be a size 2 vector');
        min_block_size = varargin{2};
    end
    max_block_size = size(im);
    if nargin >= 4
        assert(isvector(varargin{3}) && numel(varargin{3}) == 2, 'maximum block size given should be a size 2 vector');
        max_block_size = varargin{3};
    end
    
    % setup the initial segments according to user max_block_size
    [c r] = meshgrid([1:max_block_size(2):sz(2) sz(2)+1], [1:max_block_size(1):sz(1) sz(1)+1]);
    c_temp = c(1:end-1, 1:end-1);
    r_temp = r(1:end-1, 1:end-1);
    c_lims = c(2:end, 2:end);
    r_lims = r(2:end, 2:end);
                                   % starting row  % starting col  % ending row  % ending col 
    seg_list(1:numel(r_temp),:) = [r_temp(:)       c_temp(:)       r_lims(:)-1   c_lims(:)-1];
    indx_reached = numel(r_temp);
    index_list(1:indx_reached) = 0:indx_reached-1;
    
    im = double(im);
    
    % while there is some unchecked segments
    while ~all(checked_list(1:indx_reached))
        % find all segments whose variances need to be checked
        seg_idxs = find(checked_list(1:indx_reached) == 0)';
    
        % iterate over all segments which have yet to be checked
        for idx = seg_idxs
            if checkVar( im(seg_list(idx,1):seg_list(idx,3), seg_list(idx,2):seg_list(idx,4), :), thresh_var, min_block_size )
                % get the extents when you quad-split the current segment
                [ new_segs ] = quadSplit( seg_list(idx,:) );
                
                % get the last segment's idx
                last_idx = index_list(indx_reached);
                
                % replace the old segment with the first new segment
                seg_list(idx,:) = [ new_segs(1,:) ];
                
                % add the other new segments to the list
                no_added_segs = size(new_segs,1)-1;
                seg_list(indx_reached+1:indx_reached+no_added_segs,:) = new_segs(2:end,:);
                index_list(indx_reached+1:indx_reached+no_added_segs) = [last_idx+1:last_idx+no_added_segs]';
                indx_reached = indx_reached + no_added_segs;
            else
                checked_list(idx) = 1;
            end
        end
    end
    
    % assign final segment indexes to the segment map
    for idx = 1:indx_reached
        seg_map( seg_list(idx,1):seg_list(idx,3), seg_list(idx,2):seg_list(idx,4) ) = index_list(idx);
    end
end

function [ do_split ] = checkVar( im_sec, thresh, min_block_size )

    % get the height and width as it would be after the split
    quad_split_szs = floor(double([size(im_sec,1) size(im_sec,2)])/2);
    quad_split_szs(quad_split_szs < 1) = 1;
    
    % check if the split would bring it below the minimum allowable size
    if any(quad_split_szs < min_block_size)
        do_split = 0;
    else
        im_sec = reshape(im_sec, [size(im_sec,1)*size(im_sec,2) 1 size(im_sec,3)]);

        v = var(im_sec, 1, 1);
        v = mean(v(:));

        do_split = v > thresh;
    end
end

function [ new_segs ] = quadSplit( seg )
    height = double(seg(3)-seg(1)+1);
    width = double(seg(4)-seg(2)+1);
    
    if height == 1
        new_segs = zeros(2,4);
        
        % W segment
        new_segs(1,:) = [ seg(1) seg(2) 1 ceil(width/2) ];
        % E segment
        new_segs(2,:) = [ seg(1) seg(2)+new_segs(1,4) 1 floor(width/2) ];
    elseif width == 1
        new_segs = zeros(2,4);
        
        % N segment
        new_segs(1,:) = [ seg(1) seg(2) ceil(height/2) 1 ];
        % S segment
        new_segs(2,:) = [ seg(1)+new_segs(1,3) seg(2) floor(height/2) 1 ];
    else
        new_segs = zeros(4);
        
        % NW segment
        new_segs(1,:) = [ seg(1) seg(2) ceil(height/2) ceil(width/2) ];
        % NE segment
        new_segs(2,:) = [ seg(1) seg(2)+new_segs(1,4) new_segs(1,3) floor(width/2) ];
        % SW segment
        new_segs(3,:) = [ seg(1)+new_segs(1,3) seg(2) floor(height/2) new_segs(1,4) ];
        % SE segment
        new_segs(4,:) = [ new_segs(3,1) new_segs(2,2) new_segs(3,3) new_segs(2,4) ];
    end
    
    % change from height width formatting to extent of pixels
    new_segs(:,[3 4]) = new_segs(:,[1 2]) + new_segs(:,[3 4]) - 1;
end