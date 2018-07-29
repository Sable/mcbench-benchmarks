function CNR =Compute_VM(IM,sigma1,sigma2)

%  This new visibility metric is to calculate the Contrast-to-Noise Ratio 
%  of noise image estimated by Gaussian kernel with sigma1 and sigma2 respectively.
%  Written by zhengguo dai in Beijing JX Digital Wave Co.ltd
%  Email: zhgdai@126.com
%  Note: This new metric should be tested by more pictures.

epsilon=1e-1;
half_size1 = ceil( -norminv( epsilon/2, 0, sigma1 ) );
size1 = 2 * half_size1 + 1 ;
half_size2 = ceil( -norminv( epsilon/2, 0, sigma2 ) );
size2 = 2 * half_size2 + 1 ;
gaussian1 = fspecial( 'gaussian', size1, sigma1 ) ;
gaussian2 = fspecial( 'gaussian', size2, sigma2 ) ;
IM = abs(IM - imfilter( IM, gaussian1, 'replicate' )) ;
noise = IM - imfilter( IM, gaussian1, 'replicate' ) ;
lsd = sqrt(imfilter( noise.^2, gaussian2, 'replicate' ) ) ;
lsd =  lsd./max( lsd( : ) ) .*255 ; % normalize
% figure; imshow(lsd,[])
CNR = sum(lsd(:))/(size(lsd,1)*size(lsd,2));