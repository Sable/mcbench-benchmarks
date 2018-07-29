function mSegmentImg = HillClimbingSegment(sImgPath,iBinNum)
%Hill-Climbing Algorithm for Color Image Segmentation.
%   IDX = KMEANS(X, K) partitions the points in the N-by-P data matrix
%   X into K clusters.  This partition minimizes the sum, over all
%   clusters, of the within-cluster sums of point-to-cluster-centroid
%   distances.  Rows of X correspond to points, columns correspond to
%   variables.  KMEANS returns an N-by-1 vector IDX containing the
%   cluster indices of each point.  By default, KMEANS uses squared
%   Euclidean distances.
%
%   mSegmentImg = HillClimbingSegment(sImgPath,iBinNum)
%
%   Input Parameters:
%       sImgPath        -    the directory path of the input image
%       iBinNum         -    the number of histogram bins in each dimension
%   
%   Output Parameters:
%       mSegmentImg     -    the label image where each pixel is the
%                            cluster label it belongs to
%
%
%   Example:
%       mSegmentImg = HillClimbingSegment('./test.jpg',10);
%
%   See also RGB2Lab, kmeans.
%
% References:
%
%   [1] T.Ohashi, Z.Aghbari, and A.Makinouchi. Hill-climbing Algorithm for 
%       Efficient Color-based Image Segmentation. In IASTED International 
%       Conference On Signal Processing, Pattern Recognition, and 
%       Applications (SPPRA 2003), June 2003.
%   [2] R. Achanta, F. Estrada, P. Wils, and S. SÄusstrun. Salient Region
%       Detection and Segmentation. In International Conference on Computer
%       Vision Systems (ICVS 2008), May 2008.

%   Copyright 2008 Yiqun Hu.
%   $Revision: 1.0 $  $Date: 2008/11/29$

% Conversion from RGB to CIE Lab
fprintf('Converting input image from RGB to CIE Lab ... ');
img = imread(sImgPath);
R = reshape(double(img(:,:,1)),[size(img,1),size(img,2)]);
G = reshape(double(img(:,:,2)),[size(img,1),size(img,2)]);
B = reshape(double(img(:,:,3)),[size(img,1),size(img,2)]);
[L,a,b] = RGB2Lab(R,G,B);
fprintf('done\n');

% Build 3D color histogram
fprintf('Generate CIE Lab Color Histogram ... ');
[LabHist,histCenters] = Build3DColorHistogram(L(:),a(:),b(:),iBinNum);
fprintf('done\n');

% Search for histogram peak
fprintf('Searching the initial seeds from color histogram ... \n');
vSeed = SearchLocalMaximum(LabHist);
fprintf('Obtain %d initial seeds for K-means clustering ... \n',length(vSeed));

fprintf('Applying K-means clustering  ... \n');
data = [L(:),a(:),b(:)];

[IDX,C] = kmeans(data,length(vSeed),'start',histCenters(vSeed,:),'emptyaction','drop');
fprintf('done\n');

% Display segmentation result
mSegmentImg = reshape(IDX,[size(img,1),size(img,2)]);
figure(1);
subplot(1,2,1),imshow(img);
subplot(1,2,2),imshow(label2rgb(mSegmentImg));

function [vColorHist,histCenters] = Build3DColorHistogram(vChannel1,vChannel2,vChannel3,iBinNum)
% Generate 3D color histogram from 3 channels

[Chist1,Cbin1] = hist(vChannel1(:),iBinNum);
[Cdist1,Cidx1] = min(abs(repmat(vChannel1(:),[1,iBinNum])-repmat(Cbin1,[length(vChannel1(:)),1])),[],2);
[Chist2,Cbin2] = hist(vChannel2(:),iBinNum);
[Cdist2,Cidx2] = min(abs(repmat(vChannel2(:),[1,iBinNum])-repmat(Cbin2,[length(vChannel2(:)),1])),[],2);
[Chist3,Cbin3] = hist(vChannel3(:),iBinNum);
[Cdist3,Cidx3] = min(abs(repmat(vChannel3(:),[1,iBinNum])-repmat(Cbin3,[length(vChannel3(:)),1])),[],2);

ind = sub2ind([iBinNum,iBinNum,iBinNum],Cidx1,Cidx2,Cidx3);
vColorHist = zeros(iBinNum,iBinNum,iBinNum);
for i = 1:iBinNum^3
    vColorHist(i) = sum(ind==i);
end

histCenters = [repmat(Cbin1(:),[size(vColorHist,2)*size(vColorHist,3),1]),...
               repmat(Cbin2(:),[size(vColorHist,1)*size(vColorHist,3),1]),...
               repmat(Cbin3(:),[size(vColorHist,1)*size(vColorHist,2),1])];

return;

function vSeed = SearchLocalMaximum(dataHist)
%

iBinNum = 1;
for i = 1:length(size(dataHist))
    iBinNum = iBinNum*size(dataHist,i);
end

vSeed = [];
for i = 1:iBinNum
    vNBins = CalcNeighborBins(size(dataHist),i);
    if (sum((dataHist(i)-dataHist(vNBins))>0)==length(vNBins))
        vSeed = [vSeed;i];
    end
end

return;

function vNBins = CalcNeighborBins(HistSize,iBin)
% 

[I1,I2,I3] = ind2sub(HistSize,iBin);

vBin1 = []; vBin2 = []; vBin3 = [];
for k = I3-1:I3+1
    for i = I1-1:I1+1
        for j = I2-1:I2+1
            if ((i~=I1 | j~=I2 | k~=I3) & ...
                ((i>0&i<=HistSize(1)) & (j>0&j<=HistSize(2)) & (k>0&k<=HistSize(3))))
                vBin1 = [vBin1;i];
                vBin2 = [vBin2;j];
                vBin3 = [vBin3;k];
            end
        end % end for j
    end % end for i
end % end for k

vNBins = sub2ind(HistSize,vBin1,vBin2,vBin3);

return;