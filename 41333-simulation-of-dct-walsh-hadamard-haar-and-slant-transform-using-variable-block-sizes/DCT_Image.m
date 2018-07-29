clc;
clear all;
close all;
A=imread('cameraman.tif');
figure,imshow(uint8(A))
title('Original Image');
A=double(A);
[s1 s2]=size(A);
bs=16;

% DCT
temp=double(zeros(size(A)));
for y=1:bs:s1-bs+1
    for x=1:bs:s2-bs+1
        croppedImage = A((y:y+bs-1),(x:x+bs-1));
        t=getDCTTransform(croppedImage,bs);
        temp((y:y+bs-1),(x:x+bs-1))=t;
    end
end
figure,imshow(uint8(temp))

%  Inverse DCT
temp1=double(zeros(size(A)));
for y=1:bs:s1-bs+1
    for x=1:bs:s2-bs+1
        croppedImage = temp((y:y+bs-1),(x:x+bs-1));
        t=getInvDCTTransform(croppedImage,bs);
        temp1((y:y+bs-1),(x:x+bs-1))=t;
    end
end
figure,imshow(uint8(temp1))