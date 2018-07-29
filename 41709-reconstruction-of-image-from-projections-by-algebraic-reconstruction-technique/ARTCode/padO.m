%Pad The Original Image
function [r,c,padIMG]=padO(img)
[iLength,iWidth]=size(img);
iDiag=sqrt(iLength^2 + iWidth^2);
LengthPad=ceil(iDiag - iLength) + 2;
WidthPad=ceil(iDiag - iWidth) + 2;
padIMG = zeros(iLength+LengthPad, iWidth+WidthPad);
%figure,imshow(padIMG);
padIMG(ceil(LengthPad/2):(ceil(LengthPad/2)+iLength-1), ...
       ceil(WidthPad/2):(ceil(WidthPad/2)+iWidth-1)) = img;
%Size of Original padIMG
   [r,c]=size(padIMG);
end