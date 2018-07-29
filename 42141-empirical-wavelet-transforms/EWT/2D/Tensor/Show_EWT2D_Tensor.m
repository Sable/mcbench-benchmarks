function Show_EWT2D_Tensor(ewt2d)

%=========================================================================
%
% function Show_Tensor_EWT2D(ewt2d)
%
% Show each subband image in a subplot of a single figure.
% The images are renormalized with respect to the min and max of all
% images.
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
% ========================================================================

minI=255.0;
maxI=0.0;

[nr,nc]=size(ewt2d);

% Find the min and max over all images
for r=1:nr;
    for c=1:nc;
        minI=min(minI,min(ewt2d{r}{c}(:)));
        maxI=max(maxI,max(ewt2d{r}{c}(:)));
    end
end

% Plot each subband with the same normalization
figure;
for c=1:nc;
    for r=1:nr;
       n=(c-1)*nr+r;
       subplot(nc,nr,n);imshow(ewt2d{r}{c},[minI maxI]); 
    end
end