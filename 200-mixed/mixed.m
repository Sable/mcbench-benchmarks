function [s2,b,u,Is2,C,H,q,loglik,loops] = mixed(y,X,Z,dim,s20,method);
%MIXED   Computes ML,REML,MINQE(I),MINQE(U,I),BLUE(b),BLUP(u) 
%        by Henderson's Mixed Model Equations Algorithm.
%    
%======================================================================
% Syntax:  
%   [s2,b,u,Is2,C,H,q,loglik,loops] = mixed(y,X,Z,dim,s20,method);
%
%======================================================================
% Model: Y=X*b+Z*u+e,
%        b=(b_1',...,b_f')' and u=(u_1',...,u_r')',
%        E(u)=0, Var(u)=diag(sigma^2_i*I_{m_i}), i=1,...,r
%        E(e)=0, Var(e)=sigma^2_{r+1}*I_n,
%        Var(y)=Sig=sum_{i=1}^{r+1} sigma^2_i*Sig_i.
%        We assume normality and independence of u and e.
%
% Inputs:  
%   y      - n-dimensional vector of observations.
%   X      - (n * k)-design matrix for 
%            fixed effects b=[b_1;...;b_f],
%            typically X=[X_1,...,X_f] for some X_i.
%   Z      - (n * m)-design matrix for 
%            random efects u=[u_1;...;u_r],
%            typically Z=[Z_1,...,Z_r] for some Z_i.
%   dim    - Vector of dimensions of u_i, i=1,...,r,
%            dim=[m_1;...;m_r], m=sum(dim). 
%   s20    - A prior choice of the variance components,
%            s20=[s20_1;...;s20_r;s20_{r+1}].
%            SHOULD BE POSITIVE for method>0
%   method - Method of estimation of variance components;
%            0:NO estimation, 1:ML, 2:REML, 3:MINQE(I), 4:MINQE(U,I)
%
%======================================================================
% Outputs: 
%   s2     - Estimated vector of variance components 
%            (sigma^2_1,..., sigma^2_{r+1})'.
%            A warning message appears if some of the estimated
%            variance components is negative or equal to zero.
%            In such cases the calculated Fisher information
%            matrices are inadequate.  
%   b      - k-dimensional vector of estimated fixed effects beta,
%            b=[b_1;...;b_f]=(X'Sig^{-1}X)^{+}X'Sig^{-1}y.
%   u      - m-dimensional vector of EBLUP's of random effects U,
%            u=[u_1;...;u_r]. 
%   Is2    - Fisher information matrix for variance components;
%            if method=0 the output is Is2=[]; 
%            if metod=3 or method=4 the output is inversion of the 
%            covariance matrix of MINQE calculated at estimated s2.
%   C      - g-inverse of Henderson's MME matrix, where
%            C=pinv([XX XZ; XZ' ZZ+inv(D)*s0]/s0), if inv(D) exists
%            or C=s0*[I 0; 0 D]*pinv([XX XZ*D; XZ' V]) otherwise
%   H      - Criterial matrix for MINQE calculated at priors s20;
%            if method=3 
%            H_ij=trace(Sig_0^{-1}*Sig_i*Sig_0^{-1}*Sig_j),
%            if method=4 
%            H_ij=trace((M*Sig_0*M)^{+}*Sig_i*(M*Sig_0*M)^{+}*Sig_j)
%   q      - (r+1)-dimensional vector of MINQE(U,I) quadratic forms
%            calculated at prior values s20;
%            if method=0,1,2 the output is q=[], otherwise 
%            q_i=y'*(M*Sig_0*M)^{+}*Sig_i*(M*Sig_0*M)^{+}*y.
%   loglik - Log-likelihood evaluated at the estimated parameters;
%            if method=1 loglik=log-likelihood(ML),
%            if method=2 loglik=log-likelihood(REML),
%            if method=3 or method=4 loglik=[],
%	     if method=0 loglik=informative value of 
%            log of the joint pdf of (y,u).
%   loops  - Number of loops.
%
%======================================================================
% REFERENCES
%
% Searle, S.R., Cassela, G., McCulloch, C.E.: Variance Components. 
% John Wiley & Sons, INC., New York, 1992. (pp. 275-286).
% 
% Witkovsky, V.: MATLAB Algorithm mixed.m for solving 
% Henderson's Mixed Model Equations.
% Technical Report, Institute of Measurement Science, 
% Slovak Academy of Sciences, Bratislava, Dec. 2001.
% See http://www.mathpreprints.com.
%  
% The algorithm mixed.m is available at
% http://www.mathworks.com/matlabcentral/fileexchange
% see the Statistics Category.
%
%======================================================================
% Ver.: 2.0
% Revised 21-Dec-2001 20:31:48
% Copyright (c) 1998-2001 Viktor Witkovsky

%======================================================================
% CONTACT ADDRESS:
% Viktor Witkovsky
% Institute of Measurement Science
% Slovak Academy of Sciences
% Dubravska cesta 9
% 84219 BRATISLAVA, Slovak Republic
% Tel:(+421905) 223191
% Fax:(+4212) 54775943
% E-mail: umerwitk@savba.sk
% http://nic.savba.sk/sav/inst/umer/
%======================================================================
%	BEGIN MIXED.M
%======================================================================
% 	This is the (only) required input. 
% 	The algorith mixed.m could be easily changed in such a way 
% 	that the required inputs will be y, a, XX, XZ, and ZZ, 
% 	and the call would be mixed(y,a,XX,XZ,ZZ,dim,s20,method); 
% 	instead of mixed(y,X,Z,dim,s20,method);
%======================================================================
y=y(:);
yy=y'*y;
Xy=X'*y;
Zy=Z'*y;
XX=X'*X;
XZ=X'*Z;
ZZ=Z'*Z;
a=[Xy;Zy];
% end of required input parameters
n=length(y);
[k,m]=size(XZ);
rx=rank(XX);
s20=s20(:);
r=length(s20)-1;
Im=eye(m);
loops=0;
%======================================================================
%	METHOD=0: 
%	No estimation of variance components 
%	Output is BLUE(b), BLUP(u), and C,
%       calculated at chosen values s20
%======================================================================
if method==0,
   s0=s20(r+1);
   d=s20(1)*ones(dim(1),1);
   for i=2:r,
       d=[d;s20(i)*ones(dim(i),1)];
   end;
   D=diag(d);
   V=s0*Im+ZZ*D;
   A=[XX XZ*D;XZ' V];
   A=pinv(A);
   C=s0*[A(1:k,1:k) A(1:k,k+1:k+m);...
     D*A(k+1:k+m,1:k) D*A(k+1:k+m,k+1:k+m)];  
   bb=A*a;
   b=bb(1:k);
   v=bb(k+1:k+m);
   u=D*v;
   Aux=yy-b'*Xy-u'*Zy;
   if all(s20),
   loglik=-((n+m)*log(2*pi)+n*log(s0)+log(prod(d))+Aux/s0)/2;
   else
   loglik=[];
   end;
   s2=s20;
   Is2=[];
   H=[];
   q=[];
   return;
end;
%======================================================================
%	METHOD=1,2,3,4: ESTIMATION OF VARIANCE COMPONENTS
%======================================================================
fk=find(s20<=0);
if any(fk),
   s20(fk)=100*eps*ones(size(fk));
   warning('Priors in s20 are negative or zeros !CHANGED!');
end;
sig0=s20;
s21=s20;
ZMZ=ZZ-XZ'*pinv(XX)*XZ;
q=zeros(r+1,1);
%======================================================================
%	START OF THE MAIN LOOP
%======================================================================
epss=0.000000001; % Given precission for stopping rule
crit=1;
while crit>epss,
      loops=loops+1;
      sigaux=s20;
      s0=s20(r+1);
      d=s20(1)*ones(dim(1),1);
      for i=2:r,
          d=[d;s20(i)*ones(dim(i),1)];
      end;
      D=diag(d);
      V=s0*Im+ZZ*D;
      W=s0*inv(V);
      T=inv(Im+ZMZ*D/s0);
      A=[XX XZ*D;XZ' V];
      bb=pinv(A)*a;
      b=bb(1:k);
      v=bb(k+1:k+m);
      u=D*v;
%======================================================================
% 	ESTIMATION OF ML AND REML OF VARIANCE COMPONENTS 
%======================================================================
      iupp=0;
      for i=1:r,
          ilow=iupp+1;
          iupp=iupp+dim(i);
          Wii=W(ilow:iupp,ilow:iupp);
          Tii=T(ilow:iupp,ilow:iupp);
          w=u(ilow:iupp);
          ww=w'*w;
          q(i)=ww/(s20(i)*s20(i));
          s20(i)=ww/(dim(i)-trace(Wii));
          s21(i)=ww/(dim(i)-trace(Tii));  
      end; 
      Aux=yy-b'*Xy-u'*Zy;
      Aux1=Aux-(u'*v)*s20(r+1);
      q(r+1)=Aux1/(s20(r+1)*s20(r+1));
      s20(r+1)=Aux/n;
      s21(r+1)=Aux/(n-rx);
         if method==1,
               crit=norm(sigaux-s20);
               H=[];
               q=[];
         elseif method==2,
               s20=s21;
               crit=norm(sigaux-s20);
               H=[];
               q=[];
         else
               crit=0;
      end;
end;
%======================================================================
%	END OF THE MAIN LOOP
%======================================================================
%	COMPUTING OF THE MINQE CRITERIAL MATRIX H
%======================================================================
if (method==3 | method==4),
   H=eye(r+1);
   if method==4,
      W=T;
      H(r+1,r+1)=(n-rx-m+trace(W*W))/(sigaux(r+1)*sigaux(r+1)); %VW
   else
      H(r+1,r+1)=(n-m+trace(W*W))/(sigaux(r+1)*sigaux(r+1));
   end;
   iupp=0;
   for i=1:r;
       ilow=iupp+1;
       iupp=iupp+dim(i);
       trii=trace(W(ilow:iupp,ilow:iupp));
       trsum=0;
       jupp=0;
       for j=1:r,
           jlow=jupp+1;
           jupp=jupp+dim(j);
           tr=trace(W(ilow:iupp,jlow:jupp)*W(jlow:jupp,ilow:iupp));
           trsum=trsum+tr;
           H(i,j)=((i==j)*(dim(i)-2*trii)+tr)/(sigaux(i)*sigaux(j));
       end;
       H(r+1,i)=(trii-trsum)/(sigaux(r+1)*sigaux(i));
       H(i,r+1)=H(r+1,i);
   end;
end;
%======================================================================
% 	SET THE RESULTS: MINQE(I), MINQE(U,I), ML, AND REML
%======================================================================
if (method==3 | method==4),   
   s2=pinv(H)*q;
   loglik=[];
else
   s2=s20;
end; 
fk=find(s2<10*epss);
if any(fk),
   warning('Estimated variance components are negative or zeros!');
end;
%======================================================================
% 	BLUE, BLUP, THE MME'S C MATRIX AND THE LOG-LIKELIHOOD
%======================================================================
s0=s2(r+1);
d=s2(1)*ones(dim(1),1);
for i=2:r,
    d=[d;s2(i)*ones(dim(i),1)];
end;
D=diag(d);
V=s0*Im+ZZ*D;
W=s0*inv(V);;
T=inv(Im+ZMZ*D/s0);
A=[XX XZ*D;XZ' V];
A=pinv(A);
C=s0*[A(1:k,1:k) A(1:k,k+1:k+m);...
  D*A(k+1:k+m,1:k) D*A(k+1:k+m,k+1:k+m)];	
bb=A*a;
b=bb(1:k);
v=bb(k+1:k+m);
u=D*v;
if (method==1),
   loglik=-(n*log(2*pi*s0)-log(det(W))+n)/2;
elseif (method==2),
   loglik=-((n-rx)*log(2*pi*s0)-log(det(T))+(n-rx))/2;
end; 
%======================================================================
%	FISHER INFORMATION MATRIX FOR VARIANCE COMPONENTS
%======================================================================
Is2=eye(r+1);
if (method==2 | method==4),
   W=T;
   Is2(r+1,r+1)=(n-rx-m+trace(W*W))/(s2(r+1)*s2(r+1)); %VW
else
   Is2(r+1,r+1)=(n-m+trace(W*W))/(s2(r+1)*s2(r+1));
end;
iupp=0;
for i=1:r;
   ilow=iupp+1;
   iupp=iupp+dim(i);
   trii=trace(W(ilow:iupp,ilow:iupp));
   trsum=0;
   jupp=0;
   for j=1:r,
       jlow=jupp+1;
       jupp=jupp+dim(j);
       tr=trace(W(ilow:iupp,jlow:jupp)*W(jlow:jupp,ilow:iupp));
       trsum=trsum+tr;
       Is2(i,j)=((i==j)*(dim(i)-2*trii)+tr)/(s2(i)*s2(j));
   end;
   Is2(r+1,i)=(trii-trsum)/(s2(r+1)*s2(i));
   Is2(i,r+1)=Is2(r+1,i);
end;
Is2=Is2/2;
%======================================================================
%	EOF MIXED.M
%======================================================================