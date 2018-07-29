function [logCr,logr]=gencorint(x,dim,tau,logr,p,w,svd,q)
%Syntax: [logCr,logr]=gencorint(x,dim,tau,logr,p,w,svd,q)
%________________________________________________________
%
% Calculates the generalized Correlation Integral (Cr) of a time
% series x.
%
% logCr is the the value of log(Cr).
% logr is log(range).
% x is the time series.
% dim is the embedding dimension.
% tau is the time delay.
% p is defines the norm.
% w is the Theiler's correction.
% svd is the number of singular values taken into account.
% q is the generalization index.
%
%
% References:
%
% Grassberger P, Procaccia I (1983): Characterization of strange
% attractors. Physical Review Letters 50(5):346-349
%
% Theiler J (1986): Spurious dimension from correlation algorithms
% applied tolimited time-series data. Physical Review A 34(3):2427-
% 2432
%
% Albano A M, Muench J, Schwartz C, Mees A I, Rapp P E, (1988):
% Singular-value decomposition and the Grassberger-Procaccia algorithm.
% Physical Review A38:3017-3026
% 
%
% Alexandros Leontitsis
% Department of Education
% University of Ioannina
% 45110 - Dourouti
% Ioannina
% Greece
%
% University e-mail: me00743@cc.uoi.gr
% Lifetime e-mail: leoaleq@yahoo.com
% Homepage: http://www.geocities.com/CapeCanaveral/Lab/1421
%
% June 15, 2001.

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
   dim=round(dim);
   % dim values must be above 0
   dim=dim(find(dim>0));
end

if nargin<3 | isempty(tau)==1
   tau=1;
else
   % tau must be either a scalar or a vector
   if min(size(tau))>1
      error('tau must be a scalar or a vector.');
   end
   % tau must be an integer
   tau=round(tau);
   % tau values must be above 0
   tau=tau(find(tau>0));
end

if nargin<4  | isempty(logr)==1
   r=(max(x)-min(x))/10*(1:20)'/20;
   logr=log10(r);
else
    % logr must be either a scalar or a vector
    if min(size(dim))>1
        error('logr must be a scalar or a vector.');
    end
    % if it is a scalar, it determines the maximum range
    if length(logr)==1
        div=logr;
        % div must be positive
        if div<=0
            error('logr must be a positive scalar or vector');
        end
        r=(max(x)-min(x))/div*(1:20)'/20;
        logr=log10(r);
    else
        logr=logr(:);
        r=10.^logr;
    end
end

if nargin<5 | isempty(p)==1
   p=inf;
else
   % p must be either a scalar or a vector
   if min(size(dim))>1
      error('p must be a scalar.');
   end
   % p values must be positive
   p=p(find(p>0));
end

if nargin<6  | isempty(w)==1
   w=1;
else
   % w must be either a scalar or a vector
   if min(size(w))>1
      error('w must be either a scalar or a vector.');
   end
   % w must be an integer
   w=round(w);
   % w must be positive
   w=w(find(w>0));
end

if nargin<7 | isempty(svd)==1
    svd=[];
else
    % svd must be a scalar or a vector
    if min(size(svd))>1
        error('svd must be either a scalar or a vector.');
    end
    % svd must be an integer
    svd=round(svd);
    % svd must be positive
    svd=svd(find(svd>0));
end

if nargin<8 | isempty(q)==1
    q=2;
else
    % q must be either a scalar or a vector
    if min(size(q))>2
        error('q must be either a scalar or a vector.');
    end
end

% Only one of dim, tau, p, w, or q should be vector
l=[length(dim),length(tau),length(p),length(w),length(svd),length(q)];
if length(find(l>1))>1
   error('Only one of dim, tau, p, w, svd, or q should be vector.');
end

m=max(l);
dim=ones(1,m).*dim;
tau=ones(1,m).*tau;
p=ones(1,m).*p;
w=ones(1,m).*w;
if isempty(svd)==0
   svd=ones(1,m).*svd;
end
q=ones(1,m).*q;

for i=1:m
   
   % Reconstruct the time-delay phase-space
   [Y,T]=phasespace(x,dim(i),tau(i));
   if isempty(svd)==0
      svd(i)=min(svd(i),dim(i));
      % SVD on X
      [u,s,v]=svd(Y,0);
      
      % Calculate the Principal Components
      pc=Y*v;
      
      % Reconstruct the first svd Principal Components
      Y=pc(:,1:svd(i))*v(:,1:svd(i))';
   end
   
   % Initialize the logCr
   Cr=zeros(size(r));
   
   if q(i)==2 % ...fast
       
       for i1=1:T-w(i)
           for i2=i1+w(i):T
               dist=norm(Y(i1,:)-Y(i2,:),p(i));
               s=find(r>dist);
               Cr(s)=Cr(s)+1;
           end
       end
       Cr=2*Cr/T/(T-1);
       logCr(:,i)=log10(Cr);
       
   else % slow...
       
       for i1=1:T
           c1=zeros(size(r));
           for i2=1:T
               if i1<i2-(w(i)-1) | i1>i2+(w(i)-1)
                   dist=norm(Y(i1,:)-Y(i2,:),p(i));
                   s=find(r>dist);
                   c1(s)=c1(s)+1;
               end
           end
           c1=c1/(T-1);
           if q(i)~=1
               Cr=Cr+c1.^(q(i)-1);
           else
               Cr=Cr+c1;
           end
       end
       if q(i)~=1
           Cr=Cr/T;
           logCr(:,i)=log10(Cr.^(1/(q(i)-1)));
       else
           Cr=log10(Cr)/T;
           logCr(:,i)=Cr;
       end
       
   end
end
