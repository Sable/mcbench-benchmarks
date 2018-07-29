% Written by Sebastian Zambanini                                          
% web   : http://www.caa.tuwien.ac.at/cvl/people/zamba/                                     
% email : zamba@caa.tuwien.ac.at  
% Code is based on paper "A Local Image Descriptor Robust to Illumination
% Changes", SCIA 2013
% Version: 1.02

function D = LIDRIC(positions,scales,F)
% FUNCTION computer the descriptors at given keypoint positions from the feature map
%
%   D = LIDRIC(positions,scales,F)
%
% INPUT :
%	positions - matrix of size 2 x (number of keypoints) where each column
%	defines the x- and y-position of a keypoint
%	scales  - size of the keypoint image patches in pixels
%   F - feature map as computed by the function FeatureMap()
%   should be done or not (default: true)
%
% OUTPUT :
%	F - descriptor matrix where each column gives the descriptor vector of
%	the corresponding keypoint
%	

F_nr_scales = size(F,3);
F_nr_orientations = size(F,4);

%create SIFT pooling cells based on given scales
[unique_scales,m,n] = unique(scales);
pooling_cells = cell(1,length(unique_scales)); 
for i = 1:length(unique_scales)
    pooling_cells{i} = SIFTPoolingCells(unique_scales(i),4,F_nr_scales,F_nr_orientations);
end

nr_pooling_cells = size(pooling_cells{1},3);
F_nr_maps = F_nr_scales*F_nr_orientations;
D = zeros(size(positions,2),F_nr_scales*F_nr_orientations*nr_pooling_cells);
%step through keypoint positions
for i = 1:size(positions,2)
    C = pooling_cells{n(i)};
    %extract local patch
    pos = positions(:,i);
    dims = [floor(pos(1)+1-scales(i)/2) floor(pos(1)+scales(i)/2) floor(pos(2)+1-scales(i)/2) floor(pos(2)+scales(i)/2)];
    patch = (F(dims(1):dims(2),dims(3):dims(4),:,:));
    ind=1;
    for j = 1:length(C)
        %spatial pooling of output 
        D_ = sum(sum(C{j}.*patch,1),2);
        %concatenate it to feature vector
        D(i,ind:ind+F_nr_maps-1)=D_(:);
        ind = ind+F_nr_maps;
    end
    %normalize feature vector to account for different scales
    %D(i,:) = D(i,:)/norm(D(i,:));
end

