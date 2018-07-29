function [ coefs ] = train_snpe( ft,IDs )
%	compute the supervised NPE(neighborhood preserving embedding) subspace for dimension reduction.
% ft: 	features, each column is a feature vector.
% IDs:	1-by-size(ft,2) vector indicating the person ID of each feature vector.
%	coefs: struct with fields:
%		mu: 		mean(ft,2)
%		W_prj:	ft_projected(:,p) = coefs.W_prj*(ft(:,p)-coefs.mu)
%
% This is one version of supervised NPE, in fact it combines NPE with LDA.
%	Test on ORL face dataset shows that it is much better than the origin NPE.
%	See Xiaofei He's "Neighborhood Preserving Embedding". Chinese reference: 李晓东等《基于有监督保持邻域嵌入人脸识别》
%
%	Yan Ke @ THUEE, xjed09@gmail.com


[vector_len train_num] = size(ft);

% subtract mean
mu_total0 = mean(ft,2);
ft = ft-repmat(mu_total0,1,train_num);

% sort ft by IDs
[IDs I] = sort(IDs);
ft = ft(:,I);
[~, I ,~] = unique(IDs);
class_num = length(I);
sample_num = [I(1) diff(I)];
J = I-sample_num+1;

%% NPE part
% distance matrix & k-nearest neighborhoods
knn = 50;%train_num-1;
a2 = repmat(sum(ft.^2,1),train_num,1);
ab = ft'*ft;
distMat = a2+a2'-2*ab;
[~,idx] = sort(distMat,2); % sort for each row
neighborhood = idx(:,2:(1+knn));

% weight matrix
W = zeros(train_num);
for p = 1:train_num
		% shift pth pt to origin, z: vector_len-by-knn
	z = ft(:,neighborhood(p,:))-repmat(ft(:,p),1,knn);
	C = z'*z; % local covariance, knn-by-knn
	w = C\ones(knn,1);  % solve Cw=1
	W(p,neighborhood(p,:)) = w/sum(w); % enforce sum(w)=1
end

% do PCA to ft
[V1 D1] = eig(ft'*ft);
D1 = diag(D1);
if D1(1) < D1(train_num)
    V1 = fliplr(V1);
% 	D1 = flipud(D1);
end

% pcaRate = .97; % bad
% D1 = cumsum(D1);
% D1 = D1/D1(train_num);
% postPcaDim = nnz(D1 < pcaRate)+1;
postPcaDim = train_num-class_num;
V1 = V1(:,1:postPcaDim);
W_pca = ft*V1;
W_pca = W_pca./repmat(sqrt(sum(W_pca.^2,1)),vector_len,1);
clear V1
ft = W_pca'*ft; % ft: postPcaDim*train_num

%% LDA part
% calculate within-class average
pca_face = ft;
mu_per_class = zeros(postPcaDim,class_num);
for p = 1:class_num
	mu_per_class(:,p) = mean(pca_face(:,J(p):I(p)),2);
	pca_face(:,J(p):I(p)) = pca_face(:,J(p):I(p))-...
		repmat(mu_per_class(:,p),1,sample_num(p));
end

% within class scatter matrix
Sw = pca_face*pca_face';

% between class scatter matrix
Sb = zeros(postPcaDim);
for p = 1:class_num
	Sb = Sb+sample_num(p)*mu_per_class(:,p)*mu_per_class(:,p)'; 
end

%% SNPE part
theta = .1;
I = eye(train_num);
M = (I-W)'*(I-W);
A = theta*ft*M*ft' + (1-theta)*Sw;
B = Sb;
	% can not use eig(B\A) even if rank(B) = 80, maybe because B is 
	% ill-conditioned
[V D] = eig(A,B);
if D(1) > D(postPcaDim,postPcaDim)
    V = fliplr(V);
end

postNpeDim = class_num-1;
W_prj = W_pca*V(:,1:postNpeDim);
W_prj = W_prj./repmat(sqrt(sum(W_prj.^2,1)),vector_len,1);

% save coefs
coefs.W_prj = W_prj';
coefs.mu = mu_total0;

end
