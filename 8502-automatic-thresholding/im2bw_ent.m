function BW = im2bw_ent(IM)
% This fucntion convert an intensity image to a binary image
% by using Entropy-based method
%
% Usage: BW = im2bw_ent(IM)
% Input: IM -> Input Image
% Output: BW -> Segmented Image
%
% Example:
% IM = imread('house.jpg');
% BW = im2bw_ent(IM);
% imagesc(BW)
%
% Reference: E.R.Davies Machine Vision 3rd Edition

% size of input image
dim = size(IM);
% Change input image to gray scale
leng = length(dim);
if leng == 3
    IM = rgb2gray(IM);
end

% histgram of input image
ihis = imhist(IM);

leng = length(ihis);
para = zeros(1,leng);
for k = 2:leng-1
    % intensity of class A
    classa = ihis(1:k);
    ind = (classa==0);
    classa = classa+ind;
    clear ind
    % intensity of class B
    classb = ihis(k+1:end);
    ind = (classb==0);
    classb = classb+ind;
    clear ind
    % probability distribution of class A
    Pa = classa/(dim(1,1)*dim(1,2));
    % probability distribution of class B
    Pb = classb/(dim(1,1)*dim(1,2));
    % parameters to decide threshold
    para1 = log2(sum(Pa));
    para2 = log2(sum(Pb));
    logpa = log2(Pa);
    logpb = log2(Pb);
    para3 = -sum(Pa.*logpa)/sum(Pa);
    para4 = -sum(Pb.*logpb)/sum(Pb);
    % parameter which has to be maximized
    para(1,k) = abs(para1+para2+para3+para4);
    clear classa classb logpa logpb
end

% find threshold
[maxv,row] = max(para);
thresh = row-1;
% segment input image
BW = (IM>=thresh);