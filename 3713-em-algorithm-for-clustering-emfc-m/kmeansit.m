function kmeansit
%h-MEANS! 
clear;clc;
load data;

tic;
k=5;

[n,d]= size(X);

%Dialekse kapoies parthrhseis gia ta centroids.

ind = randperm(n);
ind = ind(1:k);
nc = X(ind,:);
%8ese thn apo8hkh gia ta melh twn clusters.
%Oi akeraioi 1,....,k deixnoun se poio cluster eisai.
cid = zeros(1,n);
%Kane to  diaforetiko gia na arxisei to loop
oldcid = ones(1,n);
% O ari8mos se ka8e cluster
nr = zeros(1,k);
%8ese megisto ari8mo apo iterations
maxiter = 100;
iter =1;

while ~isequal(cid,oldcid)& iter < maxiter
    oldcid = cid;
    
   %Ftiakse ton hmeans algori8mo.
   %Gia ka8e shmeio, vres thn norma pou 8es (e8esa eukleidia)
   %pros opoiodhpote centroid.
   
   for i=1:n
       dist = sum((repmat(X(i,:),k,1)-nc).^2,2);
       %tautopoieise to me to cluster k
       [m,ind] = min(dist);
       cid(i) = ind;
   end
   %Vres ta nea centroids.
   for i = 1:k
       %Vres ola ta shmeia se auto to cluster.
       ind = find(cid==i);
       %Vres & to centroid.
       nc(i,:) = mean(X(ind,:));
       %Vres kai to numero se ka8e cluster.
      nr(i) = length(ind);
  end
  iter =iter +1
end

disp('Time needed for finding "better" initial centroids: '),disp(toc);

%Initial partitions found 
%Proceeding to k-means algorithm given the centroids from the h-means.
 [cidx, ctrs] = kmeans(X, 5, 'dist','city','start',nc,'rep',1,'disp','final');
 plot(X(cidx==1,1),X(cidx==1,2),'r.', ...
        X(cidx==2,1),X(cidx==2,2), 'b.', ...
        X(cidx==3,1),X(cidx==3,2), 'm.', ...
        X(cidx==4,1),X(cidx==4,2), 'y.', ...
        X(cidx==5,1),X(cidx==5,2), 'g.', ...
        ctrs(1,1),ctrs(1,2),'kx',ctrs(2,1),ctrs(2,2),'kx',...
        ctrs(3,1),ctrs(3,2),'kx',ctrs(4,1),ctrs(4,2),'kx',...
        ctrs(5,1),ctrs(5,2),'kx');
    
    save M5 cidx