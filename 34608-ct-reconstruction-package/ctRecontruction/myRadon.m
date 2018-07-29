function sinogram = myRadon(image,thetas)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% radon transformation -> schlegel & bille 9.1.1
% written by Mark Bangert
% m.bangert@dkfz.de 2011

numOfAngularProjections  = length(thetas);
numOfParallelProjections = size(image,1);

sinogram = zeros(numOfParallelProjections,numOfAngularProjections);

% loop over the number of angles
for i = 1:length(thetas)
   
   % rotate image
   tmpImage      = imrotate(image,-thetas(i),'bilinear','crop');
   
   % fill sinogram
   sinogram(:,i) = sum(tmpImage,2);
   
   % visualization on the fly
   imagesc(sinogram);
   drawnow
   
end
