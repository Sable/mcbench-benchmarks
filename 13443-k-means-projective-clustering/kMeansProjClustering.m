%%% This function perform projective clustering as described in "k-means
%%% projective clustering" by Agarwal & Mustafa.
%%% (C) Yohai Devir, yohai_devir AT YAH00 D0T C0M

%%% arguments:
%%% pointsCoords - (I) - DxN coordination matrix
%%% k            - (I) - number of desired clusters
%%% options      - (I) - options struct (square brackets - default value):
%%%     Threshold     - (double)  - minimal rms difference between two iterations [1e-3]
%%%     KSMIters      - (integer) - number of k-means iterations in alg 3 [10]
%%%     IsConstantDim - (logical) - do all clusters have the same dimentionality [true]
%%%     findDimAlfa   - (double)  - alfa parameter for finding cluster dimentionality. [0.5]
%%%     constFlatDim  - (integer) - dimentionality of every cluster. [2]
%%%     gamma         - (double)  - gamma parameter for cluster splitting. [0.3]
%%% clustIndices - (O) - 1*N vector of the cluster number each point belongs to
%%% ssdVector    - (O) - rms in each iteration
%%% flatsStructV - (O) - representation of each Q-dimensional subspace in D-dimensional space:
%%%     P0      - Dx1 vector of a point in this subspace.
%%%     Vectors - DxQ matrix of Q orthonormal vectors that spans the subspace.

%%% Few notes: 
%%% A. Unlike the article clusters are selected to be merged if their merging gives the
%%%    smallest rms.
%%% B. rms is refered as ssd (sum of squared distances)
%%% C. options is an optional parameter.



%%% implementation of KSM(P) - Alg 3 in the article
function [clustIndices, ssdVector, flatsStructV] = kMeansProjClustering(pointsCoords, k, options)
if nargin < 3
    options = struct([]);
end

options = setDefaultValues(options,...
    'Threshold',    1e-3,   ...
    'KSMIters',     10,     ...
    'FDPkMIters',   10,     ...
    'IsConstantDim',true,   ...
    'findDimAlfa',  0.5,    ...
    'constFlatDim', 2,      ...
    'gamma',        0.3);

%%% start with random partition
clustIndices = round(rand(1,size(pointsCoords,2))*k + 0.5);

flatsStructV = calcFlats(clustIndices,pointsCoords,options);
ssdVector = calcSsd(clustIndices,pointsCoords,flatsStructV);
for ii=1:options.KSMIters
    clustIndices = splitClusters(clustIndices,pointsCoords, round(k/1), options);
    clustIndices = ProjKMeans(clustIndices,pointsCoords, options);
    clustIndices = mergeClusters(clustIndices,pointsCoords,min(round(k/1),max(clustIndices)-k),options);
    clustIndices = RemoveEmptyClusters(clustIndices);

    ssdVector = [ssdVector calcSsd(clustIndices,pointsCoords,calcFlats(clustIndices,pointsCoords,options))];
    if (ssdVector(end) == 0) || ( abs(ssdVector(end)- ssdVector(end-1))/ssdVector(end)  < options.Threshold)
        break
    end %if
end %for



switch nargout
    case 3
        flatsStructV = calcFlats(clustIndices,pointsCoords,options);
    case 2
        clear flatsStructV
    case 1
        clear flatsStructV ssdVector
end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calc all the flats
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function flatsStructV = calcFlats(clustIndices,pointsCoords,options)
for ii=1:max(clustIndices)
    flatsStructV(ii) = getBestQflat(pointsCoords(:,clustIndices == ii),findDimension(pointsCoords(:,clustIndices == ii),options) );
end
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Find the Qi-dimentional flat best describing the points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function flatsStruct = getBestQflat(pointsCoords,Qi)
if size(pointsCoords,2) == 0
    error('In getBestQflat:','empty cluster');
end

meanClust = mean(pointsCoords,2);
pointsCoords = pointsCoords-repmat(meanClust,[1 size(pointsCoords,2)]);
[U,S,V] = svd(pointsCoords);
U = U';
flatsStruct.Vectors = [];
for ii = 1:Qi
    flatsStruct.Vectors = [flatsStruct.Vectors U(ii,:)'];
end % for
flatsStruct.P0 = meanClust;
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% find the dimansion of given subspace
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function qi = findDimension(pointsCoords,options)
if options.IsConstantDim
    qi = options.constFlatDim;
    return
end %if


d = size(pointsCoords,1);
alfa = options.findDimAlfa;

mjuStarP1 = calcSsd(ones(1,size(pointsCoords,2)),pointsCoords,getBestQflat(pointsCoords,1));
for qTag = d:-1:0;
    mjuStarPii(qTag) = calcSsd(ones(1,size(pointsCoords,2)),pointsCoords,getBestQflat(pointsCoords,qTag));
    if mjuStarPii(qTag) > alfa*mjuStarP1
        qTag = qTag+1;
        break
    end %if
end %for
if (qTag == 0)
    error('was unable to find appropriate qTag')
end
twoDPoints = [1:d;mjuStarPii];
twoDP0 = [d;0];
twoDVectors = [d-qTag;0-mjuStarPii(qTag)];
twoDVectors = twoDVectors./norm(twoDVectors);
Distances = calcDistsFromQFlat(twoDPoints,twoDVectors,twoDP0);
Distances(1:qTag-1) = -inf;
qi = find(Distances == max(Distances));
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% calculate ssd (which is sum of the square distances) written as rms in
%%% the article
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ssd = calcSsd(clustIndices,pointsCoords,flatsStructV)
if length(flatsStructV) < max(clustIndices)
    error(' There are less flatsStruct entries than clusters');
end %if
ssd = 0;
for ii=1:max(clustIndices)
    ssd = ssd + sum(calcDistsFromQFlat(pointsCoords(:,clustIndices == ii),flatsStructV(ii).Vectors,flatsStructV(ii).P0).^2);
end %for
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calc distances from a given Q-dimesional hyperPlane described
%%% by Q vectors and one point
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pointToHyperplaneDist = calcDistsFromQFlat(pointsCoords,Vectors,P0)
if isempty(pointsCoords)
    pointToHyperplaneDist = [];
    return
end

tmp = [size(P0,1) size(Vectors,1) size(pointsCoords,1)];
if (min(tmp) ~= max(tmp) )
    error('Input dimesions are not all equal');
end
if (rank(Vectors) < size(Vectors,2))
    error('vectors are lineary dependant');
end

pointToHyperplaneDist = pointsCoords - repmat(P0,[1 size(pointsCoords,2)]);                                                                                                          % reduce the mean of the neighbourhood
pointToHyperplaneDist = pointToHyperplaneDist - Vectors*(Vectors'*pointToHyperplaneDist);   % dist between point and its projection
pointToHyperplaneDist = sum(pointToHyperplaneDist.^2,1);                                                                                        % norm2 ^2
pointToHyperplaneDist = pointToHyperplaneDist.^0.5;

return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Splits m clusters according to farest points from the best plane
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function newClustIndices = splitClusters(clustIndices,pointsCoords, m,options)

gamma = options.gamma;

for ii=1:max(clustIndices)
    qi_mul_norm_Pi(ii)=sum(clustIndices == ii)*findDimension(pointsCoords(clustIndices == ii),options);
end %for
[tmp, PtagOrder] = sort(qi_mul_norm_Pi,'descend'); %PtagOrder is now the descending order of clusters
clear tmp qi_mul_norm_Pi ii

%%% check if some clusters are empty? If so i'ld like to toss away the points
%%% into clusters with pre-specified qi and not to such that i'll have to invent it
EmptyClusters = [];
for ii = 1:3*max(clustIndices)
    if (length(find(clustIndices == ii)) == 0)
        EmptyClusters = [EmptyClusters ii];
    end %if
end %for

newClustIndices = clustIndices;
for ii=1:m
    clear S
    S{1} = (clustIndices == PtagOrder(ii));
    for jj = 0:log(0.5)/log(gamma);
        flatsStruct = getBestQflat(pointsCoords(:,S{jj+1}),findDimension(pointsCoords(:,S{jj+1}),options) );
        pointToFlatDist  = calcDistsFromQFlat(pointsCoords(:,S{jj+1}),flatsStruct.Vectors,flatsStruct.P0);
        [dists, indices] = sort(pointToFlatDist,'ascend');
        %     Threshold = dists(ceil( (1-gamma)*length(dists)));
        UpdateVector = zeros(size(dists));
        UpdateVector(indices(1:ceil( (1-gamma)*length(dists)) ) ) = 1;
        S{jj+2} = S{jj+1};
        S{jj+2}(find(S{jj+2})) = UpdateVector;
        S{jj+2} = logical(S{jj+2});
    end %for
    %     newClustIndices((clustIndices == PtagOrder(ii)) & S{end}) = PtagOrder(ii);
    newClustIndices((clustIndices == PtagOrder(ii)) & ~S{end}) = EmptyClusters(ii);
end %for

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% perform Projective k-means (Alg 2 in the article)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [clustIndices, flatsStructV] = ProjKMeans(clustIndices,pointsCoords, options)
for ii = 1:options.FDPkMIters
    prevClustIndices = clustIndices;
    flatsStructV = calcFlats(clustIndices,pointsCoords,options);
    clustIndices = assignPointsToNearestFlat(pointsCoords,flatsStructV);
    if isequal(clustIndices,prevClustIndices)
        break
    end %if
end %for
if nargout == 1
    clear flatsStructV
end
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% merge m clusters into other clusters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function clustIndices = mergeClusters(clustIndices,pointsCoords,m,options)
for u = 1:m
    mjuStar = inf(max(clustIndices));
    for ii=1:max(clustIndices);
        if numel(find(clustIndices==ii)) == 0
            continue;
        end
        iiDim = findDimension(pointsCoords(clustIndices==ii),options);
        for jj = ii+1:max(clustIndices);
            if numel(find(clustIndices==jj)) == 0
                continue;
            end
            unionPoints      = pointsCoords(:,(clustIndices==ii)|(clustIndices==jj));
            jjDim = findDimension(pointsCoords(clustIndices==jj),options);
            unionDim         = min(iiDim,jjDim);
            unionFlatsStruct = getBestQflat(unionPoints,unionDim);
            mjuStar(ii,jj)   = calcSsd(ones(1,size(unionPoints,2)),unionPoints,unionFlatsStruct);
            for kk = 1:max(clustIndices)
                if (kk == ii) || (kk == jj) || (numel(find(clustIndices==kk)) == 0)
                    continue
                end %if
                otherClustPoints = pointsCoords(:,clustIndices==kk);
                otherClustDim = findDimension(otherClustPoints,options);
                flatsStruct = getBestQflat(otherClustPoints,unionDim);
                mjuStar(ii,jj) = mjuStar(ii,jj) + calcSsd(ones(1,size(otherClustPoints,2)),otherClustPoints,flatsStruct);
            end %for kk
        end % for jj
    end %for ii
    [ii,jj] = find(mjuStar == min(mjuStar(:)));
    clustIndices(find(clustIndices == jj)) = ii;
end %for u
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% change cluster numbering so there will be no empty clusters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function clustIndices = RemoveEmptyClusters(clustIndices)
emptyClusters = [];
for ii=1:max(clustIndices);
    if (length(find(clustIndices == ii)) == 0)
        emptyClusters = [emptyClusters ii];
        continue
    end
    if isempty(emptyClusters) %no empty clusters available there are ii clusters so far
        continue;
    end
    clustIndices(clustIndices == ii) = emptyClusters(1);
    emptyClusters = [emptyClusters(2:end) ii];
end %for
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% find he nearest flat for each point
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function clustersIndices = assignPointsToNearestFlat(pointsCoords,flatsStructV)
for ii=1:length(flatsStructV)
    DistanceToflats(ii,:) = calcDistsFromQFlat(pointsCoords,flatsStructV(ii).Vectors,flatsStructV(ii).P0);
end %for
[tmp,clustersIndices] = min(DistanceToflats,[],1);
clustersIndices = RemoveEmptyClusters(clustersIndices);
return
