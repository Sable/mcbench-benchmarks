function [aa,SN_fill,FaceDat]=detect_face(I)

close all;

% No faces at the beginning
Faces=[];
numFaceFound=0;

I=double(I);

H=size(I,1);
W=size(I,2);

%%%%%%%%%%%%%%%%%% LIGHTING COMPENSATION %%%%%%%%%%%%%%%

C=255*imadjust(I/255,[0.3;1],[0;1]);

% figure,imshow(C/255);
% title('Lighting compensation');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%% EXTRACT SKIN %%%%%%%%%%%%%%%%%%%%%%
YCbCr=rgb2ycbcr(C);
Cr=YCbCr(:,:,3);

S=zeros(H,W);
[SkinIndexRow,SkinIndexCol] =find(10<Cr & Cr<255);
for i=1:length(SkinIndexRow)
    S(SkinIndexRow(i),SkinIndexCol(i))=1;
end

m_S = size(S);
S(m_S(1)-7:m_S(1),:) = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%% REMOVE NOISE %%%%
% figure;imshow(S);

SN=zeros(H,W);
for i=1:H-5
    for j=1:W-5
        localSum=sum(sum(S(i:i+4, j:j+4)));
        SN(i:i+5, j:j+5)=(localSum>20);
    end
end

%     figure;imshow(SN);
    
 Iedge=edge(uint8(SN));
 
%  figure;imshow(Iedge);
 
SE = strel('square',9);
SN_edge = (imdilate(Iedge,SE));


% 
% SN_edge =  SN_edge1.*SN;
 
%  figure;imshow(SN_edge);
 
 SN_fill = imfill(SN_edge,'holes');
%  figure;imshow(SN_fill);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%% FIND SKIN COLOR BLOCKS %%%%

[L,lenRegions] = bwlabel(SN_fill,4);
AllDat  = regionprops(L,'BoundingBox','FilledArea');
AreaDat = cat(1, AllDat.FilledArea);
[maxArea, maxAreaInd] = max(AreaDat);

FaceDat = AllDat(maxAreaInd);
FaceBB = [FaceDat.BoundingBox(1),FaceDat.BoundingBox(2),...
    FaceDat.BoundingBox(3)-1,FaceDat.BoundingBox(4)-1];

aa=imcrop(rgb2gray(uint8(I)).*uint8(SN_fill),FaceBB);

%  figure,imshow(aa);
%  title('Identified Face');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
