
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%         BLOCK-BASED SIGNAL SUBSPACE PROCESSING       %%
   %%                  FOR DETECTING CHANGE                %%
   %%                 OR TARGET REGISTRATION               %%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
cj=sqrt(-1);
nx=3;                     % filter size in x domain is 2*nx+1
ny=5;                     % filter size in y domain is 2*ny+1
N=(2*nx+1)*(2*ny+1);      % Number of basis functions
%
% ref_image:              reference image or f1(x,y) (INPUT)
% test_image:             test image or f2(x,y)      (INPUT)

% Example:

      NX=60; NY=54;
      ref_image=randn(NX,NY)+cj*randn(NX,NY);    % reference image
      h=randn(5,3)+cj*randn(5,3);                % filter
      test_image=conv2(ref_image,h);             % test image
      test_image=test_image(3:NX+2,2:NY+1);
      change=zeros(NX,NY);
      change(10:12,15:25)=randn(3,11)+cj*randn(3,11);
      change(30:39,40:45)=randn(10,6)+cj*randn(10,6);   % change
      test_image=test_image+change;         % add change to test image
%
[NX,NY]=size(ref_image);  % size of reference or test image
%
nxb=15;                   % size of block in x domain
nyb=18;                   % size of block in y domain
nb=nxb*nyb;               % number of pixels in a block
%

MX=nxb*ceil(NX/nxb)+2*nx;     % size of zero-padded image in x domain
MY=nyb*ceil(NY/nyb)+2*ny;     % size of zero-padded image in y domain
%
f1=zeros(MX,MY);
f1(nx+1:nx+NX,ny+1:ny+NY)=ref_image;      % zero-padded reference image
%
f2=zeros(MX,MY);
f2(nx+1:nx+NX,ny+1:ny+NY)=test_image;     % zero-padded test image

%
% for each block perform signal subspace processing
%
dif=zeros(MX,MY);          % subspace difference image initialized

for i=nx+1:nxb:MX-nx; i
 IX=i:i+nxb-1;             % x domain block indices
 for j=ny+1:nyb:MY-ny;
  JY=j:j+nyb-1;            % y domain block indices
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

  [U,D,V]=svd(g);                     % perform svd
  psi=U(:,1:N).';                     % orthogonal basis functions
  g2=reshape(f2(IX,JY),nb,1);         % test image block
  F2=conj(psi)*g2;                    % projection coefficients of
                                      % test image

  f2_est=reshape((psi.')*F2,nxb,nyb); % projection of test image block
                                      % into signal subspace
  dif(IX,JY)=f2(IX,JY)-f2_est;        % block subspace difference image
 end;
end;

dif=dif(nx+1:nx+NX,ny+1:ny+NY);      % remove zero-padded area
test_image_est=test_image+dif;       % projection of entire test image
                                     % (all blocks)
                                     
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
print P8.1.ps
pause(1)
%
G=abs(test_image)';
xg=max(max(G)); ng=min(min(G)); cg=256/(xg-ng);
image(x,y,256-cg*(G-ng)); axis image;
xlabel('Spatial Domain X')
ylabel('Spatial Domain Y')
title('Test Image f_2 (x,y)')
print P8.2.ps
pause(1)
%
G=abs(change)';
xg=max(max(G)); ng=min(min(G)); cg=256/(xg-ng);
image(x,y,256-cg*(G-ng)); axis image;
xlabel('Spatial Domain X')
ylabel('Spatial Domain Y')
title('Change Image f_e (x,y)')
print P8.3.ps
pause(1)
%
G=abs(ref_image-test_image)';
xg=max(max(G)); ng=min(min(G)); cg=256/(xg-ng);
image(x,y,256-cg*(G-ng)); axis image;
xlabel('Spatial Domain X')
ylabel('Spatial Domain Y')
title('Difference Image f_d (x,y)')
print P8.4.ps
pause(1)
%
G=abs(test_image_est)';
xg=max(max(G)); ng=min(min(G)); cg=256/(xg-ng);
image(x,y,256-cg*(G-ng)); axis image;
xlabel('Spatial Domain X')
ylabel('Spatial Domain Y')
title('Signal Subspace Projection of Test Image \^f_2 (x,y)')
print P8.5.ps
pause(1)
%
G=abs(dif)';
xg=max(max(G)); ng=min(min(G)); cg=256/(xg-ng);
image(x,y,256-cg*(G-ng)); axis image;
xlabel('Spatial Domain X')
ylabel('Spatial Domain Y')
title('Signal Subspace Difference Image \^f_d (x,y)')
print P8.6.ps
pause(1)

