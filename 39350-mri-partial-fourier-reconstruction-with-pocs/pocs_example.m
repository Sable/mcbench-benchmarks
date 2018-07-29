% Showing the effect of the POCS partial Fourier reconstruction.
%
% Mark a cell (code beginning with "%%") and
% press <Ctrl> + <Enter> to evaluate the cell content only.


%% simple example (2D, single coil, no phase errors)
%
N = 256;
iter = 30;
pf = 9/16;      % a typical large partial fourier factor
p = single(phantom(N));
kspRef = fftshift(fftshift(  fft(fft(  fftshift(fftshift( p, 1),2), [],1),[],2), 1),2);
kspRef = kspRef + 3 * complex( randn(N), randn(N) );    % add noise
kspPF  = kspRef;
kspPF(:,1:floor((1-pf)*N)) = 0;

imReco = pocs( kspPF, iter, true );

imRef    = ifftshift(ifftshift(  ifft(ifft(  ifftshift(ifftshift( kspRef, 1),2), [],1),[],2), 1),2);
imDirect = ifftshift(ifftshift(  ifft(ifft(  ifftshift(ifftshift(  kspPF, 1),2), [],1),[],2), 1),2);

figure,
imagesc(abs([imRef  imReco  imDirect]), [0 2*mean(abs(imRef(:)))])
axis image
title('reference (full dataset)   |   POCS reco   |    zero-padded reco')
colormap(gray(256))


%% multicoil example with phase error
%
clear  p  kspRef  kspPF  imReco  imRef  imDirect
N = 256;
iter = 30;
pf = 9/16;
% Set up some pseudo coilmaps:
cmap(1,:,:) = repmat(        ( 3./(1:N)  .^0.10) .* exp(1i*(1:N)  *pi/(N/3)) , N, 1 );
cmap(2,:,:) = repmat(        ( 1./(1:N).'.^0.20) .* exp(1i*(1:N).'*pi/(N/4)) , 1, N );
cmap(3,:,:) = repmat( fliplr(( 2./(1:N)  .^0.04) .* exp(1i*(1:N)  *pi/(N/8))), N, 1 );
cmap(4,:,:) = repmat( flipud(( 2./(1:N).'.^0.15) .* exp(1i*(1:N).'*pi/(N/10))),1, N );
cmap = single(cmap);

Nc = size(cmap,1);
p = reshape( single(phantom(N)), 1, N, N );
subs = { 1, 164:181, 187:193 };
p(subs{:}) = 0;
subs = { 1, 166:179, 189:191 };
p(subs{:}) = 1 * exp(1i * pi/2);
p = bsxfun( @times, cmap, p );
kspRef = fftshift(fftshift(  fft(fft(  fftshift(fftshift( p, 2),3), [],2),[],3), 2),3);
kspRef = kspRef + 10 * complex( randn(Nc,N,N), randn(Nc,N,N) );    % add noise
kspPF  = kspRef;
kspPF(:,:,1:floor((1-pf)*N)) = 0;

imReco = pocs( kspPF, iter, true );

imReco   = squeeze(sqrt(sum( abs(imReco).^2, 1)));
imRef    = ifftshift(ifftshift(  ifft(ifft(  ifftshift(ifftshift( kspRef, 2),3), [],2),[],3), 2),3);
imRef    = squeeze(sqrt(sum( abs(imRef).^2, 1)));
imDirect = ifftshift(ifftshift(  ifft(ifft(  ifftshift(ifftshift(  kspPF, 2),3), [],2),[],3), 2),3);
imDirect = squeeze(sqrt(sum( abs(imDirect).^2, 1)));

figure,
imagesc(abs([imRef  imReco  imDirect]),[0 2*mean(abs(imRef(:)))])
axis image
title('reference (full dataset)   |   POCS reco   |    zero-padded reco')
colormap(gray(256))
