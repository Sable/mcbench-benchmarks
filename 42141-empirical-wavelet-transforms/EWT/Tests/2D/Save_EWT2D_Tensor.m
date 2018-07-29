function Save_EWT2D_Tensor(ewt2d,name)

%=========================================================================
%
% function Save_EWT2D_Tensor(ewt2d,name)
%
% Save each subband image in separate files named 'Txyname.png' where x
% and y are the indices of the scales for both direction.
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
for c=1:nc;
    for r=1:nr;
        gname=sprintf('T%d%d%s.png',r,c,name);
        %imwrite((ewt2d{r}{c}-minI)/(maxI-minI),gname,'png');
        imwrite((ewt2d{r}{c}-min(ewt2d{r}{c}(:)))/(max(ewt2d{r}{c}(:))-min(ewt2d{r}{c}(:))),gname,'png');
    end
end