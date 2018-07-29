function [im_out,OA]=exact_histogram(varargin)
% Specify exact image histogram.
%
%   SYNTAX:
%       - [im_out,OA]=exact_histogram(im) specifies exactly uniform 
%       histogram for gray scale image IM.
%       - [im_out,OA]=exact_histogram(im,H) remaps gray values of image IM 
%       so that new image histogram has the form of specified histogram H.
%       - [im_out,OA]=exact_histogram(im,H,bw) only adjust pixel 
%       intensities in the foreground specified by the binary image BW. To
%       do equalization define H as as an empty array [].
%
%   INPUT:
%       - IM is an 8-bit or 16-bit gray scale image.
%       - H is a specified histogram. H is vector of length L where L is
%       the maximum number of pixel intensities. For examle L=256 for an 
%       8-bit image.
%       - BW is binary image of same dimensions as IM. Only image pixels 
%       marked by the foreground (white) regions will be processed.
%
%   OUTPUT:
%       - IM_OUT is the processed image with equalized or specified
%       histogram. 
%       - OA is a number in the range 0 and 1. It indicates the fraction of
%       unique filter response combinations used to assign order to image
%       pixels. If OA=1 then order is strict. Note that OA is computed for
%       the entire image. 
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

if nargin==0 || nargin>3
    err='Incorrect number of input arguments.';
    error(err)
end

% Get image, check format and get other image info
%--------------------------------------------------------------------------
im=varargin{1};
TypeList={'uint8','uint16'};
Type=class(im);
idx_class=strcmpi(Type,TypeList);

if isempty(find(idx_class,1))
    err='Acceptable data formats for the input image are 8-bit and 16-bit.';
    error(err)
end

% Maximum number of gray levels
if find(idx_class,1)==1
    L=2^8;
else
    L=2^16;
end

% Image dimensions
M=size(im,1); N=size(im,2); P=size(im,3);
if P~=1
    err='Input image can only have one channel.';
    error(err)
end

% Get histogram and check format
%--------------------------------------------------------------------------
if nargin>1
    H=varargin{2};
    H=H(:)';
else
    H=[];
end

if isempty(H)
    H=ones(1,L)/L;
elseif islogical(H)
    err='Incorrect syntax. Proper syntax is histogram_exact(im,H,bw). Set H=[] to equalize region under the binary mask.';
    error(err)
elseif numel(H)~=L
    err='Number of histogram bins must correspond to the maximum number of gray levels in the image.';
    error(err)
end

% Get binary image mask
%--------------------------------------------------------------------------
chk_mask=false;
if nargin==3
    bw=varargin{3};
    chk_mask=true;
    if size(bw,1)~=M || size(bw,2)~=N
        err='Dimensions of the binary mask must equal dimensions of the image';
        error(err)
    elseif numel(find(bw))<50
        err='Too small a number of foreground pixels in the binary mask.';
        error(err)
    end
end
clear varargin

%__________________________________________________________________________
% MAIN BODY OF THE FUNCTION
%__________________________________________________________________________

% Assign strict order to pixels
[im_sort,OA]=pixel_order(im);

Ntotal=M*N; % total number of image pixels

% If binary mask is given only sort pixels under the mask, set values to 0
% outside the mask
if chk_mask
    Ntotal=numel(find(bw)); % total number of foreground pixels
    
    pix_ord=im_sort(bw); % pixel order values under the mask
    idx_o=[1:Ntotal]'; % original pixel positions under the mask
    im_sort(~bw)=0;
    
    [pix_ord,idx]=sort(pix_ord,'ascend');
    idx_o=idx_o(idx); % original pixel position sorted according to pixel order
    clear pix_ord & idx
    [idx_o,idx]=sort(idx_o,'ascend'); % pixel order sorted according to position under the mask
    clear idx_o
    im_sort(bw)=idx;
    clear idx
end

% Adjust the specified histogram to match the number of image/foreground pixels 
%--------------------------------------------------------------------------
H=Ntotal*H/(sum(H)); % renormalized histogram
H_whole=floor(H);
H_resid=H-H_whole;

R=Ntotal-sum(H_whole); % frequency residuals

% Redistribute residuals according to their magnitude
[H_resid,idx]=sort(H_resid,'descend');
H_whole(idx(1:R))=H_whole(idx(1:R))+1;
H=H_whole;
clear H_whole & H_resid & R

% Convert the histogram to raw intensity samples
Hraw=zeros(1,Ntotal);
idx=cumsum(H);
for i=1:L
    if i==1
        Hraw(1:idx(i))=i-1;
    else
        Hraw(idx(i-1)+1:idx(i))=i-1;
    end
end
clear H

if chk_mask
    Hraw=[zeros(1,M*N-Ntotal),Hraw];
end

% Specify histogram
%--------------------------------------------------------------------------
% Rearange image pixels according to pixel order
im_sort=reshape(im_sort,M*N,1);
[im_sort,idx_o]=sort(im_sort,'ascend');
clear im_sort

% Rearange intensities according to image position
[idx_o,idx]=sort(idx_o,'ascend');
clear idx_o
Hraw=Hraw(idx);
clear idx

% Reassemle the image
Hraw=reshape(Hraw,M,N);

if chk_mask
    im(bw)=0;
    if find(idx_class)==1
        Hraw=im+uint8(Hraw);
    else
        Hraw=im+uint16(Hraw);
    end
else
	if find(idx_class)==1
        Hraw=uint8(Hraw);
    else
        Hraw=uint16(Hraw);
    end
end
clear im
im_out=Hraw;

