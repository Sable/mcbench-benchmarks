function [numPill, numBroken] = BlisterRead(RGB)
% This is a converted version of BlisterPackInspection.m
% Please see BlisterPackInspection.m for more comments

%% Perform K-means Clustering
cform = makecform('srgb2lab');
I_lab = applycform(RGB,cform);

ab = double(I_lab(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

nColors = 2;
[cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
    'Replicates',8);

% select cluster with least amount to find the pills
pixel_labels = reshape(cluster_idx,nrows,ncols);
if sum(pixel_labels(:)==1)>sum(pixel_labels(:)==2)
    clus_idx = 2;
else
    clus_idx = 1;
end

%% Blob Detection and Region Properties
% We detect blobs and their region properties to find broken tablets

I_bw = pixel_labels==clus_idx;

I_bw_closed = imclose(I_bw,strel('disk',10));
I_bw_corrected = bwlabel(I_bw_closed).*I_bw;

sol = regionprops(I_bw_corrected,'solidity');
area = regionprops(I_bw_corrected,'area');

% plotting routines
imshow(RGB);
hold on;

cen = regionprops(I_bw_corrected,'centroid');
coords = reshape([cen(:).Centroid],2,max(I_bw_corrected(:)))';

numBroken = 0;
numPill = 0;
for i = 1:max(I_bw_corrected(:))
    text(coords(i,1),coords(i,2), sprintf('%2.2f',sol(i).Solidity ) );
    if area(i).Area/max([area.Area]) > 0.2
        if sol(i).Solidity > 0.8
            plot(coords(i,1),coords(i,2),'og','MarkerSize',12,'LineWidth',2);
            numPill = numPill+1;
        elseif sol(i).Solidity <= 0.8
            plot(coords(i,1),coords(i,2),'xr','MarkerSize',12,'LineWidth',2);
            numBroken = numBroken+1;
            numPill = numPill+1;
        end
    end
end


