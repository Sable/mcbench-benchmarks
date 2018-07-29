%   y: dimensionanlity-reduced data
%	eigVector: eigen-vector obtained in kPCA
%   X: data matrix
%   para: parameter of Gaussian kernel
%	z: pre-image of y

%   Copyright by Quan Wang, 2011/05/10
%   Please cite: Quan Wang. Kernel Principal Component Analysis and its 
%   Applications in Face Recognition and Active Shape Models. 
%   arXiv:1207.3538 [cs.CV], 2012. 

function z=kPCA_PreImage(y,eigVector,X,para)

iter=1000;
N=size(X,1);
d=max(size(y));

gamma=zeros(1,N);
for i=1:N
    gamma(i)=eigVector(i,1:d)*y;
end

z=mean(X)'; % initialization
fprintf('\nReconstruction: \n');
for count=1:iter
    fprintf('%d ', count);
    if mod(count,10)==0
        fprintf('\n');
    end
    
    pre_z=z;
    xx=bsxfun(@minus,X',z);
    xx=xx.^2;
    xx=-sum(xx)/(2*para.^2);
    xx=exp(xx);
    xx=xx.^gamma;
    
    z=xx*X/sum(xx);
    z=z';
    if norm(pre_z-z)/norm(z)<0.0001
        break;
    end
end
fprintf('\n');
