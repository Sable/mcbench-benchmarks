function [Segmented, Array]=DS(Im,flag,open,EdHist)

%  This function applies the Delaunay-based image segmentation,
%  which is a fully automated process that does not require initial
%  estimate of number of clusters.
%
%  The core idea is to apply Delaunay triangulation to the image 
%  histogram instead of the image itself. That reduces the sites required 
%  to construct the diagram to merely 255 at most (uint8) resulting in a 
%  fast image segmentation.
%
%  I don't claim it is the optimum way to segment an image, which is why
%  I will be more than happy receiving constructive comments or reporting
%  any bug in the program.
%
%  For further description of the theoritical foundation of the algorithm 
%  and for citation purposes please refer to my journal paper:
%
%  - A. Cheddad, D. Mohamad and A. Abd Manaf, "Exploiting Voronoi diagram
%  properties in face segmentation and features extraction," Pattern
%  Recognition, 41 (12)(2008)3842-3859, Elsevier Science.
% 
% 
% Inputs,
%   Im : The image, class preferable uint8 or uint16, the function accepts
%   RGB as well as grayscale images
%
%   flag : (1) segmentation of image complement 
%          (0) direct segmentation [default]
%
%   open:  (1) apply grayscale morphological opening 
%          (0) don't apply [default]
%   EdHist:(1) apply histogram equalization [default]
%          (0) don't apply 
%
% Outputs,
%   Segmented: the segmented image
%   Array: Array containing grayscale values (Delaunay vertices) used for
%   segmentation. You can use that to call homogeneous regions,
%   e.g., imshow(Segmented(:,:,1)<=Array(i) & Segmented(:,:,1)>Array(i-1),[]);
%
% Example,
%   [Segmented, Array]=DS('Image.png'); with the default options
%   [Segmented, Array]=DS('Image.png',0,1,1);
%
% Function was written by Abbas Cheddad, University of Technology Malaysia (July 2005)
% Revised on 05-August- 2010 Umeå Universitet, Sweden
% 
% URL: www.abbascheddad.net
%      www.infm.ulst.ac.uk/~abbasc/ (might be obsolete end of 2010)
% 


% If you run into an error as below:
%
% (??? Error using ==> convhull
% Error computing the convex hull. The points may be collinear.)
%
% That is because the histogram did not yield enough scattered sites (collinearity) that 
% enable forming the Delaunay triangulation.
% Try re-setting the parameters.
% The segmentation ranges from coarse to fine, if the image has an abnormal
% histogram that might result in undersegmentation. 
%
if nargin < 2, flag=0;open=0;EdHist=1; end

tic
Im=imread(Im);


%%%%%%%%%%%%%%%%%%%%Pre-processing step%%%%%%%%%%%%%%%
if length(size(Im))==3
    %colour transform into NTSC coulour space allowing us to work on the 
    %intensity channel
   Im=rgb2ntsc(Im);
end

I2=im2uint8(Im(:,:,1));
Store=I2;

if open==1
 se=strel('square',4);
 I2=imopen(I2,se);
end

if flag==1
I2=imcomplement(I2);
end

if EdHist==1
I2=histeq(medfilt2(I2));
end
Orig=I2;


%%%%%%%%%%%%%%%%%%%%Getting segmentation values%%%%%%%%%%%%%%%

[x xx]=imhist(I2);
C=[x,xx];
%%%%%%
k=convhull(C(:,1),C(:,2));
X_conv=C(k,1);
Y_conv=C(k,2);


Maxim_C=max(C(:,1));
Max_Conv=max(X_conv(:,1));

%Getting the 1st maxima
[Point,m]=find(X_conv==Max_Conv);
Point_1=Y_conv(Point,1);

X_conv(Point,1)=0;

Max_Conv=max(X_conv(:,1));
%Getting the 2nd maxima
[Point,m]=find(X_conv==Max_Conv);
Point_2=Y_conv(Point);

C(1:min(Point_1,Point_2),1)=Maxim_C;
C(max(Point_1,Point_2):256,1)=Maxim_C;
C(:,1)=sqrt((C(:,1)-Maxim_C).^2);
Temp_C=C(k,2);
Temp_C=sort(Temp_C);

%%%%%%%%
%T=C(:,1);
f=convhull(C(:,1),C(:,2));
Arr=C(f,2);
Arr2=C(f,1);
[count,no]=find(C(f,1)~=0);
Array=Arr(count);
%%%%%%%%%%%%
Temp=C(f,1);
Temp2=C(f,2);
cell1=0;
cell2=0;
for i=1:length(Temp)
    if Temp(i,1)~=0
       cell1=Temp(i,1);
       i=length(Temp);
    end
end
for i=length(Temp):-1:1
    if Temp(i,1)~=0
        cell2=Temp(i,1);
        i=1;
    end
end
Max_C=max(C(:,1));

if (cell1>0 && cell2>0)
    
    
    Point_New=find(C(:,1)==cell1);
    Point_New=Point_New(1);
    Point_New2=find(C(:,1)==cell2);
    Point_New2=Point_New2(end);

C(1:Point_New,1)=Max_C;
C(Point_New2:length(C(:,1)),1)=Max_C;
C=C(1:256,:);
C(:,1)=sqrt((C(:,1)-Maxim_C).^2);
end



Array=[Array;Temp_C];

Array=sort(Array);
for i=1:length(Array(:))-1
    if Array(i)==Array(i+1)
        Array(i+1)=0;
    end
end
Array=sort(Array);
[D,n]=(find(Array>0));
Array=Array(D);


Orig(Orig<Array(1,1))=0;
Orig(Orig>Array(length(Array(:)),1))=0;
d=[];


%%%%%%%%%%%%%%%%%%%%Segmentation of the image%%%%%%%%%%%%%%%
for i=1:length(Array(:))-1
   
    if i==1
    Orig(Orig>=Array(i) & Orig<=Array(i+1))=Array(i+1);
    d=[d;Array(i+1)];
       else
    Orig(Orig>Array(i) & Orig<=Array(i+1))=Array(i+1);
    d=[d;Array(i+1)];
    end
    
  
end

d=sort(d);
Orig_Color=[];

if length(size(Im))==3
Im(:,:,1)=im2double(Orig);
Orig_Color=ntsc2rgb(Im);
[x xx]=imhist(im2uint8(Im(:,:,1)));
Array=xx(x>0);

else
    
[x xx]=imhist(im2uint8(Orig(:,:,1)));% Corrected!

Array=xx(x>0);

end

Segmented=im2uint8(Orig);

Time=toc;

% Calculating additional info, i.e., comparision of the number of 
% grayvalues before and after the segmentation


[x xx]=imhist(Store);
Count=xx(xx>0);

%%%%Display the segmented regions as binary
%if length(size(Segmented))==3
%Segmented=rgb2ntsc(Segmented);
%end
% Segmented=im2double(Segmented(:,:,1));
% [n nn]=hist(Segmented);
% for i=1:length(nn)
%     if i=1
%      figure, imshow(A(:,:,1)<=nn(i),[])
%     else
%      figure, imshow(A(:,:,1)<=nn(i) & A(:,:,1)>nn(i-1),[])
%     end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure, imshow(Segmented), title(sprintf('Delaunay based unsupervised segmentation, excusion time: %s Sec',num2str(Time)))
if  ~isempty(Orig_Color)
figure, imshow(Orig_Color),title(sprintf('Color Delaunay based unsupervised segmentation , excusion time: %s Sec',num2str(Time)));
imwrite(Orig_Color,'Segmented_Color.tif')
end
msgbox(sprintf('The number of gray values in the original was: %d which is reduced to: %d with the segmentation process.',length(Count),length(Array)),'Title','modal');