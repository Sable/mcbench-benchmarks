function result = PCA(data,param,result)
%                   %beletehetõ hogy veszi e bementnek az eigenvektoroat, if existes téma
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% the data
[N,n]=size(data.X);
odim = param.q; %projection to q-dimension
% calculating autocorrelation matrix
  A = zeros(n);
  me = zeros(1,n);
  for i=1:n, 
    me(i) = mean(data.X(isfinite(data.X(:,i)),i)); 
    data.X(:,i) = data.X(:,i) - me(i); 
  end  
  for i=1:n, 
    for j=i:n, 
      c = data.X(:,i).*data.X(:,j); c = c(isfinite(c));
      A(i,j) = sum(c)/length(c); A(j,i) = A(i,j); 
    end
  end
  
  % eigenvectors, sort them according to eigenvalues, and normalize
  [V,S]   = eig(A);
  eigval  = diag(S);
  [y,ind] = sort(abs(eigval)); 
  eigval  = eigval(flipud(ind));%??????
  V       = V(:,flipud(ind)); 
  for i=1:odim
     V(:,i) = (V(:,i) / norm(V(:,i)));
  end
  
  % take only odim first eigenvectors
  V = V(:,1:odim);
  D = abs(eigval)/sum(abs(eigval));
  D = D(1:odim); 

% project the data using odim first eigenvectors
P = data.X*V;
%cluster centers by PCA
vp = (result.cluster.v-me(ones(param.c,1),:))*V; 

%results
result.proj.P = P;%projected data
result.proj.vp = vp;%cluster centers
result.proj.V = V;%eigenvectors
result.proj.D = D;%eigenvalues



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
