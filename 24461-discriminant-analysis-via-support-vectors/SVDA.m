%****** Discriminant Analysis via Support Vector *****
% By Suicheng Gu at Peking University on Jan. 5, 2008
% Any questions, you can email me: gusuch@gmail.com

%Input: X, training samples with size of N*d | d, dimension | N, number of samples.
%Input: Y, training index with size of N*1,
%Input: k, Number of eigenvectors of the VLD (default k=d)
%Input: gamma, regularizer (default gamma=0.05);
%Output: V, with size of d*k, each column is one eigenvector.
%output: d, with size of d*1, eigenvalues of SVDA in descend order.

function [V,d] = SVDA(X,Y,k,gamma)

%Train SVM, Libsvm is employed. http://www.csie.ntu.edu.tw/~cjlin/libsvm/faq.html
model = svmtrain(Y,X,'-t 0 -c 100');
[N,d] = size(model.SVs); C=model.nr_class;

%Obtain with-in class matrix Vw
Vw = zeros(d,d);
for i = 1:C;
    Ii = sum(model.nSV(1:i))-model.nSV(i)+1:sum(model.nSV(1:i)); 
    w = model.SVs(Ii,:)-repmat(mean(model.SVs(Ii,:)),model.nSV(i),1);
    Vw = Vw + w'*w;
end;
if nargin < 4;
    gamma = 0.05;
end;
    Vw = (1-gamma)*Vw+gamma/(N-C)*trace(Vw)*eye(d);

%Obtain between-class matrix Vb
Vb = zeros(d,d);
for i = 1:C-1;
    for j = i+1:C;
        Ii = sum(model.nSV(1:i))-model.nSV(i)+1:sum(model.nSV(1:i)); 
        Ij = sum(model.nSV(1:j))-model.nSV(j)+1:sum(model.nSV(1:j));
        w = model.sv_coef(Ii,j-1)'*model.SVs(Ii,:)+model.sv_coef(Ij,i)'*model.SVs(Ij,:);
        Vb = Vb+w'*w;
    end;
end;

%Compute Projection matrix V
[V,D] = eig(inv(Vw)*Vb);
[d,index] = sort(diag(D),'descend');
V = V(:,index(1:k));