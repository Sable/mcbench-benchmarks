function result = anisoOS(input,psiFunction,sigma,iterations,lambda,B)
%
% result = aniso(input,[psiFunction],[sigma],[iterations],[lambda])
%
% Anisotropic diffusion, following the robust statistics
% formulation laid out in Black et al, IEEE Trans on Im Proc,
% 7:421-432, 1998.
%
% Examples of how to run this function are included at the end of
% aniso.m 
%
%   input: input image
%   psiFunction: influence function that determines how the
%      diffusion depends on the local image gradient.  Three
%      example psi functions are:
%         linearPsi.m
%         lorentzianPsi.m.
%         tukeyPsi.m
%      Default is tukeyPsi, that makes this the same as one of
%      original two algorithms proposed by Perona et al.  But
%      tukeyPsi is often a better choice because it does a better
%      job of maintaining the sharpness of an edge.  LinearPsi
%      gives standard linear diffusion, i.e., shift-invariant
%      convolution by a Gaussian. 
%   sigma: scale parameter on the psiFunction.  Choose this
%      number to be bigger than the noise but small than the real
%      discontinuties. [Default = 1]
%   iterations: number of iterations [Default = 10]
%   lambda: rate parameter [Default = 1/4] To approximage a
%      continuous-time PDE, make lambda small and increase the
%      number of iterations.
%
% DJH, 2/2000
%
% modified by OS 28sep03 to removed gradient from B.


if ~exist('psiFunction','var')
   psiFunction = 'tukeyPsi';
end
if ~exist('sigma','var')
   sigma = 1;
end
if ~exist('iterations','var')
   iterations = 10;
end
if ~exist('lambda','var')
   lambda = 0.25;
end
lambda = lambda/4;

% Initialize result
result = input;

% Indices for the center pixel and the 4 nearest neighbors
% (north, south, east, west)
[m,n] = size(input);
rowC = [1:m];         rowN = [1 1:m-1];    rowS = [2:m m];
colC = [1:n];         colE = [1 1:n-1];    colW = [2:n n];

% --- take into account B if it exists
if exist('B','var')
   northB = B(rowN,colC)-B(rowC,colC);
   southB = B(rowS,colC)-B(rowC,colC);
   eastB = B(rowC,colE)-B(rowC,colC);
   westB = B(rowC,colW)-B(rowC,colC);
end



for i = 1:iterations
   % Compute difference between center pixel and each of the 4
   % nearest neighbors.
   north = result(rowN,colC)-result(rowC,colC);
   south = result(rowS,colC)-result(rowC,colC);
   east = result(rowC,colE)-result(rowC,colC);
   west = result(rowC,colW)-result(rowC,colC);
   if exist('B','var')
       north = north - northB;
       south = south - southB;
       east = east - eastB;
       west = west - westB;
   end
       
   % Evaluate the psiFunction for each of the neighbor
   % differences and add them together.  If the local gradient is
   % small, then the psiFunction should increase roughly linearly
   % with the neighbor difference.  If the local gradient is large
   % then the psiFunction should be zero (or close to zero) so
   % that large gradients are ignored/treated as outliers/stop the
   % diffusion.
   psi = eval([psiFunction,'(north,sigma)']) + ...
      eval([psiFunction,'(south,sigma)']) + ...
      eval([psiFunction,'(east,sigma)']) + ...
      eval([psiFunction,'(west,sigma)']);
   % Update result
   result = result + lambda * psi;
end;
return


function y = linearPsi(x,sigma)
y = 2*x;
return;


function y = lorentzianPsi(x,sigma)
y = (2*x)./(2*sigma^2 + abs(x).^2);
return


function y = tukeyPsi(x,sigma)
y = zeros(size(x));
id = (x > -sigma) & (x < sigma);
xid = x(id);
y(id) = xid.*((1-(xid/sigma).^2).^2);
return


% Test, debug, examples

% Noisy step
step = 1+[ones([32 64]) ; zeros([32 64])];
noise = 0.2 * randn(size(step));
im = (step + noise);

% Small number of iterations.  Not much difference.
resultLin10 = aniso(im,'linearPsi',0,10);
resultLor10 = aniso(im,'lorentzianPsi',0.5,10);
resultTuk10 = aniso(im,'tukeyPsi',0.5,10);
figure(1); clf; 
subplot(1,2,1); imshow(im,[0,3]); subplot(1,2,2); imshow(resultLor10,[0,3]);
figure(2); clf; 
subplot(1,2,1); imshow(im,[0,3]); subplot(1,2,2); imshow(resultTuk10,[0,3]);
figure(3); clf; 
plot([im(:,32) resultLin10(:,32) resultLor10(:,32) resultTuk10(:,32)]);

% More iterations.  Note that tukeyPsi is much more robust
% because it is a fully redescending influence function (see
% Black et al).  The upshot of this is that it maintains the
% sharpness of the edge even after a large number of iterations
% whereas lorentzianPsi does not.
resultLin100 = aniso(im,'linearPsi',0,100);
resultLor100 = aniso(im,'lorentzianPsi',0.5,100);
resultTuk100 = aniso(im,'tukeyPsi',0.5,100);
figure(1); clf; 
subplot(1,2,1); imshow(im,[0,3]); subplot(1,2,2); imshow(resultLor100,[0,3]);
figure(2); clf; 
subplot(1,2,1); imshow(im,[0,3]); subplot(1,2,2); imshow(resultTuk100,[0,3]);
figure(3); clf; 
plot([im(:,32) resultLin100(:,32) resultLor100(:,32) resultTuk100(:,32)]);

% Lots o' iterations.  Tukey converges wheres lorentzian and
% linear continue to blur more and more.
resultLin1000 = aniso(im,'linearPsi',0,1000);
resultLor1000 = aniso(im,'lorentzianPsi',0.5,1000);
resultTuk1000 = aniso(im,'tukeyPsi',0.5,1000);
figure(1); clf; 
subplot(1,2,1); imshow(im,[0,3]); subplot(1,2,2); imshow(resultLor1000,[0,3]);
figure(2); clf; 
subplot(1,2,1); imshow(im,[0,3]); subplot(1,2,2); imshow(resultTuk1000,[0,3]);
figure(3); clf; 
plot([im(:,32) resultLin1000(:,32) resultLor1000(:,32) resultTuk1000(:,32)]);

% Tradeoff between lambda and iterations.  All of these should
% give the same result
result5 = aniso(im,'tukeyPsi',0.5,5,0.5);
result10 = aniso(im,'tukeyPsi',0.5,10,0.25);
result100 = aniso(im,'tukeyPsi',0.5,100,0.025);
result1000 = aniso(im,'tukeyPsi',0.5,1000,0.0025);
figure(1); clf;
plot([im(:,32) result5(:,32) result10(:,32) result100(:,32) result1000(:,32)]);


% ------------- test bias field effect -----------------------
% Noisy step
step = 1+[ones([32 64]) ; zeros([32 64])];
[x,y] = meshgrid(1:64,1:64);
B = cos(x/3);
noise = 0.2 * randn(size(step));
im = (step + noise);

% Small number of iterations.  Not much difference.
resultLin10 = aniso(im,'linearPsi',0,10);
resultLor10 = aniso(im,'lorentzianPsi',0.5,10);
resultTuk10 = aniso(im,'tukeyPsi',0.5,10);
figure(1); clf; 
subplot(1,2,1); imshow(im,[0,3]); subplot(1,2,2); imshow(resultLor10,[0,3]);
figure(2); clf; 
subplot(1,2,1); imshow(im,[0,3]); subplot(1,2,2); imshow(resultTuk10,[0,3]);
figure(3); clf; 
plot([im(:,32) resultLin10(:,32) resultLor10(:,32) resultTuk10(:,32)]);

% More iterations.  Note that tukeyPsi is much more robust
% because it is a fully redescending influence function (see
% Black et al).  The upshot of this is that it maintains the
% sharpness of the edge even after a large number of iterations
% whereas lorentzianPsi does not.
resultLin100 = aniso(im,'linearPsi',0,100);
resultLor100 = aniso(im,'lorentzianPsi',0.5,100);
resultTuk100 = aniso(im,'tukeyPsi',0.5,100);
figure(1); clf; 
subplot(1,2,1); imshow(im,[0,3]); subplot(1,2,2); imshow(resultLor100,[0,3]);
figure(2); clf; 
subplot(1,2,1); imshow(im,[0,3]); subplot(1,2,2); imshow(resultTuk100,[0,3]);
figure(3); clf; 
plot([im(:,32) resultLin100(:,32) resultLor100(:,32) resultTuk100(:,32)]);

% Lots o' iterations.  Tukey converges wheres lorentzian and
% linear continue to blur more and more.
resultLin1000 = aniso(im,'linearPsi',0,1000);
resultLor1000 = aniso(im,'lorentzianPsi',0.5,1000);
resultTuk1000 = aniso(im,'tukeyPsi',0.5,1000);
figure(1); clf; 
subplot(1,2,1); imshow(im,[0,3]); subplot(1,2,2); imshow(resultLor1000,[0,3]);
figure(2); clf; 
subplot(1,2,1); imshow(im,[0,3]); subplot(1,2,2); imshow(resultTuk1000,[0,3]);
figure(3); clf; 
plot([im(:,32) resultLin1000(:,32) resultLor1000(:,32) resultTuk1000(:,32)]);

% Tradeoff between lambda and iterations.  All of these should
% give the same result
result5 = aniso(im,'tukeyPsi',0.5,5,0.5);
result10 = aniso(im,'tukeyPsi',0.5,10,0.25);
result100 = aniso(im,'tukeyPsi',0.5,100,0.025);
result1000 = aniso(im,'tukeyPsi',0.5,1000,0.0025);
figure(1); clf;
plot([im(:,32) result5(:,32) result10(:,32) result100(:,32) result1000(:,32)]);
