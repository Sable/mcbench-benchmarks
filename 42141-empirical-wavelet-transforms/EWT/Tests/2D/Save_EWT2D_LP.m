function Save_EWT2D_LP(ewt2d,name)

%=========================================================================
%
% function Save_EWT2D_LP(ewt2d,name)
%
% Save each subband image in separate files named 'LPxname.png' where n
% is the subband number.
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

% Find the min and max over all images
for n=1:length(ewt2d)
    minI=min(minI,min(ewt2d{n}(:)));
    maxI=max(maxI,max(ewt2d{n}(:)));
end

% Plot each subband with the same normalization
for n=1:length(ewt2d)
%        gname=sprintf('LP%d%s.png',n,name);
        gname=sprintf('R%d%s.png',n,name);

        imwrite((ewt2d{n}-min(ewt2d{n}(:)))/(max(ewt2d{n}(:))-min(ewt2d{n}(:))),gname,'png');
%        imwrite((ewt2d{n}-minI)/(maxI-minI),gname,'png');
end