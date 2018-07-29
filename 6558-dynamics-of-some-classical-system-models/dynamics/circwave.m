function [u,X,Y,tcp]=circwave(lam,r,th,t,r0,w)
% [u,x,y,tcp]=circwavn(lam,r,th,t,r0,w)
% See Article 9.5
% This function computes the wave response in a
% circular membrane having an oscillating force
% at a point on the radius on the x axis.

%disp(' ')
%disp('MOTION OF A CIRCULAR MEMBRANE')
%disp('  WITH AN OSCILLATING LOAD')
%disp(' ')
%s=input('Press return to begin computation ',...
%        's'); disp(' '), tic;
tic;
if nargin==0 
   lam=beszeros(0:20,1:20); tcp(1)=toc; r0=.4;
   %th=linspace(0,2*pi,61); r=linspace(0,1,15);
   th=linspace(0,2*pi,101); r=linspace(0,1,16);
   w=14.9; % w=11.8; t=linspace(0,5,100);
   t=linspace(0,5,100);
end

% Compute the series coefficients
[nj,nk]=size(lam); r=r(:)'; nr=length(r);
th=th(:); nth=length(th); nt=length(t);
N=repmat((0:nj-1)',1,nk); Nvec=N(:)';
c=besselj(N,lam*r0)./(besselj(...
   N+1,lam).^2.*(lam.^2-w^2));
c(1,:)=c(1,:)/2; c=c(:)';

% Sum the series
lamvec=lam(:)'; wlam=w./lamvec;
c=cos(th*Nvec).*repmat(c,nth,1); 
rmat=besselj(repmat(Nvec',1,nr),lamvec'*r);
u=zeros(nth,nr,nt);
for k=1:nt   
   tvec=sin(w*t(k))-wlam.*sin(lamvec*t(k));
   u(:,:,k)=c.*repmat(tvec,nth,1)*rmat;
end
u=2/pi*u; X=cos(th)*r; Y=sin(th)*r;
tcp=toc; Tcp=num2str(tcp);
%disp(['Computation time = ',Tcp,' secs'])
%disp(' '), pause(.1)

% Show animated plot
%while 1
   %val=input(['Press return to plot, ',...
   %   'or a zero to stop > '],'s');
   %if strcmp(val,'0')==1
   %   disp(' '), disp('All done'), disp(' ')
   %   return
   % end
   % val=input('Press return to see the animation','s');
   up=u/max(abs(u(:))); close
   for j=1:nt
     uj=up(:,:,j); surf(X,Y,uj)
     axis([-1,1,-1,1,-4,4]), xlabel('x axis')
     ylabel('y axis'), zlabel('deflection')
     title('MEMBRANE WITH AN OSCILLATING LOAD')
     colormap([127/255 1 212/255])
     grid on, drawnow, shg, pause(.2)
   end
%end

%======================================

function [r,errmax]=beszeros(n,k,iter)
% [r,errmax]=beszeros(n,k,iter)
% This function computes Bessel function
% roots using the formula on page of 260
% of 'A Treatise on Bessel Functions and
% Their Applications to Physics' by Andrew
% Gray and G. B. Mathews.
% n      - vector of function orders. For
%          example, n=0:20 gives roots of
%          besselj(0,x) thru besselj(20,x).
% k      - vector of root indices. k=1:20
%          gives the first 20 positive roots.
% iter   - number of times a Newton iteration
%          is performed to improve accuracy 
%          of the roots. Default value is 5.
% r      - matrix of roots where r(i,j) is
%          the root number k(j) for the 
%          Bessel function of order n(i)
% errmax - maximum of the absolute value of
%          the bessel functions evaluated
%          at the root estimates
%          
if nargin<3, iter=5; end
N=length(n); K=length(k);
n=repmat(n(:),1,K); k=repmat(k(:)',N,1);
b=pi/4*(2*n-1+4*k); m=4*n.^2;

% Starting formula for the roots
r=b-(m-1)./(8*b)-4*(m-1).*(7*m-31)./...
    (3*(8*b).^3)-32*(m-1).*((83*m-982).*m...
    +3779)./(15*(8*b).^5)-64*(m-1).*(((...
    6949*m-153855).*m+1585743).*m-...
    6277237)./(105*(8*b).^7);

% Newton interations to improve accuracy
for j=1:iter
  v=besselj(n,r); vp=(besselj(n-1,r)-...
    besselj(n+1,r))/2; r=r-v./vp;
end

err=besselj(n,r); errmax=max(abs(err(:)));