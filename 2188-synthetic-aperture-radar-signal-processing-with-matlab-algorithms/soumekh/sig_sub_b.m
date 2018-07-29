
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%  OVERLAPPING BLOCK-BASED SIGNAL SUBSPACE PROCESSING  %%
   %%                  FOR MOTION TRACKING                 %%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
nx=2;                     % filter size in x domain is 2*nx+1
ny=2;                     % filter size in y domain is 2*ny+1
N=(2*nx+1)*(2*ny+1);      % Number of basis functions
%
% ref_image:              reference image or f1(x,y) (INPUT)
% test_image:             test image or f2(x,y)      (INPUT)


% Example:
%
      NX=48; NY=44;
      square=randn(10:10); rect=randn(20,14);
      ix=-10:10; ix=ix(:)*ones(1,17);
      jy=-8:8; jy=ones(21,1)*jy;
      ell=(sqrt((ix/10).^2+(jy/8).^2) <= 1).*randn(21,17);
      ref_image=zeros(NX,NY);
      ref_image(5:14,17:26)=square;
      ref_image(19:38,5:18)=rect;
      ref_image(15:35,20:36)=ell;
      ref_image=ref_image+.05*randn(NX,NY);
      test_image=zeros(NX,NY);
      test_image(5+1:14+1,17-1:26-1)=2*square;
      test_image(19:38,5+2:18+2)=-1.4*rect;
      test_image(15-1:35-1,20-2:36-2)=.9*ell;
      test_image=test_image+.05*randn(NX,NY);      
              
%
[NX,NY]=size(ref_image);  % size of reference or test image
%
nxb=5;                    % size of block in x domain
nxb2=(nxb-1)/2;
nyb=5;                   % size of block in y domain
nyb2=(nyb-1)/2;
nb=nxb*nyb;               % number of pixels in a block
%
MX=NX+2*(nx+nxb2);        % size of zero-padded image in x domain
MY=NY+2*(ny+nyb2);        % size of zero-padded image in y domain
%
f1=zeros(MX,MY);
f1(nx+nxb2+1:nx+nxb2+NX,ny+nyb2+1:ny+nyb2+NY)=ref_image;
                                     % zero-padded reference image
%
f2=zeros(MX,MY);
f2(nx+nxb2+1:nx+nxb2+NX,ny+nyb2+1:ny+nyb2+NY)=test_image;
                                     % zero-padded test image
%
% for each block perform signal subspace processing
%
hx=zeros(MX,MY);
hy=hx;
ix=-nx:nx; jy=-ny:ny;

for i=nx+nxb2+1:MX-nx-nxb2; i
 IX=i-nxb2:i+nxb2;         % x domain block indices
 for j=ny+nyb2+1:MY-ny-nyb2;
  JY=j-nyb2:j+nyb2;        % y domain block indices
%
  g=zeros(nb,N);           % array containing block reference image
                           % and its shifted versions
  icount=0;
  for ii=-nx:nx;
   for jj=-ny:ny;
    icount=icount+1;
    g(:,icount)=reshape(f1(IX+ii,JY+jj),nb,1);
   end;
  end;
  [U,D,V]=svd(g);               % perform svd
  psi=U(:,1:N).';               % orthogonal basis functions
  g2=reshape(f2(IX,JY),nb,1);   % test image block
  F2=conj(psi)*g2;              % projection coefficients of
                                % test image
  F1=conj(psi)*g;          % projection coefficients of
                           % reference image and its shifted versions
  H=pinv(F1)*F2;                % estimate of filter
  h=zeros(2*nx+1,2*ny+1);
  icount=0;
  for ii=1:2*nx+1;
     for jj=1:2*ny+1;
        icount=icount+1;
        h(ii,jj)=H(icount);
     end;
  end;
  
  % estimate shifts
  %
  Eh=sum(sum(h.^2));
  hx(i,j)=sum(sum((ix(:)*ones(1,2*ny+1)).*(h.^2)))/Eh;  % x domain shift
  hy(i,j)=sum(sum((ones(2*nx+1,1)*jy).*(h.^2)))/Eh;     % y domain shift
 end; 
end;
hx=hx.*(abs(hx) <= nx);
hy=hy.*(abs(hy) <= ny);

% lowpass filter estimate of motion vectors
%
ix=-MX/2:MX/2-1; jy=-MY/2:MY/2-1;
winx=(.54+.46*cos(pi*(ix/(.4*MX)))).*(abs(ix) <= .4*MX);
winy=(.54+.46*cos(pi*(jy/(.4*MY)))).*(abs(jy) <= .4*MY);
W=winx(:)*winy;
HX=real(iftx(ifty(ftx(fty(hx)).*W)));
HY=real(iftx(ifty(ftx(fty(hy)).*W)));

hx=hx(nx+nxb2+1:nx+nxb2+NX,ny+nyb2+1:ny+nyb2+NY);
hy=hy(nx+nxb2+1:nx+nxb2+NX,ny+nyb2+1:ny+nyb2+NY);
HX=HX(nx+nxb2+1:nx+nxb2+NX,ny+nyb2+1:ny+nyb2+NY);
HY=HY(nx+nxb2+1:nx+nxb2+NX,ny+nyb2+1:ny+nyb2+NY);
            
% display
%
dx=1;              % x domain sample spacing
dy=1;              % y domain sample spacing
x=-NX/2:NX/2-1; y=-NY/2:NY/2-1; 
%
G=abs(ref_image)';
xg=max(max(G)); ng=min(min(G)); cg=256/(xg-ng);
image(x,y,256-cg*(G-ng)); axis image;
xlabel('Spatial Domain X')
ylabel('Spatial Domain Y')
title('Reference Image f_1 (x,y)')
print P8.7.ps
pause(1)
%
G=abs(test_image)';
xg=max(max(G)); ng=min(min(G)); cg=256/(xg-ng);
image(x,y,256-cg*(G-ng)); axis image;
xlabel('Spatial Domain X')
ylabel('Spatial Domain Y')
title('Test Image f_2 (x,y)')
print P8.8.ps
pause(1)
%
xgg=max(max(abs(ref_image)));
I=(abs(ref_image) > .1*xgg);
gx=(HX.*I); gy=(HY.*I);
G=ref_image';
xg=max(max(G)); ng=min(min(G)); cg=256/(xg-ng);
image(x,y,256-cg*(G-ng)); axis image; axis xy
hold on
quiver(x(:)*ones(1,NY),ones(NX,1)*y,gx,gy,2)
xlabel('Spatial Domain X')
ylabel('Spatial Domain Y')
title('Motion Vector Image')
print P8.9.ps
hold off
