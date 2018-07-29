function cirmemod(nmin,nmax)
% cirmemod(nmin,nmax)
% This function plots the first 25 natural
% vibration modes for a circular membrane.
% Modes between nmin and nmax are shown.

if nargin ==0, nmin=1; nmax=25; end
if nargin==1, nmax=nmin; end
nmin=max(nmin,1); nmax=min(nmax,25);
N=[ 0 1 2 0 3 1 4 2 0 5 3 6 1 4 7 2 0 8 5 3 1 9 6 4 10];
r=[ 2.4048 3.8317 5.1356 5.5201 6.3802  7.0156  7.5883, ...
    8.4172 8.6537 8.7715 9.7610 9.9361 10.1735 11.0647, ...
   11.0864 11.6198 11.7915 12.2251 12.3386 13.0152, ...
   13.3237 13.3543 13.5893 14.3725 14.4755];
th=linspace(0,2*pi,61)'; rad=linspace(0,1,15);
z=exp(i*th)*rad; x=real(z); y=imag(z);
n=length(N); nf=25; f=cos(linspace(0,4*pi,nf)); 
aqua=[127/255 1 212/255]; yellow=[1 1 0];
for j=nmin:nmax
   nj=N(j); J=num2str(j);
   bj=besselj(nj,rad*r(j)); bj=bj/2/max(abs(bj(:)));
   uc=cos(nj*th)*bj;
   for k=1:nf
      surf(x,y,f(k)*uc), axis equal
      axis([-1,1,-1,1,-1,1])
      title(['MEMBRANE EVEN MODE NUMBER  ',J])
      xlabel('x axis'), ylabel('y axis') 
      zlabel('z axis'), colormap(yellow)
      % colormap(aqua)
      drawnow, shg
   end
   pause(1) 
   if nj>0
      us=sin(nj*th)*bj;
      for k=1:nf
         surf(x,y,f(k)*us)
         axis equal, axis([-1,1,-1,1,-1,1])
         title(['MEMBRANE ODD MODE NUMBER  ',J])
         xlabel('x axis'), ylabel('y axis')
         zlabel('z axis'), colormap(yellow)
         % colormap(aqua)
         drawnow, shg
      end
      pause(1)
   end
end