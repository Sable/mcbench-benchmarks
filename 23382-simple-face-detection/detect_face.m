% by Tolga Birdal
% Implementation of the paper:
% "A simple and accurate face detection algorithm in complex background"
% by Yu-Tang Pai, Shanq-Jang Ruan, Mon-Chau Shie, Yi-Chi Liu

% Additions by me:
%  Minumum face size constraint
%  Adaptive theta thresholding (Theta is thresholded by mean2(theata)/4
%  Parameters are modified by to detect better. Please check the paper for
%  parameters they propose.
% Check the paper for more details.

% usage:
%  I=double(imread('c:\Data\girl1.jpg'));
%  detect_face(I);
% The function will display the bounding box if a face is found.

% Notes: This algorithm is very primitive and doesn't work in real life.
% The resaon why I implement is that I believe for low cost platforms
% people need such kind of algorithms. However this one doesn't perform so
% well in my opinion (if I implemented correctly)

function []=detect_face(I)

close all;

% No faces at the beginning
Faces=[];
numFaceFound=0;

I=double(I);

H=size(I,1);
W=size(I,2);
R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);

%%%%%%%%%%%%%%%%%% LIGHTING COMPENSATION %%%%%%%%%%%%%%%
YCbCr=rgb2ycbcr(I);
Y=YCbCr(:,:,1);

%normalize Y
minY=min(min(Y));
maxY=max(max(Y));
Y=255.0*(Y-minY)./(maxY-minY);
YEye=Y;
Yavg=sum(sum(Y))/(W*H);

T=1;
if (Yavg<64)
    T=1.4;
elseif (Yavg>192)
    T=0.6;
end

if (T~=1)
    RI=R.^T;
    GI=G.^T;
else
    RI=R;
    GI=G;
end

C=zeros(H,W,3);
C(:,:,1)=RI;
C(:,:,2)=GI;
C(:,:,3)=B;

figure,imshow(C/255);
title('Lighting compensation');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%% EXTRACT SKIN %%%%%%%%%%%%%%%%%%%%%%
YCbCr=rgb2ycbcr(C);
Cr=YCbCr(:,:,3);

S=zeros(H,W);
[SkinIndexRow,SkinIndexCol] =find(10<Cr & Cr<45);
for i=1:length(SkinIndexRow)
    S(SkinIndexRow(i),SkinIndexCol(i))=1;
end

figure,imshow(S);
title('skin');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%% REMOVE NOISE %%%%%%%%%%%%%%%%%%%%%%%%%%%%
SN=zeros(H,W);
for i=1:H-5
    for j=1:W-5
        localSum=sum(sum(S(i:i+4, j:j+4)));
        SN(i:i+5, j:j+5)=(localSum>12);
    end
end

figure,imshow(SN);
title('skin with noise removal');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%% FIND SKIN COLOR BLOCKS %%%%%%%%%%%%%%%%%

L = bwlabel(SN,8);
BB  = regionprops(L, 'BoundingBox');
bboxes= cat(1, BB.BoundingBox);
widths=bboxes(:,3);
heights=bboxes(:,4);
hByW=heights./widths;

lenRegions=size(bboxes,1);
foundFaces=zeros(1,lenRegions);

rgb=label2rgb(L);
figure,imshow(rgb);
title('face candidates');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%% CHECK FACE CRITERIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:lenRegions
    
    % 1st criteria: height to width ratio, computed above.
    if (hByW(i)>1.75 || hByW(i)<0.75)
        % this cannot be a mouth region. discard
        continue;
    end
    
    % implemented by me: Impose a min face dimension constraint
    if (heights(i)<20 && widths(i)<20)
        continue;
    end
    
    % get current region's bounding box
    CurBB=bboxes(i,:);
    XStart=CurBB(1);
    YStart=CurBB(2);
    WCur=CurBB(3);
    HCur=CurBB(4);
    
    % crop current region
    rangeY=int32(YStart):int32(YStart+HCur-1);
    rangeX= int32(XStart):int32(XStart+WCur-1);
    RIC=RI(rangeY, rangeX);
    GIC=GI(rangeY, rangeX);
    BC=B(rangeY, rangeX);
    
    figure, imshow(RIC/255);
    title('Possible face R channel');
    
    % 2nd criteria: existance & localisation of mouth
    
    M=zeros(HCur, WCur);
    
    theta=acos( 0.5.*(2.*RIC-GIC-BC) ./ sqrt( (RIC-GIC).*(RIC-GIC) + (RIC-BC).*(GIC-BC) ) );
    theta(isnan(theta))=0;
    thetaMean=mean2(theta);
    [MouthIndexRow,MouthIndexCol] =find(theta<thetaMean/4);
    for j=1:length(MouthIndexRow)
        M(MouthIndexRow(j),MouthIndexCol(j))=1;
    end
    
    % now compute vertical mouth histogram
    Hist=zeros(1, HCur);
    
    for j=1:HCur
        Hist(j)=length(find(M(j,:)==1));
    end
    
    wMax=find(Hist==max(Hist));
    wMax=wMax(1); % just take one of them.
    
    if (wMax < WCur/6)
        %reject due to not existing mouth
        continue;
    end
    
    figure, imshow(M);
    title('Mouth map');
    
    % 3rd criteria: existance & localisation of eyes
    
    eyeH=HCur-wMax;
    eyeW=WCur;
    
    YC=YEye(YStart:YStart+eyeH-1, XStart:XStart+eyeW-1);
    
    E=zeros(eyeH,eyeW);
    [EyeIndexRow,EyeIndexCol] =find(65<YC & YC<80);
    for j=1:length(EyeIndexRow)
        E(EyeIndexRow(j),EyeIndexCol(j))=1;
    end
    
    % check if eyes are acceptable.
    EyeExist=find(Hist>0.3*wMax);
    if (~(length(EyeExist)>0))
        continue;
    end
    
    foundFaces(i)=1;
    numFaceFound=numFaceFound+1;
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Number of faces found');
numFaceFound;

if (numFaceFound>0)
    disp('Indices of faces found: ');
    ind=find(foundFaces==1);
    CurBB=bboxes(ind,:);
    CurBB
else
    close all;
end

end
