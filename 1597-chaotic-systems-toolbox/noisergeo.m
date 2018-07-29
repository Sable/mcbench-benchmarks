function [xr,Yr]=noisergeo(x,dim,tau,r,q,p,theta)
%Syntax: [xr,Yr]=noisergeo(x,dim,tau,r,q,p,theta)
%________________________________________________
%
% Noise reduction by Local Geometric Projection.
%
% xr is the vector/matrix with the cleaned time series.
% Yr is the phase space of the last cleaned xr.
% x is the time series.
% dim is the embedding dimension.
% tau is the time delay.
% r can be either
%   real defining the neighborhood range.
%   integer defining the number of nearest neighbors.
% q can take one of the following values
%  'wAV' for the weighted average.
%  [an integer from 0 to dim-1] for the local geometric projection.
%  'mod' for the adaptive selection of the local neighborhood dimensions.
% p defines the norm.
% theta is the correction paprameter [0,1]
%   1: full correction.
%   0: no correction.
%
%
% References:
%
% Kantz H, Schreiber T, Hoffmann I, Buzug T, Pfister G, Flepp L G, Simonet
% J, Badii R, Brun E (1993): Nonlinear noise reduction: A case study on
% experimental data. Physical Review E 48: 1529-1538
%
% Leontitsis A., Bountis T., Pange J. (2004): An adaptive way for improving
% noise reduction using local geometric projection. CHAOS 14(6): 106-110
%
%
% Alexandros Leontitsis
% Department of Education
% University of Ioannina
% Ioannina
% Greece
%
% University e-mail: me00743@cc.uoi.gr
% Lifetime e-mail: leoaleq@yahoo.com
% Homepage: http://www.geocities.com/CapeCanaveral/Lab/1421
%
% 14 Jul 2001

if nargin<1 | isempty(x)==1
   error('You should provide a time series.');
else
   % x must be a vector
   if min(size(x))>1
      error('Invalid time series.');
   end
   x=x(:);
   % n is the time series length
   n=length(x);
end

if nargin<2 | isempty(dim)==1
   dim=2;
else
   % dim must be either a scalar or a vector
   if min(size(dim))>1
      error('dim must be a scalar or a vector.');
   end
   % dim must be an integer
   if round(dim)-dim~=0
      error('dim must be an integer.');
   end
   % dim values must be above 1
   if any(dim<1)==1
      error('dim values must be above 1');
   end
end

if nargin<3 | isempty(tau)==1
   tau=1;
else
   % tau must be either a scalar or a vector
   if min(size(tau))>1
      error('tau must be a scalar or a vector.');
   end
   % tau must be an integer
   if round(tau)-tau~=0
      error('tau must be an integer.');
   end
   % tau values must be above 1
   if any(tau<1)==1
      error('tau values must be above 1');
   end
end

if nargin<4 | isempty(r)==1
   r=dim+1;
else
   % r must be either a scalar or a vector
   if min(size(r))>1
      error('r must be a scalar or a vector.');
   end
   % r values must be above 0
   if any(r<=0)==1
      error('r values must be greater than 0');
   end
end

if nargin<5 | isempty(q)==1
   q=1;
end

if nargin<6 | isempty(p)==1
   p=2;
else
   % p must be either a scalar or a vector
   if min(size(p))>1
      error('p must be a scalar or a vector.');
   end
end

if nargin<7 | isempty(theta)==1
   theta=1;
else
   % theta must be either a scalar or a vector
   if min(size(theta))>1
      error('theta must be a scalar or a vector.');
   end
   % theta must be above 0 and bellow 1
   if theta<0 | theta>1
      error('theta must be above 0 and bellow 1.')
   end
end

% Only one of dim, tau, r, p or theta should be vector
l=[length(dim),length(tau),length(r),length(p),length(theta)];
if length(find(l>1))>1
   error('Only one of dim, tau, r, p, or theta should be vector.');
end

% Make the phase-space
[Y,T]=phasespace(x,dim,tau);


m=max(l);
dim=ones(1,m).*dim;
tau=ones(1,m).*tau;
r=ones(1,m).*r;
p=ones(1,m).*p;
theta=ones(1,m).*theta;

for i=1:m
        
    % Initialize Yr
    Yr=zeros(T,dim(i));
    
    % For every phase-space point
    for j=1:T
        
        % Locate the j-th point
        y=Y(j,:);
        
        % Check neighborhood or neighbors
        if mod(r(i),floor(r(i)))==0
            lock=Knearest(y,Y,r(end)+1,p(i));
        else
            lock=radnearest(y,Y,T,r(i),p(i));
            lock(find(j==lock))=[];
        end
        
        if isempty(lock)==1
            Yr(j,:)=y;
        elseif q=='wAV'
            % The calculations for the weighted average
            Ynearest=Y(lock,:);
            w=[];
            for k=1:length(lock)
                w(k)=norm(y-Ynearest(k,:))/2/r(i);
                w(k)=exp(-w(k)^2);
                Ynearest(k,:)=Ynearest(k,:)*w(k);
            end
            Yr(j,:)=sum(Ynearest)/sum(w);
        else
            % All the neighboring points have equal weight
            if length(lock)<dim(i)
                Yr(j,:)=mean(Y(lock,:));
            else
                % Make the matrix of the local neighborhood
                Ynearest=Y(lock,:);
                %Ynearest=quality3(Ynearest,2);
                %Ynearest=quality2(Ynearest,2,.99,r,y);
                Ynearest=quality(Ynearest,2,.7);
                % Neigborhood average
                ybar=mean(Ynearest);
                % Subtract the average from the neighborhood poionts
                Ynearest=Ynearest-ones(size(Ynearest,1),1)*ybar;
                % SVD on the local neighborhood
                [u,s,v]=svd(Ynearest,0);
                % Either use the Adaptive selection ...
                if q=='mod'
                    s=diag(s);
                    d=s(1:dim(i)-1)./(s(2:dim(i))+eps);
                    q=find(d==max(d));
                    Yr(j,:)=y-(y-ybar)*(v(:,q+1:dim(i))*v(:,q+1:dim(i))');
                % ... or use a predifined q
                else
                    Yr(j,:)=y-(y-ybar)*(v(:,dim(i)-q:dim(i))*v(:,dim(i)-q:dim(i))');
                end
            end
        end
        Yr(j,:)=theta(i)*Yr(j,:)+(1-theta(i))*Y(j,:);
    end
    
    
    % Initialize xr
    xr(:,i)=zeros(n,1);
    times(:,i)=zeros(n,1);
    
    % Calculate the reconstructed time series
    for j=1:dim
        xr(1+(j-1)*tau:T+(j-1)*tau,i)=xr(1+(j-1)*tau:T+(j-1)*tau,i)+Yr(:,j);
        times(1+(j-1)*tau:T+(j-1)*tau,i)=times(1+(j-1)*tau:T+(j-1)*tau,i)+1;
    end
    xr(:,i)=xr(:,i)./times(:,i);
    xr(:,i)=xr(:,i)-mean(xr(:,i)-x);
    
end
