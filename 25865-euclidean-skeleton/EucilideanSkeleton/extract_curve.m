function curve = extract_curve(BW,Gap_size)

%   effect: Function to extract curves from binary edge map, if the endpoint of a
%   contour is nearly connected to another endpoint, fill the gap and continue
%   the extraction. The default gap size is 1 pixles.
%Inputs:
%       BW: the binary image to process.
%       Gap_size: gap_size between the pixels of the contour
%Outputs:
%       curve: the contour constructed by pixels of counter-clock-wise
%       order
%Composed by Su Dongcai on 2009/11/13

[L,W]=size(BW);
BW1=zeros(L+2*Gap_size,W+2*Gap_size);
BW_edge=zeros(L,W);
BW1(Gap_size+1:Gap_size+L,Gap_size+1:Gap_size+W)=BW;
grainNoise=3;
bw_kernel=imfill(BW1, 'holes');
bw_kernel_dist=bwdist(~bw_kernel);
bw_kernel=bw_kernel_dist>=grainNoise;
%extract the maximum region
if sum(bw_kernel)<10
    curve=[];
    return;
end

L=bwlabel(bw_kernel);
status=regionprops( L, 'Area');
[tmp, max_idx]=max([status.Area]);
bw_kernel=(L==max_idx);

bw_kernel_dist=bwdist(bw_kernel);
BW1=bw_kernel_dist<=grainNoise;
BW1=bwperim(BW1);
%debuge
%imshow(BW1), hold on;
[r,c]=find(BW1==1);
nPerimPixels=sum(BW1(:));
point=[r(1),c(1)];
cur=point;

while nPerimPixels>0
    BW1(point(1),point(2))=0;
    nr_point=[point(1)-Gap_size : point(1)+Gap_size];
    nc_point=[point(2)-Gap_size : point(2)+Gap_size];
    n_point=BW1(nr_point, nc_point);
    [I,J]=find(n_point==1);
    if numel(I)==0
        break;
    end
    distanceList=zeros(1, length(I));
    for i=1:length(distanceList)
        distanceList(i)=norm([I(i), J(i)]-[Gap_size, Gap_size]);
    end
    [tmp, min_idx]=min(distanceList);
    point(1)=I(min_idx)-Gap_size+point(1)-1;
    point(2)=J(min_idx)-Gap_size+point(2)-1;
 
    cur=[cur;point];
    nPerimPixels=nPerimPixels-1;
    
end
%debug
%plot(cur(:, 2), cur(:, 1)), hold off;
curve = cur-1;
