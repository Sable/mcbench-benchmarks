function [node, featurevec] = point_neighbors(bw, pt, R, seed, NeighborNum, labelmap);

% This function search the linked neighbor of the seed
% Node structure: seed, neighbor numbers, neigh1, link1,neigh2,...
% Featurevec structure: length1, angs1(1:4), length2,..

if (nargin == 5)
    labelmap = points_show(bw, pt, R, false);
end

[M, N]= size(bw);
imdim = M*N + 1;

Neighbor = [-M, 1, M, -1, -1-M, 1-M,  1+M, -1+M];
Len = prod(size(Neighbor));

bworigin = bw;
link = zeros(1, 2*NeighborNum); % neighbor and its link point
angs = zeros(1, NeighborNum*NeighborNum); % angles

% assign seed and its border as 0
labelmap(labelmap==labelmap(seed))= 0;
bw(seed) = 0;
stackmap = seed;
sphead = 1;
sptail = 1;
count = 0;
while (sphead <= sptail) & (count< NeighborNum)
    localidx = stackmap(sphead);
    neighidx = localidx + Neighbor;
    for i=1:Len
        idx = neighidx(i);
        if (idx>0) & (idx<imdim) & (bw(idx)==1)
            bw(idx) = 0;
            if (labelmap(idx)~=0 & ~isempty(point_angle(bworigin, pt(labelmap(idx)), R, idx, NeighborNum)))
                count = count + 1;
                link(2*(count-1)+1:2*count) = [pt(labelmap(idx)), idx];
                angs(NeighborNum*(count-1)+1:NeighborNum*count)= point_angle(bworigin, pt(labelmap(idx)), R, idx, NeighborNum);

                if (count>= NeighborNum) break; end
                labelmap(labelmap==labelmap(idx))= 0;
                neighidx1 = idx+ Neighbor;
                for i=1:Len
                    idx1 = neighidx1(i);
                    if (idx1>0) & (idx1<imdim)
                        bw(idx1) = 0;
                    end
                end
            else
                sptail = sptail + 1;
                stackmap(sptail)= idx;
            end
        end
    end
    sphead = sphead + 1;
end

node=[seed, count, link];

%--------------------------------------------------------------------------
count = node(2);
seeds = node(1:2:2+2*count);

% image(i,j) <==>(j-1)*M + i
posi = mod(seeds, M);
posi(find(posi==0))= M; 
posj = 1 + (seeds-posi)/M;

for k =1:count
    dy = -(posi(k+1)-posi(1));
    dx =   posj(k+1)-posj(1);
    bDist(k) = sqrt( dy*dy + dx*dx );
    mAng(k)  = atan2(dy, dx)*180/pi;
end
mAng(mAng<0) = mAng(mAng<0) + 360;

% counterclock start from 3 oclock, rearanage features
[mAng,idx] = sort(mAng);
bDist = bDist(idx);
for k=1:count
    nAng(NeighborNum*(k-1)+1: NeighborNum*k) = angs( NeighborNum*(idx(k)-1)+1: NeighborNum*idx(k));
    if prod(size(find(nAng(NeighborNum*(k-1)+1: NeighborNum*k)==0)))==3
        bDist(k)=1;
    end
end

% angle between each branch
bAng(1)= mAng(1)-mAng(count);
for k=2:count
    bAng(k)  = mAng(k)-mAng(k-1);
end
bAng(bAng<0) = bAng(bAng<0) + 360;

% normalize the Dist and Angle
bDist = bDist/sum(bDist);
bAng  = bAng/360;
nAng  = nAng/360;

featurevec = -100*ones(1, NeighborNum*(NeighborNum+2));
for k=1:count
    featurevec((NeighborNum+2)*(k-1)+1:(NeighborNum+2)*k) = [bDist(k),bAng(k), nAng( NeighborNum*(k-1)+1: NeighborNum*k)];
end