function gabor_example()
% an example to demonstrate the use of gabor filter.
% requires lena.jpg in the same path.
% the results mimic:
% http://matlabserver.cs.rug.nl/edgedetectionweb/web/edgedetection_examples
% .html
% using default settings (except for in radians instead of degrees)
%
% note that gabor_fn only take scalar inputs, and multiple filters need to
% be generated using (nested) loops
%
% also, apparently the scaling of the numbers is different from the example
% software at
% http://matlabserver.cs.rug.nl
% but are consistent with the formulae shown there
lambda  = 8;
theta   = 0;
psi     = [0 pi/2];
gamma   = 0.5;
bw      = 1;
N       = 8;
img_in = im2double(imread('lena.jpg'));
img_in(:,:,2:3) = [];   % discard redundant channels, it's gray anyway
img_out = zeros(size(img_in,1), size(img_in,2), N);
for n=1:N
    gb = gabor_fn(bw,gamma,psi(1),lambda,theta)...
        + 1i * gabor_fn(bw,gamma,psi(2),lambda,theta);
    % gb is the n-th gabor filter
    img_out(:,:,n) = imfilter(img_in, gb, 'symmetric');
    % filter output to the n-th channel
    theta = theta + 2*pi/N;
    % next orientation
end
figure(1);
imshow(img_in);
title('input image');
figure(2);
img_out_disp = sum(abs(img_out).^2, 3).^0.5;
% default superposition method, L2-norm
img_out_disp = img_out_disp./max(img_out_disp(:));
% normalize
imshow(img_out_disp);
title('gabor output, L-2 super-imposed, normalized');