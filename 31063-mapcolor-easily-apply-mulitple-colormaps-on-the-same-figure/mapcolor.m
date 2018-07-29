function c=mapcolor(d,map,clim)
% Usage: c=mapcolor(d,[map],[clim])
% Given an array "d", mapcolor uses the colormap "map" to assign a color to
% each entry in "d", returning the results as RGB triplets in "c". Provide
% a two-element vector "clim" to impose limits on the colormap. Basically 
% this does exactly what Matlab's built-in colormaps do, but does not 
% affect the "Colormap" property of the current figure--so you can use
% multiple colormaps on the same figure. See also mapcolorbar.m. 
%
%   Example:
%      load clown
%      mylim=[min(X(:)) max(X(:))];
%      Xhot=mapcolor(X,hot,mylim);
%      subplot(211);
%      imagesc(Xhot);
%      mapcolorbar(hot,mylim);
%      Xjet=mapcolor(X,jet,mylim);
%      subplot(212);
%      imagesc(Xjet);
%      mapcolorbar(jet,mylim);

% Written 29 April 2010 by Douglas H. Kelley, dhk [at] dougandneely.com.

mapdefault=jet(256); % specifying a size prevents a figure from popping up

if nargin<1
    error(['Usage: c = ' mfilename '(d,[map],[clim])'])
end
if ~exist('map','var') || isempty(map)
    map=mapdefault;
elseif ischar(map)
    warning(['MATLAB:' mfilename ':mapIsString'], ...
        ['Map given as a string; attempting to evaluate ''' map '''.'])
    map=eval(map);
end
if ~exist('clim','var') || isempty(clim)
    clim=[min(d(:)) max(d(:))];
end

N=numel(d);
NN=size(d);
mapsize=size(map,1);
binnum=floor( mapsize/diff(clim)*(d-clim(1))+1 ); % A linear mapping...
binnum(isnan(binnum))=1; % ...setting NaNs to the mininum of the map, ...
binnum(binnum<1)=1; % ...then correcting for saturation at bottom...
binnum(binnum>mapsize)=mapsize; % ...and top.
if isvector(d)
    c=nan*ones(N,3);
    for ii=1:N
        c(ii,:)=map(binnum(ii),:);
    end
elseif ndims(d)==2
    c=nan*ones([size(d) 3]);
    [i,j]=ind2sub(NN,[1:N]);
    for ii=1:N
        c(i(ii),j(ii),:)=map(binnum(ii),:);
    end
else
    error(['Sorry, mapcolor does not support arrays of dimension '...
        'greater than two.'])
end
