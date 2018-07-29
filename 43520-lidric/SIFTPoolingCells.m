% Written by Sebastian Zambanini                                          
% web   : http://www.caa.tuwien.ac.at/cvl/people/zamba/                                     
% email : zamba@caa.tuwien.ac.at  
% Code is based on paper "A Local Image Descriptor Robust to Illumination
% Changes", SCIA 2013
% Version: 1.02


function C = SIFTPoolingCells(patchsize,nr_cells,nr_scales,nr_orientations)

%FUNCTION generates SIFT pooling cells to perform local spatial pooling of the feature
%map
%
%   C = SIFTPoolingCells(patchsize,nr_cells)   
%
% INPUT :
%   patchsize - pixel size of the local image patch to be pooled, i.e. a patchsize x patchsize neighborhood is considered
%	nr_cells  - number of cells along one dimension (4 in the SIFT descriptor to get a 4x4 pooling)
%   nr_scales - number of scales of the filter bank (used to create pooling matrix of proper dimension to speed up pooling)
%   nr_orientations - number of orientations of the filter bank
%
% OUTPUT :
%	C - cell vector of size nr_cells whose entries are matrices of size patchsize x patchsize x nr_scales x nr_orientations. 
%   The 3rd and 4th dimension are just repeatings of the patchsize x patchsize matrix, the matrix which defines the spatial 
%   weighting of this cell
%
% The implementation follows the bilinear weighting between squared cells
% as in Lowe's SIFT descriptor

cellsize = round(patchsize/nr_cells);
kernelX = [0.5:(cellsize) (cellsize)-0.5:-1:0 ]'/cellsize;
kernelY = [0.5:(cellsize) (cellsize)-0.5:-1:0 ]/cellsize;
[X,Y] = meshgrid(kernelX,kernelY);
kernel = (X.*Y);

%double patchsize to prevent index out of bounds
mid = (patchsize)+0.5;

%gaussian window to give more weight to features near the patch center
gaussianwindow = zeros(patchsize*2,patchsize*2);
gaussianwindow((patchsize/2+1):(end-patchsize/2),(patchsize/2+1):(end-patchsize/2)) = fspecial('gaussian',patchsize,patchsize/2);
gaussianwindow = gaussianwindow/max(gaussianwindow(:));

i=1;

p1=(patchsize/2+cellsize/2+0.5):cellsize:(patchsize+patchsize/2);
p2=p1; 
for x=p1
    for y=p2   
        filters  = zeros(patchsize*2,patchsize*2);
        filters(round((x-cellsize):(x+cellsize-1)),round((y-cellsize):(y+cellsize-1)))=kernel;
        filters = filters.*gaussianwindow;
        %resize back to original dimensions and repeat to proper dimension
        %for pooling
        C{i} = repmat(filters((patchsize/2+1):(end-patchsize/2),(patchsize/2+1):(end-patchsize/2)),[1 1 nr_scales nr_orientations]);
        i=i+1;
    end
end   