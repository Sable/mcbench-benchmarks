% Laplacian Smoothing Transform for face recognition

function [gammak,lambda]=lst_basis(M,N,k)
% By Suicheng Gu at Peking University, Jan. 5, 2009
% Email: gusuch@gmail.com

% Output: v: basis. vv: k minimal eigenvalues
% Input:
% N: width of input image, or columns of a matrix
% M: height of input image, or rows of a matrix
% k: Number of low frequency features

%************ An Example ************
% To extract 30 LST low frequency coefficients of an grey image: 
%  Im=rand(50,40); [M,N]=size(Im);                  
%  v=lst_basis(M,N,30);
%  temp=zeros(1,M*N);temp(:)=Im(:);
%  Im_feature=temp*v;
%*********** End ******************

W = sparse([],[],[],M*N,M*N,4*M*N-2*M-2*N);
for x=0:N-2;
    for y=0:M-1;
        W(x*M+y+1,x*M+M+y+1)=1;
        W(x*M+M+y+1,x*M+y+1)=1;
    end;
end;
for x=0:N-1;
    for y=0:M-2;
        W(x*M+y+1,x*M+y+2)=1;
        W(x*M+y+2,x*M+y+1)=1;
    end;
end;
L=sparse(diag(sum(W)))-W;
options.disp = 0; options.isreal = 1; options.issym = 1; 
[v,lambda]=eigs(L,k,0,options);
[vv,index] = sort(diag(lambda));
gammak = v(:,index);  