function result = GGclust(data,param)


%checking the parameters given
f0=param.c;
%data normalization
X=data.X;

if exist('param.m')==1, m = param.m;else m = 2;end;
if exist('param.e')==1, e = param.m;else e = 1e-4;end;



[N,n] = size(X);
[Nf0,nf0] = size(f0);
X1 = ones(N,1);

% Initialize fuzzy partition matrix
rand('state',0)
if max(Nf0,nf0) == 1, 		% only number of cluster given
  c = f0;
  mm = mean(X);             
  aa = max(abs(X - ones(N,1)*mm)); 
  v = 2*(ones(c,1)*aa).*(rand(c,n)-0.5) + ones(c,1)*mm;
  for j = 1 : c,
    xv = X - X1*v(j,:);
    d(:,j) = sum((xv*eye(n).*xv),2);
   end;
   d = (d+1e-10).^(-1/(m-1));
   f0 = (d ./ (sum(d,2)*ones(1,c)));
else
  c = size(f0,2);
  fm = f0.^m; sumf = sum(fm);
  v = (fm'*X)./(sumf'*ones(1,n)); 
end;

f = zeros(N,c);                 % partition matrix
iter = 0;                       % iteration counter


% Iterate
while  max(max(f0-f)) > e
  iter = iter + 1;
  % Calculate centers
  f = f0;
  fm = f.^m;
  sumf = sum(fm);
  
  v = (fm'*X)./(sumf'*ones(1,n));

  for j = 1 : c,                        
    xv = X - X1*v(j,:);
    % Calculate covariance matrix
    A = ones(n,1)*fm(:,j)'.*xv'*xv/sumf(j);
    Pi(:,:,j)=1/N*sum(fm(:,j));
    d(:,j) = 1/(det(pinv(A))^(1/2))*1/Pi(:,:,j)*exp(1/2*sum((xv*pinv(A).*xv),2));
    %d(:,j) = 1/(det(A)^(1/2))*Pi(:,:,j)*exp(-1/2*sum((xv*pinv(A).*xv)')');
end
  distout=sqrt(d);  
  % Update f0
  if m>1                                %Gath-Geva clustering
      d = (d+1e-10).^(-1/(m-1));
  else                                  %Fuzzy Maximum Likelihood Estimates clustering
      d = (d+1e-10).^(-1);
  end    
      f0 = (d ./ (sum(d,2)*ones(1,c)));
      J(iter) = sum(sum(f0.*d));           %calculate objective function
end


fm = f;sumf = sum(fm);

P = zeros(n,n,c);             % covariance matrix
V = zeros(c,n);                % eigenvectors
D = V;                          % eigenvalues

% calculate P,V,D
for j = 1 : c,                        
    xv = X - ones(N,1)*v(j,:);
% Calculate covariance matrix
    A = ones(n,1)*fm(:,j)'.*xv'*xv/sumf(j);
% Calculate eigen values and eigen vectors
    [ev,ed] = eig(A); ed = diag(ed)';
    ev = ev(:,ed == min(ed));
% Put cluster info in one matrix
    P(:,:,j) = A;
    V(j,:) = ev';
    D(j,:) = ed;
end;


%result outputs
result.data.f = f0;
result.data.d = distout;
result.cluster.v = v;
result.cluster.P = P;
result.cluster.V = V;
result.cluster.D = D;
result.iter = iter;
result.cost = J;