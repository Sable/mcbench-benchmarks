% ANISODIFF - Anisotropic diffusion.
%
% 
%  diff = anisodiff(im, niter, kappa, lambda, option)
%
% 
%         im     - input image
%         niter  - number of iterations.
%         kappa  - conduction coefficient 20-100 ?
%         lambda - max value of .25 for stability
%         option - 1 Perona Malik diffusion equation No 1
%                  2 Perona Malik diffusion equation No 2
%
% Return
%         diff   - diffused image.
%
% kappa controls conduction as a function of gradient.  If kappa is low
% then mall intensity gradients are able to block conduction and hence diffusion
% across step edges.  A large value reduces the influence of intensity
% gradients on conduction.
%
% lambda controls speed of diffusion (you usually want it at a maximum of
% 0.25)
%
% Diffusion equation 1 preserve high contrast edges over low contrast ones.
% Diffusion equation 2 favours wide regions over smaller ones.

% Reference: 
% P. Perona and J. Malik. 
% Scale-space and edge detection using anisotropic diffusion.
% IEEE Transactions on Pattern Analysis and Machine Intelligence, 
% 12(7):629-639, July 1990.


function diff = anisodiff(im, niter, kappa, lambda, option)

if ndims(im)==3
  error('Anisodiff only operates on 2D grey-scale images');
end

im = double(im);
[rows,cols] = size(im);
diff = im;

%{
var = 2;
x = (-4:4);
g = exp(-x.*x/(2*var)); g  = g/sum(g);

blurred = conv2(im,g,'same');
im_b = conv2(blurred,g','same'); 

%}

for i = 1:niter
 % fprintf('\rIteration %d',i);

  % Construct diffl which is the same as diff but
  % has an extra padding of zeros around it.
  diffl = zeros(rows+2, cols+2);
  diffl(2:rows+1, 2:cols+1) = diff;

  % North, South, East and West differences
  deltaN = diffl(1:rows,2:cols+1)   - diff;
  
  deltaS = diffl(3:rows+2,2:cols+1) - diff;
  
  deltaE = diffl(2:rows+1,3:cols+2) - diff;
  
  deltaW = diffl(2:rows+1,1:cols)   - diff;
  %deltaN = diff;deltaW;
  

  % Conduction

  if option == 1
    cN = exp(-(deltaN/kappa).^2);
    
    cS = exp(-(deltaS/kappa).^2);
    cE = exp(-(deltaE/kappa).^2);
    cW = exp(-(deltaW/kappa).^2);
    
  elseif option == 2
    cN = 1./(1 + (deltaN/kappa).^2);
    cS = 1./(1 + (deltaS/kappa).^2);
    cE = 1./(1 + (deltaE/kappa).^2);
    cW = 1./(1 + (deltaW/kappa).^2);
  end

  % APPLYING FOUR-POINT-TEMPLETE FOR numerical solution of DIFFUSION P.D.E.
  
  diff = diff + lambda*(cN.*deltaN + cS.*deltaS + cE.*deltaE + cW.*deltaW);
figure();
%  Uncomment the following to see a progression of images
 subplot(ceil(sqrt(niter)),ceil(sqrt(niter)), i)
 figure();
 pause(2)
imagesc(diff), colormap(gray), axis image

end
fprintf('\n');


