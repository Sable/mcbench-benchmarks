function trusvibs      
% Example: trusvibs from Article 10.4
% ~~~~~~~~~~~~~~~~~
%
% This program analyzes natural vibration modes 
% for a general plane pin-connected truss. The 
% direct stiffness method is employed in 
% conjunction with eigenvaue calculation to 
% evaluate the natural frequencies and mode 
% shapes. The truss is defined in terms of a 
% set of nodal coordinates and truss members 
% connected to different nodal points. Global 
% stiffness and mass matrices are formed. Then 
% the frequencies and mode shapes are computed 
% with provision for imposing zero deflection 
% at selected nodes. The user is then allowed 
% to observe animated motion of the various 
% vibration modes.
%
% User m functions called: 
%        eigsym, crossdat, drawtrus, eigc,
%        assemble, elmstf, cubrange, genprint

% clear; disp(' '); kf=1; idux=[]; iduy=[];
global x y inode jnode elast area rho idux iduy
kf=1; idux=[]; iduy=[]; disp(' ')
%disp(['Modal Vibrations for a Pin ', ...
%      'Connected Truss']); disp(' ');

% A sample data file defining a problem is 
% given in crossdat.m

while 0
disp(['Give the name of a function which ', ...
      'creates your input data']);
disp(['Do not include .m in the name ', ...
      '(use crossdat as an example)']);
filename=input('>? ','s');
eval(filename); disp(' ');
end
eval('crossdat');

% Assemble the global stiffness and 
% mass matrices
[stiff,masmat]= ...
  assemble(x,y,inode,jnode,area,elast,rho);

% Compute natural frequencies and modal vectors 
% accounting for the fixed nodes
ifixed=[2*idux(:)-1; 2*iduy(:)];
[modvcs,eigval]=eigc(stiff,masmat,ifixed);
natfreqs=sqrt(eigval); 

% Set parameters used in modal animation
nsteps=31; s=sin(linspace(0,6.5*pi,nsteps));
x=x(:); y=y(:); np=2*length(x);
bigxy=max(abs([x;y])); scafac=.05*bigxy;
highmod=size(modvcs,2); hm=num2str(highmod); 

% Show animated plots of the vibration modes
%while 1
while 0
  disp('Give the mode numbers to be animated?');
  disp(['Do not exceed a total of ',hm, ...
        ' modes.']); disp('Input 0 to stop');
  if kf==1, disp(['Try 1:',hm]); kf=kf+1; end  
  str=input('>? ','s'); 
  nmode=eval(['[',str,']']); 
end
  %nmode=1:12;
  nmode=[1:3,5,6,8:11];
  nmode=nmode(find(nmode<=highmod));
  %if sum(nmode)==0; break; end
  if sum(nmode)==0; return; end
  % Animate the various vibration modes 
  hold off; clf; ovrsiz=1.1; 
  w=cubrange([x(:),y(:)],ovrsiz);
  axis(w); axis('square'); axis('off'); hold on;
  for kk=1:length(nmode)  % Loop over each mode
    kkn=nmode(kk); 
    titl=['Truss Vibration Mode Number ', ...
          num2str(kkn)];
    dd=modvcs(:,kkn); mdd=max(abs(dd));
    dx=dd(1:2:np); dy=dd(2:2:np); 
    clf; pause(1);
    % Loop through several cycles of motion 
    for jj=1:nsteps           
      sf=scafac*s(jj)/mdd; 
      xd=x+sf*dx; yd=y+sf*dy; clf;
      axis(w); axis('square'); axis('off');
      drawtrus(xd,yd,inode,jnode); title(titl);
      drawnow; figure(gcf), pause(.05) 
   end
   pause(1)
  end
%end
disp(' ');

%=============================================

function crossdat
% [inode,jnode,elast,area,rho]=crossdat
% This function creates data for the truss
% vibration program. It can serve as a model
% for other configurations by changing the
% function name and data quantities       
% Data set: crossdat
% ~~~~~~~~~~~~~~~~~~
%
% Data specifying a cross shaped truss.
%
%----------------------------------------------

global x y inode jnode elast area rho idux iduy

% Nodal point data are defined by:
%   x - a vector of x coordinates
%   y - a vector of y coordinates
x=10*[.5 2.5 1 2 0 1 2 3 0 1 2 3 1 2];
y=10*[ 0   0 1 1 2 2 2 2 3 3 3 3 4 4];

% Element data are defined by:
%   inode - index vector defining the I-nodes
%   jnode - index vector defining the J-nodes
%   elast - vector of elastic modulus values
%   area  - vector of cross section area values
%   rho   - vector of mass per unit volume 
%           values
inode=[1 1 2 2 3 3 4 3 4 5 6 7 5 6 6 6 7 7 7 ...
       8 9 10 11 10 11 10 11 13];
jnode=[3 4 3 4 4 6 6 7 7 6 7 8 9 9 10 11 10 ...
       11 12 12 10 11 12 13 13 14 14 14];
elast=3e7*ones(1,28);
area=ones(1,28); rho=ones(1,28);

% Any points constrained against displacement 
% are defined by:
%   idux - indices of nodes having zero 
%          x-displacement
%   iduy - indices of nodes having zero 
%          y-displacement
idux=[1 2]; iduy=[1 2];

%=============================================

function drawtrus(x,y,i,j)
%
% drawtrus(x,y,i,j)
% ~~~~~~~~~~~~~~~~~
%
% This function draws a truss defined by nodal
% coordinates defined in x,y and member indices 
% defined in i,j.
%
% User m functions called: none
%----------------------------------------------

hold on;
for k=1:length(i)
   %plot([x(i(k)),x(j(k))],[y(i(k)),y(j(k))]);
   xx=[x(i(k)),x(j(k))]; yy=[y(i(k)),y(j(k))];
   plot(xx,yy,'b',xx,yy,'ob');   
end

%=============================================

function [vecs,eigvals]=eigc(k,m,idzero)
%
% [vecs,eigvals]=eigc(k,m,idzero)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes eigenvalues and 
% eigenvectors for the problem 
%            k*x=eigval*m*x 
% with some components of x constrained to 
% equal zero. The imposed constraint is
%            x(idzero(j))=0 
% for each component identified by the index 
% matrix idzero.
%
% k       - a real symmetric stiffness matrix 
% m       - a positive definite symmetric mass 
%           matrix
% idzero  - the vector of indices identifying 
%           components to be made zero
%
% vecs    - eigenvectors for the constrained 
%           problem. If matrix k has dimension 
%           n by n and the length of idzero is 
%           m (with m<n), then vecs will be a 
%           set on n-m vectors in n space
% eigvals - eigenvalues for the constrained 
%           problem. These are all real.
%
% User m functions called:  eigsym
%----------------------------------------------

n=size(k,1); j=1:n; j(idzero)=[]; 
c=eye(n,n); c(j,:)=[];
[vecs,eigvals]=eigsym((k+k')/2, (m+m')/2, c);

%=============================================

function [evecs,eigvals]=eigsym(k,m,c)
%
% [evecs,eigvals]=eigsym(k,m,c)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function solves the eigenvalue of the
% constrained eigenvalue problem
%    k*x=(lambda)*m*x, with c*x=0.
% Matrix k must be real symmetric and matrix
% m must be symmetric and positive definite,
% otherwise computed results will be wrong.
%
% k       - a real symmetric matrix
% m       - a real symmetric positive 
%           definite matrix
% c       - a matrix defining the constraint 
%           condition c*x=0. This matrix is
%           omitted if no constraint exists.
%
% evecs   - matrix of eigenvectors orthogonal
%           with respect k and m. The
%           following relations apply:
%           evecs'*m*evecs=identity_matrix
%           evecs'*k*evecs=diag(eigvals).
% eigvals - a vector of the eigenvalues
%           sorted in increasing order 
%
% User m functions called: none
%----------------------------------------------

if nargin==3
  q=null(c); m=q'*m*q; k=q'*k*q;
end
u=chol(m); k=u'\k/u; k=(k+k')/2;
[evecs,eigvals]=eig(k);
[eigvals,j]=sort(diag(eigvals));
evecs=evecs(:,j); evecs=u\evecs;
if nargin==3, evecs=q*evecs; end

%=============================================

function [stif,masmat]= ...
  assemble(x,y,id,jd,a,e,rho)
%
% [stif,masmat]=assemble(x,y,id,jd,a,e,rho)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function assembles the global 
% stiffness matrix and mass matrix for a 
% plane truss structure. The mass density of 
% each element equals unity.
%
% x,y   - nodal coordinate vectors
% id,jd - nodal indices of members
% a,e   - areas and elastic moduli of members
% rho   - mass per unit volume of members
%
% stif  - global stiffness matrix
% masmat- global mass matrix
%
% User m functions called: elmstf
%----------------------------------------------

numnod=length(x); numelm=length(a); 
id=id(:); jd=jd(:);
stif=zeros(2*numnod); masmat=stif;
ij=[2*id-1,2*id,2*jd-1,2*jd];
for k=1:numelm, kk=ij(k,:);
  [stfk,volmk]= ...
    elmstf(x,y,a(k),e(k),id(k),jd(k));
  stif(kk,kk)=stif(kk,kk)+stfk;  
  masmat(kk,kk)=masmat(kk,kk)+ ...
                rho(k)*volmk/2*eye(4,4); 
end

%=============================================

function [k,vol]=elmstf(x,y,a,e,i,j)
%
% [k,vol]=elmstf(x,y,a,e,i,j)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function forms the stiffness matrix for 
% a truss element. The member volume is also 
% obtained.
%
% User m functions called: none
%----------------------------------------------

xx=x(j)-x(i); yy=y(j)-y(i); 
L=norm([xx,yy]); vol=a*L;
c=xx/L; s=yy/L; k=a*e/L*[-c;-s;c;s]*[-c,-s,c,s];

%=============================================

function range=cubrange(xyz,ovrsiz)
%
% range=cubrange(xyz,ovrsiz)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function determines limits for a square 
% or cube shaped region for plotting data values 
% in the columns of array xyz to an undistorted 
% scale
%
% xyz    - a matrix of the form [x,y] or [x,y,z]
%          where x,y,z are vectors of cooordinate
%          points
% ovrsiz - a scale factor for increasing the
%          window size. This parameter is set to
%          one if only one input is given.
%
% range  - a vector used by function axis to set
%          window limits to plot x,y,z points
%          undistorted. This vector has the form
%          [xmin,xmax,ymin,ymax] when xyz has
%          only two columns or the form 
%          [xmin,xmax,ymin,ymax,zmin,zmax]
%          when xyz has three columns.
%
% User m functions called:  none
%----------------------------------------------

if nargin==1, ovrsiz=1; end
pmin=min(xyz); pmax=max(xyz); pm=(pmin+pmax)/2;
pd=max(ovrsiz/2*(pmax-pmin));
if length(pmin)==2
  range=pm([1,1,2,2])+pd*[-1,1,-1,1];
else
  range=pm([1 1 2 2 3 3])+pd*[-1,1,-1,1,-1,1];
end