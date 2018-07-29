function [w,xm,ym,modes,bderr,modcofs]=elipmodes(...
                 a,b,typ,nfrqs,step,nser,nbp,noplot)      
% [w,xm,ym,modes,bderr,modcofs]=elipmodes(...
%                a,b,typ,nfrqs,step,nser,nbp,noplot)
% See Article 10.7 (using a different method)
%
% This function computes natural frequencies and mode
% shapes of an elliptic membrane using the method
% presented by Dr. Cleve Moler in function membranetx.
%                    ---input--- 
% a,b     - ellipse major and minor semi-diameters
% typ     - 1 for modes symmetric about the x-axis
%           and zero on the boundary
%           2 for antisymmetric modes which are
%           zero on the boundary
%           3 for symmetric modes with zero normal
%           derivative on the boundary
%           4 for antisymmetric modes with zero
%           normal derivative on the boundary
% nfrqs   - number of frequencies to be computed
% step    - stepsize used in the frequency search.
%           A typical value is 0.01
% nser    - number of Bessel series terms used to 
%           approximate the modal functions. Values
%           of nser would typically be chosen
%           between 15 and 20.
% nbp     - number of boundary points used to
%           impose the boundary conditions. Taking
%           nbp equal to 101 is usually adequate.
% noplot  - an arbitrary value is input for this
%           variable to skip plotting 
%                    ---output---
% w       - vector of natural frequencies
% xm,ym   - coordinate matrices for plotting the
%           modal surfaces
% modes   - array in which modes(:,:,j) describes
%           the j'th modal surface
% modcofs - matrix in which modcofs(:,j) contains
%           the series coefficients for mode j.
%           These coefficients are scaled to make
%           the largest surface value of each 
%           mode equal unity.

%           by Howard Wilson, November,2004

if nargin<8, doplot=1; else, doplot=2; end
if nargin==0   % Interactive input
  disp(' ')
  disp('ELLIPTIC MEMBRANE FREQUENCIES')
  disp(' COMPUTED BY MOLER''S METHOD')
  disp(' ')
  [a,b]=readstr(...
            'Input semi-diameters a and b : ');
  disp(' ')      
  disp('Input function type, number of series')       
  disp(['terms, and number of ',...
             'boundary points.']); 
  [typ,nser,nbp]=readstr(...
         '(typical values are 1,15,101)  ? : ');
  disp(' ')   
  disp('Input number of frequencies sought')
  disp('and search increment size.')  
  [nfrqs,step]=readstr(...
            '(typical values are 20,.01)  ? : ');
  disp(' '), disp('Do you want modal plots ?')
  doplot=input('( 1 for yes or 2 for no)  ? : ');
end

% Generate points for boundary conditions
[x,y]=elipnts(a,b,nbp); x=x(:); y=y(:);
r=sqrt(x.*x+y.*y); th=atan2(y,x);

% Specify even or odd modes
if typ==1 | typ==3, 
    n=0:nser-1; thmat=cos(th*n); mult=1;
else
  n=1:nser; thmat=sin(th*n); mult=2;
end

% Search for frequencies
was=asymtroe(typ,a,b,0:nfrqs,1:nfrqs);
was=sort(was(:)); wmin=was(1)/2;
wmax=2*was(nfrqs); tic;
if typ==1 | typ==2    
  w=manym(@fzerobv,nfrqs,wmin,step,wmax,...
             n,r,thmat);
  w=w(:); nw=length(w);
  modcofs=zeros(nser,nw); cmat=[]; dmat=[];      
  % Evaluate series coefficients for the
  % Dirichlet boundary condition
  for j=1:nw
    [dumy,vj]=fzerobv(w(j),n,r,thmat);
    modcofs(:,j)=vj;
  end    
else
  [cmat,dmat]=elpbdrc(a,b,r,th,typ,nser);
  w=manym(@fzrobgrd,nfrqs,wmin,step,wmax,...
              nser,r,typ,cmat,dmat);
  w=w(:); nw=length(w);
  modcofs=zeros(nser,nw);        
  % Evaluate series coefficients for the
  % Neumann boundary condition
  for j=1:length(w)
    [dumy,vj]=fzrobgrd(w(j),nser,r,typ,...
        cmat,dmat); modcofs(:,j)=vj;
  end   
end

% Evaluate modal functions on a curvilinear
% coordinate grid
neta=181; nxi=16; %neta=81; nxi=10;
%neta=145; nxi=13;
[xm,ym,modes,bderr,modcofs]=modeshap(a,b,w,typ,...
                   modcofs,neta,nxi,r,cmat,dmat);
tim=toc; if doplot~=1, return; end

while 0
sa=num2str(a); sb=num2str(b);
sw=num2str(nw); st=num2str(tim);
disp(['Using a = ',sa,' and b = ',sb,...
      ', ',sw,' frequencies'])
disp(['and modes were found in ',...
       num2str(tim),' secs.'])
end  

t=linspace(0,2*pi,201); xb=a*cos(t); yb=b*sin(t);

% Show animated modal plots  
showmo(a,b,typ,w,xm,ym,modes,2);

%==========================================

function varargout=readstr(strng)
% varargout=readstr(strng) reads several
% data items on one line
if nargin==0, strng='>> ?  : '; end
f=input(strng,'s'); f=eval(['[',f,']']);
for j=1:length(f), varargout{j}=f(j); end

%==========================================

function [x,y,modes,bderr,modcofs]=modeshap(a,b,...
              w,typ,modcofs,neta,nxi,rb,cmat,dmat)
% [x,y,modes,bderr,modcofs]=modeshap(a,b,w,typ,...
%                   modcofs,neta,nxi,rb,cmat,dmat)

% function modeshap evaluates the modes for known
% frequencies and series coefficients. Normalized
% coefficients for the series expansions, and the 
% maximum error in satisfaction of the boundary
% conditions are also obtained.

% Get an elliptical coordinate grid
[x,y]=elipmap(a,b,neta,nxi); s=size(x);
x=x(:); y=y(:); nw=length(w);
nfun=size(modcofs,1);

% Use polar coordinates to evaluate the modal
% function series
r=sqrt(x.*x+y.*y); th=atan2(y,x);
if typ==1 | typ==3 % even valued modes
  N=0:nfun-1; thmat=cos(th*N);
else             % odd valued modes
  N=1:nfun; thmat=sin(th*N);
end

% Place successive modes as layers in a 3D      
% array
modes=zeros([s,nw]); bderr=zeros(nw,1);
for j=1:nw
    
  % Normalize maximum mode height to unity  
  mj=(besselj(N,w(j)*r).*thmat)*modcofs(:,j);
  [dumy,k]=max(abs(mj)); mbj=mj(k);
  mj=mj/mbj; modcofs(:,j)=modcofs(:,j)/mbj;
  modes(:,:,j)=reshape(mj,s);
end
x=reshape(x,s); y=reshape(y,s);

if typ<3
  % max error for Dirichlet boundary condition  
  bderr=max(abs(squeeze(modes(:,end,:))))';
else
  % max error for Neumann boundary condition  
  for k=1:nw
    wk=w(k);  
    if typ==3, J=besselj(-1:nfun,wk*rb);
    else, J=besselj(0:nfun+1,wk*rb); end
    A=wk/2*(J(:,1:end-2)-J(:,3:end)).*cmat+...
    J(:,2:end-1).*dmat; 
    bderr(k)=max(abs(A*modcofs(:,k)));
  end
end    

%==========================================

function [sigma,c]=fzerobv(w,n,r,thmat)
% [sigma,c]=fzerobv(w,n,r,thmat)
% This is the primary function used to
% compute frequencies for the case of zero
% boundary deflection. The natural fre-
% quencies are located where the smallest
% singular value of matix A has a relative
% minimum.
A=besselj(n,w*r).*thmat; N=length(n);
scale=diag(sparse(1./sqrt(sum(A.*A))));
A=A*scale; [u,s,v]= svd(A,0);
sigma=s(N,N); c=scale*v(:,N);

%==========================================

function [C,D]=elpbdrc(a,b,r,th,typ,nf)
% [C,D]=elpbdrc(a,b,r,th,typ,nf)
% This function computes matrices used to
% formulate a Neumann type boundary
% condition for an elliptic membrane
% The boundary condition has the form 
%   w*J'(nu,w*r)*C+J(nu,w*r)*D=0
% where either
% nu=0:nf-1 for even modes or
% nu=1:nf for odd modes
%
% a,b  - ellipse semi-diameters
% r,th - polar coordinates of points
%        on the top half of the ellipse
% typ  - 3 for even valued functions or
%        4 for odd valued functions
% nf   - the number of terms in the
%        modal function series
% C,D  - matrices used to form the grad-
%        ient type boundary condition.

r=r(:); th=th(:); c=cos(th); s=sin(th);
phi=c/a^2; psi=s/b^2; len=abs(phi+i*psi);
phi=phi./len; psi=psi./len;
if rem(typ,2)==1  % even valued function
  n=0:nf-1; C=c.*phi+s.*psi;
  C=C(:,ones(1,nf)).*cos(th*n); 
  D=s.*phi-c.*psi; D=D(:,ones(1,nf));
  D=(1./r)*n.*D.*sin(th*n);
else              % odd valued function
  n=1:nf; C=c.*phi+s.*psi;
  C=C(:,ones(1,nf)).*sin(th*n);
  D=s.*phi-c.*psi; D=D(:,ones(1,nf));
  D=(-1./r)*n.*D.*cos(th*n);
end

%==========================================

function [sig,c]=fzrobgrd(w,nf,r,typ,cmat,dmat)
% [sig,c]=fzrobgrd(w,nf,r,typ,cmat,dmat)
% This function formulates the boundary
% condition for a membrane with zero normal
% derivative on the edge.
if typ==3, J=besselj(-1:nf,w*r);
else, J=besselj(0:nf+1,w*r); end
A=w/2*(J(:,1:end-2)-J(:,3:end)).*cmat+...
                   J(:,2:end-1).*dmat;  
scale=diag(sparse(1./sqrt(sum(A.*A))));
A=A*scale; [u,s,v]= svd(A,0);
sig=s(nf,nf); c=scale*v(:,nf);

%==========================================

function [J,Jp]=Jeval(n,z)
% [J,Jp]=Jeval(n,z)
% This function evaluates J=besselj(n,z)
% and Jp=Besselj'(n,z)=...
% (besselj(n-1,z)-besselj(n+1,z))/2;
J=besselj([n(1)-1,n(:)',n(end)+1],z(:));
Jp=(J(:,1:end-2)-J(:,3:end))/2;
J=J(:,2:end-1);

%==========================================

function [x,y]=elipnts(a,b,n,nu)
% [x,y]=elipnts(a,b,n,nu)
% elipnts generates points equally spaced
% with respect to arc length on the top 
% half of an ellipse
if nargin<4, nu=500; end
tu=pi/(nu-1)*(0:nu-1)';
xu=a*cos(tu); yu=b*sin(tu);
su=[0;cumsum(abs(diff(xu+i*yu)))];
s=su(end)/(n-1)*(0:n-1)';
x=interp1q(su,xu,s); y=interp1q(su,yu,s);

%==========================================

function [x,y]=elipmap(a,b,neta,nxi,doplot)
% [x,y]=elipmap(a,b,neta,nxi,doplot)
% This function uses elliptical coordinates
% to compute a curvilinear coordinate grid
% on the interior of an ellipse
if nargin == 0
  doplot=1; nxi=8; neta=81; a=1; b=.5;
end
h=sqrt(a^2-b^2); r=atanh(b/a);
%[xi,eta]=meshgrid(linspace(0,r,nxi),...
%                  linspace(-pi,pi,neta));
rr=asinh(linspace(0,b/sqrt(a^2-b^2),nxi));
[xi,eta]=meshgrid(rr,linspace(-pi,pi,neta));              
z=h*cosh(xi+i*eta); x=real(z); y=imag(z);
if nargin > 4 | exist('doplot')
  plot(x,y,'k',x',y','k');
  title('ELLIPTICAL COORDINATE SYSTEM')
  xlabel('x axis'), ylabel('y axis')
  axis equal, shg
end

%==========================================

function [x,fmin]=manym(func,nrts,a,step,b,varargin)
% [x,fmin]=manym(func,nrts,a,step,b,varargin)
% This function searches for several minima of 
% a general function in a given interval.
% func     - handle for the function analyzed
% nrts     - number of roots sought
% a        - lower search limit 
% step     - the interval s searched in successive
%            increments of length step.
% b        - upper search limit
% varargin - auxiliary parameters needed by func
% x, fmin  - vector of minima and function values

f=[0 0 0]; x=[]; fmin=[]; nmin=0;
t=[a,a+step,a+2*step];
f(1)=feval(func,t(1),varargin{:});
f(2)=feval(func,t(2),varargin{:});
opts=optimset('tolx',1e-12);
while nmin<nrts & t(3)<= b  
  f(3)=feval(func,t(3),varargin{:});
  if f(1) > f(2) & f(2) < f(3)
    [xk,fk]=fminbnd(func,t(1),t(3),opts,...
                    varargin{:});
    x=[x,xk]; fmin=[fmin,fk]; nmin=nmin+1; 
  end
  t(1:2)=t(2:3); f(1:2)=f(2:3); t(3)=t(3)+step;
end

%==========================================

function showmo(a,b,typ,frqs,x,y,modes,tpause)
% showmo(a,b,typ,frqs,x,y,modes,tpause)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function makes surface or contour
% plots of the modal surfaces of a general 
% membrane for various frequencies. The 
% interactive part of the data input asks for
% a vector of modal indices (such as 1:5). If
% negative values are input (such as -(1:5)),
% then contour plots are made. Otherwise, 
% animated surface plots are presented.
%
% a,b    - ellipse semi diameters
% typ    - type of boundary condition.
%          1, 2, 3 or 4
% frqs   - vector of sorted frequencies
% x,y    - arrays of points defining the
%          curvilinear coordinate grid
% modes  - array of modal surfaces for 
%          the corresponding frequencies

if nargin<8, tpause=0; end
xmin=min(x(:)); xmax=max(x(:));
ymin=min(y(:)); ymax=max(y(:));
zmax=max(abs(modes(:)));
a=(xmax-xmin)/2; b=(ymax-ymin)/2;
th=linspace(0,2*pi,201)';
xx=a*cos(th); yy=b*sin(th);
nf=25; ft=cos(linspace(0,4*pi,nf));
nfrqs=length(frqs); ne=num2str(nfrqs);
%scalz=0.5/zmax*max(xmax-xmin,ymax-ymin);
scalz=1.0/zmax*max(xmax-xmin,ymax-ymin);
range=[xmin,xmax,ymin,ymax,-scalz,scalz];

while 0
disp(' ')
disp('   MODAL PLOTS FOR AN ELLIPTIC MEMBRANE')
%disp(' ')
disp(['The highest allowable frequency ',...,
      'index is ',ne])
end  

str1=['A = ',num2str(a),',  B = ',...
      num2str(b),',  TYPE = ',num2str(typ)];  
%%while 1
    
   while 0 
   jlim=[];
   while isempty(jlim), disp(' ')
     disp(['Give a vector of mode ',...
           'indices (such as 1:2:10 or']);
     jlim=input('input 0 to stop) > ? ');
   end
   if any(jlim<0), jlim=abs(jlim); pltype=1;
   else, pltype=2; end
   jj=find(jlim>nfrqs);
   if length(jj)>0
     disp(['The largest allowable ',...
           'modal index is ',ne])
     pause(2), jlim(jj)=[];
   end
   if any(jlim==0)
     disp(' '), disp('All done'), return
   end
   end
   
   jlim=1:10; pltype=2;
   for j=jlim
       
      %u=scalz*modes(:,:,j); 
      h=.25*a; u=modes(:,:,j);
      [dumy,k]=max(abs(u(:)));
      u=h/u(k)*u;
      
      if pltype==1
        % Draw contours  
        %u=modes(:,:,j);
        contour(x,y,u,60);
        axis equal, colormap([127/255 1 212/255])
        % colormap('default')
        str2=['FOR MODE ',num2str(j),...
           ',  OMEGA = ',num2str(frqs(j),6)];
        title({str2;str1})
        hold on; plot(xx,yy,'k');
        axis off, hold off, shg
      else
        % Draw animated surface 
        for kk=1:nf
           %surf(x,y,ft(kk)*u), axis equal
           surf(x,y,ft(kk)*1.5*u), axis equal
           %axis([xmin,xmax,ymin,ymax,-h,h]);
           axis([xmin,xmax,ymin,ymax,-1.5*h,1.5*h]);
           xlabel('x axis'), ylabel('y axis')
           zlabel('u(x,y)'), axis on
           str2=['FOR MODE ',num2str(j),...
           ',  OMEGA = ',num2str(frqs(j),6)];
           title({str2;str1})
           %colormap([1 1 0]), drawnow, shg
           %colormap('default'), drawnow, shg
           colormap([127/255 1 212/255])
           drawnow, shg, pause(.05)
        end
      
      end      
      if tpause==0, pause; else, pause(tpause); end
   end
%%end

%==========================================

function w=asymtroe(type,a,b,m,k)
% w=asymtroe(type,a,b,m,k) computes asymptotic
% approximations for zeros of Mc1 or Ms1
r=b/a; M=length(m); K=length(k);
m=m(:)*ones(1,K); k=ones(M,1)*k(:)';
if type==1
  w=((k-1/2)*pi+(m+1/2)*r+...
     (m.^2+m+1)./(4*k-2)*(r^2/pi))/b;
else
  w=(k*pi+(m-1/2)*r+...
    ((m-1).^2+m)./(4*k)*(r^2/pi))/b; 
end    