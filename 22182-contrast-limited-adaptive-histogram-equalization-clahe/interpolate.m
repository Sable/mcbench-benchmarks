function [subImage] = interpolate(subBin,LU,RU,LB,RB,XSize,YSize)
%  pImage      - pointer to input/output image
%  uiXRes      - resolution of image in x-direction
%  pulMap*     - mappings of greylevels from histograms
%  uiXSize     - uiXSize of image submatrix
%  uiYSize     - uiYSize of image submatrix
%  pLUT	       - lookup table containing mapping greyvalues to bins
%  This function calculates the new greylevel assignments of pixels within a submatrix
%  of the image with size uiXSize and uiYSize. This is done by a bilinear interpolation
%  between four different mappings in order to eliminate boundary artifacts.
%  It uses a division; since division is often an expensive operation, I added code to
%  perform a logical shift instead when feasible.
% 
 
subImage = zeros(size(subBin));
num = XSize * YSize;
for i = 0:XSize-1
    inverseI = XSize - i;
    for j = 0:YSize-1
        inverseJ = YSize - j;
        val = subBin(i+1,j+1);
        subImage(i+1,j+1) = fix((inverseI*(inverseJ*LU(val) + j*RU(val)) ...
             + i*(inverseJ*LB(val) + j*RB(val)))/num);
    end
end

