%Implementation of:
%   Extension of Phase Correlation to Subpixel Registration
%   (Hassan Foroosh, Josiane B. Zerubia, Marc Berthod)
%Implemented by:
%   Lulu Ardiansyah (halluvme@gmail.com)
%
%TODO:
%   - Find out whether this implementation is correct :)
%   - Combine the result, overlay the images based on the result
%
%                                               eL-ardiansyah
%                                               January, 2010
%                                                       CMIIW
%============================================================
function [deltaX , deltaY] = ExtPhaseCorrelation(img1, img2)
%Description:
%   Find the translation shift between two image
%
%Parameter:
%   img1 = image 1
%   img2 = image 2
%   image 1 and image 2 , must in the same size

%Phase correlation (Kuglin & Hines, 1975)
%============================================================
af = fftn(double(img1));
bf = fftn(double(img2));
cp = af .* conj(bf) ./ abs(af .* conj(bf));
icp = (ifft2(cp));
mmax = max(max(icp));

%Find the main peak
[x,y,v] = find(mmax == icp);
%figure; imshow(icp,[],'notruesize');

%Extension to Subpixel Registration [Foroosh, Zerubia & Berthod, 2002]
%============================================================
[M, N] = size(img1);

%two side-peaks
xsp = x + 1;
xsn = x - 1;
ysp = y + 1;
ysn = y - 1;

%if the peaks outsize the image, then use xsn and/or ysn for the two
%side-peaks
if xsp > M
    xsp = M-1;
end
if ysp > N
    ysp = N-1;
end

%Calculate the translational shift
deltaX1 = ((icp(xsp,y) * xsp + icp(x,y) * x) / (icp(xsp,y) + icp(x,y)))-1;
deltaY1 = ((icp(x,ysp) * ysp + icp(x,y) * y) / (icp(x,ysp) + icp(x,y)))-1;

%I don't know why but after few test i find out that the result of deltaX
%and delta Y is inverted.. :( ??

%Validate if translation shift is negative
if deltaX1 < (N/2)
    deltaY = deltaX1;
else
    deltaY = deltaX1 - M;
end

if deltaY1 < (M/2)
    deltaX = deltaY1;
else
    deltaX = deltaY1 - N;
end