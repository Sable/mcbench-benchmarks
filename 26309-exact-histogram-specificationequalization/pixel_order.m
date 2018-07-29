function [im_sort,OA]=pixel_order(im)
% Assign strict ordering to image pixels. 
%
%   INPUT:
%       - IM is a monochromatic or multispectral image.
%
%   OUPUT:
%       - IM_SORT is an array that has the same dimensions as IM. Its 
%       element entries correspond to the order of the grey level pixel in
%       that position. Note that the channels of multispectral images are 
%       processed speparately.
%       - OA is a number in the range [0,1] and idicates the fraction of
%       unique filter response combinations (ie. order accuracy). If OA=1 
%       the ordering is strict. For multichannel images OA is a vector 
%       whose elements are the OAs of the corresponding image channels.
%
%   REFERENCES:
%       1. Coltuc D. and Bolon P., 1999, "Strict ordering on discrete images 
%       and applications"
%       2. Coltuc D., Bolon P. and Chassery J-M., 2006, "Exact histogram 
%       specification", IEEE Transcations on Image Processing
%       15(5):1143-1152
%
%   AUTHOR: Anton Semechko (asemechk@uoguelph.ca)
%   DATE:   Dec.2009

if nargin<1 || nargin>1
    err='Incorrect number of input arguments';
    error(err)
end

% Image dimensions
M=size(im,1);
N=size(im,2);
P=size(im,3);

% Filters
F2=(1/5)*[0 1 0; 1 1 1; 0 1 0];
F3=(1/9)*ones(3,3);
F4=(1/13)*ones(5,5); F4([1 2 4 5 6 10 16 20 21 22 24 25])=0;
F5=(1/21)*ones(5,5); F5([1,5,21,25])=0;
F6=(1/25)*ones(5,5);
F={F2 F3 F4 F5 F6};

% Convolve filters with the image (one channel at a time) and order
%--------------------------------------------------------------------------
im_sort=[];
OA=[];
    
for i=1:P
    FR=double(im(:,:,1));
    for j=1:5
        FR_j=imfilter(double(im(:,:,1)),F{j});
        FR=cat(3,FR,FR_j);
        clear FR_j
    end
    im(:,:,1)=[]; % free up some memory
    
    % Rearange the filter responses
    FR=reshape(FR,M*N,6);
    
    % Number of unique filter responses and ordering accuracy
    n=size(unique(FR,'rows'),1);
    OA=[OA,n/(M*N)];
    
    % Sort responses lexicographically
    [FR,idx_pos]=sortrows(FR);
    clear FR
    
    % idx_pos is pixel position sorted according to ascending pixel order
    % now sort ordered pixels according to pixel position (linear index)
    [idx_pos,idx_o]=sort(idx_pos,'ascend');
    clear idx_pos
    idx_o=reshape(idx_o,M,N);
    
    im_sort=cat(3,im_sort,idx_o);
    clear idx_o
end

