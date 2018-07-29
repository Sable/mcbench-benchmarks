function meansOut = kmean(img,means)
% performs one step of the k-means clustering algorithm on a binary image
% with an initial guess of input mean values
% 
%       input arguments:
%   img         - mxn binary image
%   means       - px2 array with each row representing the row and column value
%                 of each initial cluster average guess
%
%       output:
%   meansOut    - output mean results after one iteration of the k-means
%                 algorithm

    [r c] = find(img);
    p = size(means,1);
    dist = zeros(p,numel(r));

    %obtain distances from each mean point and each pixel in the image
    for k=1:p
        dr = means(k,1)-r;
        dc = means(k,2)-c;
        dist(k,:) = sqrt(dr.^2+dc.^2);
    end

    %find the row indices that minimize the distances between the assumed
    %mean values and the pixels in the image. This will be the associated
    %cluster for each mean value
    %pointInd : indices that belong to the nearest input average
    [val, pointInd] = min(dist);

    %for each cluster, create a new mean
    for k=1:p
        useInd = find(pointInd==k);
        rPoints = r(useInd);
        rAve = mean(rPoints);
        cPoints = c(useInd);
        cAve = mean(cPoints);
        means(k,1) = rAve;
        means(k,2) = cAve;
    end

    %remove mean values that that dont have a cluster associated with them.
    fixInd = ~isnan(means);
    fixInd = find(fixInd);
    ind = fixInd;
    means = means(ind);
    meansOut = reshape(means,floor(numel(means)/2),2);
end