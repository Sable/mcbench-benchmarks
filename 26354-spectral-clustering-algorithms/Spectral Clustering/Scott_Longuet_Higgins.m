% G.L. Scott and H. C. Longuet-Higgins, 
% "Feature Grouping by Relocalisation of Eigenvectors of the Proxmity Matrix", 
% In Proc. British Machine Vision Conference, pages 103-108, 1990.

% Asad Ali
% GIK Institute of Engineering Sciences & Technology, Pakistan
% Email: asad_82@yahoo.com

% CONCEPT: Introduced the Q matrix for the discretization of eigenvectors for the
% points belonging to the same cluster
clear all;
close all;

% generate the data
data = GenerateData(2);
figure,plot(data(:,1), data(:,2),'r+'), title('Original Data Points'); grid on;shg

% calculate the affinity matrix
affinity = CalculateAffinity(data);
figure,imshow(affinity,[]), title('Affinity Matrix');

% perform the eigen value decomposition
[eigVectors,eigValues] = eig(affinity);

% select k largest eigen vectors
k = 3;
nEigVec = eigVectors(:,(size(eigVectors,1)-(k-1)): size(eigVectors,1));

% construct the normalized matrix U from the obtained eigen vectors
for i=1:size(nEigVec,1)
    % compute the norm of ith row and normalize the row to have unit
    % Euclidean norm
    n = sqrt(sum(nEigVec(i,:).^2));
    U(i,:) = nEigVec(i,:) ./ n;
end

% construct the matrix Q
Q = U * transpose(U);
figure, imshow(Q,[]), title('Clustered Q Matrix');

% Q(i,j) = 1, if points belong to the same group and Q(i,j) = 0,
% if points belong to different groups.

% find data points where Q(i,j) >= 0.9 
index = 1;
for i=1:size(Q,1)
    for j=1:size(Q,2)
        if Q(i,j) >= 0.9 && Q(j,i) >= 0.9
            dataPoints(index,1) = i;
            dataPoints(index,2) = j;
            index = index + 1;
        end
    end
end

% create full cluster set using all points
index = 1;
for i=1:size(data,1)
    [xx,yy] = find(dataPoints(:,1) == i);
    for j=1:size(xx,1)
        clusterSet(i,j) = dataPoints(xx(j),2);
    end
end

% create unique cluster set from all clusters
uniqueIndex = 1;
uniqueClusterSet = clusterSet(1,:);
for i=1:size(clusterSet,1)
    found = 0;
    for j=1:uniqueIndex
        if isequal(uniqueClusterSet(j,:),clusterSet(i,:))
            found = 1;
        end       
    end
    if ~found
       uniqueIndex = uniqueIndex + 1;
       uniqueClusterSet(uniqueIndex,:) = clusterSet(i,:);            
    end     
end

% display the clustered data
figure,
hold on; 
for i=1:size(uniqueClusterSet,1)
    [xx,yy] = find(uniqueClusterSet(i,:) > 0);
   
    if i == 1
       plot(data(uniqueClusterSet(i,yy(:)),1),data(uniqueClusterSet(i,yy(:)),2),'m+');
    elseif i == 2
       plot(data(uniqueClusterSet(i,yy(:)),1),data(uniqueClusterSet(i,yy(:)),2),'g+');
    elseif i == 3 
       plot(data(uniqueClusterSet(i,yy(:)),1),data(uniqueClusterSet(i,yy(:)),2),'b+');
    elseif i == 4 
       plot(data(uniqueClusterSet(i,yy(:)),1),data(uniqueClusterSet(i,yy(:)),2),'k+');       
    end
end
 hold off;
 title('Clustering Results Using Q Matrix');
 grid on; shg;