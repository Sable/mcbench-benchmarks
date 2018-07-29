function C = correlation_fun(corr,mesh1,mesh2,spthresh,matvec,x)
% CORRELATION_FUN returns the correlation matrix (or times a vector).
%
% C = correlation_fun(name,c0,c1,sigma,mesh1,mesh2,spthresh);
% C = correlation_fun(name,c0,c1,sigma,mesh1,mesh2,spthresh,matvec,x);
%
% Outputs:
%   C:      Either a sparse correlation matrix or the action of the
%           correlation matrix times a vector.
%
% Inputs:
%   name:   Type of correlation function. Choose from 'gauss', 'exp', or 
%           'turbulent'.
%
%   c0:     Scaling parameters for correlation. A scalar or a vector with
%           length equal to the dimension of the mesh points.
%           
%   c1:     Scaling parameters for correlation - only used in 'turbulent' 
%           correlation. A scalar or a vector with length equal to the 
%           dimension of the mesh points.
%
%   sigma:  A scaling vector representing the variance. Can be a scalar or
%           a vector the size of the mesh.
%
%   mesh1:  A matrix of size nx1 by d, where nx1 is the number of points in
%           the mesh and d is the dimension.
%
%   mesh2:  A matrix of nx2 by d, where nx2 is the number of points in
%           the mesh and d is the dimension.
%
%   spthresh:   Threshold for setting an element of the covariance matrix
%               to zero in the sparse matrix. (Default 0 means include all
%               elements).
%
%   matvec: Used to reduce the memory footprint. Every time the solver asks
%           for the action of the matrix on a vector, it recomputes the
%           entries of the matrix. This is very slow and should be used
%           only if the matrix does not fit into memory, and if you have
%           lots of time to spare.
%   
%   x:      The vector multiplied by the correlation matrix.
%
% Correlation types:
% The correlation functions take two points x1 and x2 from the mesh.
%
%   gauss:      exp( (-1/2) * sum_i (( x1(i) - x2(i) )^2 / c0(i) )
%
%   exp:        exp( (-1/2) * sum_i ( abs( x1(i) - x2(i) ) / c0(i) )
%
%   turbulent:  exp( (-1/2) * sum_i (( x1(i) - x2(i) )^2 / ( c0(i) + d )
%               where d(i) = sum_k c1(k) * abs( x1(k) - x2(k) ) 
%
%
% COPYRIGHT 2011 Qiqi Wang (qiqi@mit.edu) and Paul G. Constantine 
% (paul.constantine@stanford.edu).

if ~exist('mesh2','var') || isempty(mesh2), mesh2=mesh1; end
if ~exist('spthresh','var') || isempty(spthresh), spthresh=0.01; end
if ~exist('matvec','var') || isempty(matvec), matvec=0; end

m=size(mesh1,1); n=size(mesh2,1);

name=corr.name;
c0=corr.c0;
c1=corr.c1;
sigma=corr.sigma;

if matvec
    
    tt=tic;
    switch lower(name)
        case 'gauss'
            if isscalar(c0), c0=c0*ones(size(mesh1,2),1); end
            c0=-0.5./c0; c0=c0(:);
            
            x=x.*sigma; x=x';
            C=zeros(m,1);
            parfor i=1:n
                point=mesh2(i,:);
                X=(mesh1-repmat(point,m,1)).^2;
                C(i)=x*(exp(X*c0));
            end
            
        case 'exp'
            if isscalar(c0), c0=c0*ones(size(mesh1,2),1); end
            c0=-0.5./c0; c0=c0(:);
            
            x=x.*sigma; x=x';
            C=zeros(m,1);
            parfor i=1:n
                point=mesh2(i,:);
                X=abs(mesh1-repmat(point,m,1));
                C(i)=x*(exp(X*c0));
            end
            
        case 'turbulent'
            if isscalar(c0), c0=c0*ones(size(mesh1,2),1); end; c0=c0(:);
            if isscalar(c1), c1=c1*ones(size(mesh1,2),1); end; c1=c1(:);
            
            x=x.*sigma; x=x';
            C=zeros(m,1);
            parfor i=1:n
                point=mesh2(i,:);
                X0=abs(mesh1-repmat(point,m,1));
                d0=X0*c0;

                Ccol=zeros(m,1);
                for j=1:m
                    c=-0.5./(c1+d0(j));
                    Ccol(j)=((mesh1(j,:)-point).^2)*c;
                end
                C(i)=x*exp(Ccol);
            end
            
        otherwise
            error('corr.name must be gauss, exp, or turbulent');
    end
    fprintf('Matvec complete: %6.4f seconds\n',toc(tt));
    
else
    
    switch lower(name)
        case 'gauss'
            if isscalar(c0), c0=c0*ones(size(mesh1,2),1); end
            c0=-0.5./c0; c0=c0(:);
            C=zeros(m,n);
            parfor i=1:n
                point=mesh2(i,:);
                X=(mesh1-repmat(point,m,1)).^2;
                C(:,i)=sigma.*exp(X*c0);
            end
            
        case 'exp'
            if isscalar(c0), c0=c0*ones(size(mesh1,2),1); end
            c0=-0.5./c0; c0=c0(:);
            C=zeros(m,n);
            parfor i=1:n
                point=mesh2(i,:);
                X=abs(mesh1-repmat(point,m,1));
                C(:,i)=sigma.*exp(X*c0);
            end
            
        case 'turbulent'
            if isscalar(c0), c0=c0*ones(size(mesh1,2),1); end; c0=c0(:);
            if isscalar(c1), c1=c1*ones(size(mesh1,2),1); end; c1=c1(:);
            
            C=zeros(m,n);
            parfor i=1:n
                point=mesh2(i,:);
                X0=abs(mesh1-repmat(point,m,1));
                d0=X0*c0;

                Ccol=zeros(m,1);
                for j=1:m
                    c=-0.5./(c1+d0(j));
                    Ccol(j)=((mesh1(j,:)-point).^2)*c;
                end
                C(:,i)=sigma.*exp(Ccol);
            end
            
        otherwise
            error('corr.name must be gauss, exp, or turbulent');
    end
    
    C(C<spthresh)=0;
    C=sparse(C);
    
end



