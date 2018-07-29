%%  Performing Gaussian blur
%   I: input image
%   s: standard deviation
%   GI: blurred image

function GI = gaussianBlur(I,s)

M = gaussianMask(1,s);
if max(size(M))==0
    GI=I;
    return;
end
M = M/sum(sum(M));   % normalize the gaussian mask
GI=I;
for i=1:(2*s+1)
    GI=BoundMirrorExpand(GI);
end
GI = conv2(GI,M,'same');
for i=1:(2*s+1)
    GI=BoundMirrorShrink(GI);
end
