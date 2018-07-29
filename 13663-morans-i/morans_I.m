function M = morans_I(grid,W,s)
% PURPOSE: calculate global Moran's I for an input grid (matrix) by calculating all 
%          local Moran's I for a given moving windows size using a weight matrix. 
% -------------------------------------------------------------------
% USAGE: M = moransI(grid, W, s);
% where: [grid] is the matrix to analyse
%        [W] is the normalized weight matrix of the size the local Moran's
%            I will be calculated for (uneven sized!)
%        [s] is an optional flag to use zscores of input values for
%        calculation. Set to 'true' if zscores of local grid should be
%        calculated. Leave blank if not desired or input values are already
%        standardized. 
% -------------------------------------------------------------------------
% OUTPUTS:
%        [M] matrix of all local Moran's I 
% -------------------------------------------------------------------
% NOTES: Weight matrix needs to be 'moving window' style, not contiguity
%        matrix: Moran's I is calculated and weighted for neighbours to center cell.
%        Matrix needs to be normalized (weights sum to 1) and center cell weight 
%        will be set to 0 if not already. Uses localmoran.m
%        -> Use nanmean(M(:)) to get the average global Moran's I.
%
% See Anselin (1995, 'LISA.', Geogr. Analysis 27(2),p.93f) for details on 
% standardized variables in calculation of local Moran's I. 
%
% EXAMPLE:  M = moransI(rand(20,20),ones(5,5),'true')
%
% Felix Hebeler, Geography Dept.,de University Zurich, March 2006.

%% Check if standardising should be done
if exist('s','var')
    if strcmp(s,'true');
        grid=zscore(grid);
    elseif strcmp(s,'false')
        %do nothing
    else
        error('Invalid option for s: set [true] to calculated zscores to determine local Moran or leave blank if values are already standardized.');
    end
end
if (mod(size(W,1),2)| mod(size(W,2),2))~=1
   error('Weight matrix W needs to have uneven size (eg. 5x5)') 
end
%% Do local Morans I calc of the grid.
M = NaN(size(grid,1),size(grid,2));
wsx=floor(size(W,1)/2);
wsy=floor(size(W,2)/2);
% Do local morans I calc for moving window ws
for row=1+wsy:1:size(grid,1)-wsy;
    for col=1+wsx:1:size(grid,2)-wsx;
        M(row,col) = get_moran(grid(row-wsx:row+wsx,col-wsy:col+wsy),W);
    end
end

%% calculate local Moran's I
function m=get_moran(raster,W)
ncols= size(raster,2);
nrows= size(raster,1);
zi = raster(ceil(nrows/2),ceil(ncols/2));%  value of center cell (note: no weight applied!)
if (isnan(zi));
    m=NaN; 
    return; 
end;
raster=raster.* W; % Weight values in window
raster(ceil(nrows/2),ceil(ncols/2))=0; %set center cell to zero to exclude zi from sum
zj = nansum(raster(:)); % sum of weighted values excluding zi
m = zi * zj; % calculate local Moran's I and return