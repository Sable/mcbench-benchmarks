% This script demonstrates the influence of range reduction algorithm
% at low bitrate encoding using JPEG encode. The range [0-255] of pixel
% values is mapped to [64-235] in this script using a look-up-table.
% Subsequently, the file is compressed to achieve the same bit-rate
% (file size) as that of the compressed full range image. (The quality
% factor chosen may need adjustment if changing the input image.)
% The compressed files are uncompressed for quality comparison.
% In case of range reduction, the range is restored back on uncompression.
% SSIM is used for quality metrics.
%
% Author: Fitzgerald J Archibald
% Date: 31-Oct-09

% read input
Xin = imread('peppers.png');
% compression (high compression ratio)
imwrite(Xin,'Xin.jpg','jpg','Quality',7);
% uncompress
XinLoss=imread('Xin.jpg');

% LUT for mapping [0-255] to [64:235] range
LUT=uint8([64:(235-64)/255:235]);
% Range reduction (many to one mapping)
XlowRange=LUT(Xin+1);
% lossy compression after range reduction (achieve same size as compression
% before range reduction using higher quality factor)
imwrite(XlowRange,'XlowRange.jpg','jpg','Quality',10);
% uncompress
XlowRangeCompr=imread('XlowRange.jpg');
% Range restoration (inverse of range reduction)
XlowRangeLoss=uint8(zeros(size(Xin)));
XlowRangeLoss(find(XlowRangeCompr<=LUT(1)))=0;
XlowRangeLoss(find(XlowRangeCompr>=LUT(256)))=255;
for ix=256:-1:1,
    XlowRangeLoss(find(XlowRangeCompr==LUT(ix)))=ix-1;
end

% Display images (verify visual quality)
figure(1);
imshow([Xin,XinLoss,XlowRangeLoss]);
title('input                                           full range                                        range reduced');

% Quality metrics comparison
[mssim, ssim_map] = ssim_index(Xin(:,:,1), XinLoss(:,:,1));
disp(['Full range MMSIM=' num2str(mssim)]);
figure(2);
imshow(ssim_map,[])
title('SSIM map: Full range');

[mssim, ssim_map] = ssim_index(Xin(:,:,1), XlowRangeLoss(:,:,1));
disp(['Range reduction MMSIM=' num2str(mssim)]);
figure(3);
imshow(ssim_map,[])
title('SSIM map: Range reduction');
