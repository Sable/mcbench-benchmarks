function xr=noiserSchreiber(x,K,L,r,repeat,auto)
%Syntax: xr=noiserSchreiber(x,K,L,r,repeat,auto)
%_______________________________________________
%
% Geometrical noise reduction for a time series, accordiong to 
% the extremely simple noise reduction method introduced by Screiber.
%
% xr is the vector/matrix with the cleaned time series.
% x is the time series.
% K is the number of dimensions before the corrected point.
% L is the number of dimensions after the corrected point.
% r is the range of the neighborhood.
% repeat is the number of iterations of the whole algorithm.
% auto automaticaly adjusts the range for every iteration if it is set to
%   'auto'.
%
%
% Note:
%
% K+L+1 should be equal to the embedding dimension.
%
%
% Reference:
%
% Schreiber T (1993): Extremely simple noise-reduction method.
% Physical Review E 47: 2401-2404
%
%
% Alexandros Leontitsis
% Department of Education
% University of Ioannina
% Ioannina
% Greece
% e-mail: leoaleq@yahoo.com
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

if nargin<2 | isempty(K)==1
   K=1;
else
   % K must be either a scalar or a vector
   if min(size(K))>1
      error('K must be a scalar or a vector.');
   end
   % K must contain integers
   if sum(abs(round(K)-K))~=0
      error('K must contain integers.');
   end
   % K values must be above 1
   if any(K<1)==1
      error('K values must be above 1.');
   end
end

if nargin<3 | isempty(L)==1
   L=1;
else
   % L must be either a scalar or a vector
   if min(size(L))>1
      error('L must be a scalar or a vector.');
   end
   % L must contain integers
   if sum(abs(round(L)-L))~=0
      error('L must contain integers.');
   end
   % L values must be above 1
   if any(L<1)==1
      error('L values must be above 1.');
   end
end

if nargin<4 | isempty(r)==1
   r=1.96*std(x);
else
   % r must be either a scalar or a vector
   if min(size(r))>1
      error('r must be a scalar or a vector.');
   end
   % r values must be above 0
   if any(r<0)==1
      error('r values must be above 0');
   end
end

if nargin<5 | isempty(repeat)==1
   repeat=1;
   repeat1=1;
else
   % repeat must be either a scalar or a vector
   if min(size(repeat))>1
      error('repeat must be a scalar or a vector.');
   end
   % repeat must be above 1
   if repeat<1
      error('repeat must be above 1.')
   end
   % repeat must be integer
   if sum(abs(round(repeat)-repeat))~=0
      error('repeat must contain integers.')
   end
   % The elements of repeat must be in increasing order
   if any(diff(repeat)<=0)==1
      error('The elements of repeat must be in increasing order.')
   end
   repeat1=repeat;
   repeat=1:max(repeat);
end

% Only one of K, L, r, or repeat should be vector
l=[length(K),length(L),length(r),length(repeat)];
if length(find(l>1))>1
   error('Only one of dim, tau, r, p, or repeat should be vector.');
end

m=max(l);
K=ones(1,m).*K;
L=ones(1,m).*L;
r=ones(1,m).*r;
repeat=ones(1,m).*repeat;

for i=1:m
    
    if repeat(i)==1
        % Make the phase-space
        [Y,T]=phasespace(x,K(i)+L(i)+1,1);
    else
        % The new Y
        Yr=[];
        [Y,T]=phasespace(xr(1+K(i)*(repeat(i)-1):n-L(i)*(repeat(i)-1),i-1),...
            K(i)+L(i)+1,1);
    end
    
    for j=1:T
        y=Y(j,:);
        lock=radnearest(y,Y,T,r(i),inf);
        lock(find(lock==j))=[];
        if length(lock)==0
            Yr(j,:)=y;
        else
            Ynearest=Y(lock,:);
            if length(lock)==1
                Yr(j,:)=Ynearest;
            else
                Yr(j,:)=mean(Ynearest);
            end
        end
    end
    
    
    % Calculate the reconstructed time series
    xr(:,i)=[zeros(K(i)*repeat(i),1);Yr(:,K(i)+1);zeros(L(i)*repeat(i),1)];
    
    if nargin==6 & auto=='auto'
        j=1+K(i)*repeat(i):n-L(i)*repeat(i);
        if repeat(i)==1
            r(i+1)=std(x(j)-xr(j),1);
        else
            r(i+1)=std(xr(j,i-1)-xr(j,i),1);
        end
    end
end
