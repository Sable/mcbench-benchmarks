%Pad The Guessed Image
function [r,c,padGIMG]=padG(img)
[iLength,iWidth]=size(img);
iDiag=sqrt(iLength^2 + iWidth^2);
LengthPad=ceil(iDiag - iLength) + 2;
WidthPad=ceil(iDiag - iWidth) + 2;
padGIMG = zeros(iLength+LengthPad, iWidth+WidthPad);
%figure,imshow(padGIMG);
padGIMG(ceil(LengthPad/2):(ceil(LengthPad/2)+iLength-1), ...
       ceil(WidthPad/2):(ceil(WidthPad/2)+iWidth-1)) = img;
%Size of Guessed padGIMG
   [r,c]=size(padGIMG);   
end