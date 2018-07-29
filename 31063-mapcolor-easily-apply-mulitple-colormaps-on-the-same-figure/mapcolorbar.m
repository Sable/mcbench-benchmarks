function h=mapcolorbar(map,clim,ax,varargin)
% Usage: h=mapcolorbar(map,clim,[ax],[options])
% Given a colormap "map" and limits "clim" (as a two-element vector),
% mapcolorbar creates a MapColorbar associated with the axes "ax". You may
% also use any of the options available when using colorbar.m; include them
% last. Also supported: mapcolorbar('off'), mapcolorbar('hide'), and
% mapcolorbar('delete') remove all MapColorbars from the current figure.
% Likewise mapcolorbar(ax,'off'), mapcolorbar(ax,'hide'), and
% mapcolorbar(ax,'delete') remove all MapColorbars associated with axes
% "ax". See also mapcolor.m. 
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

% Written 2 May 2010 by Douglas H. Kelley, dhk [at] dougandneely.com.

if nargin<1
    error(['Usage: h = ' mfilename '(map,clim,[ax],[options])'])
end
if ~exist('ax','var') || isempty(ax)
    ax=gca;
end

curax=gca;
if ischar(map) % catch 'off', 'hide', 'delete' inputs
    if strcmp(map,'off') || strcmp(map,'hide') || strcmp(map,'delete')
        delete(findobj(gcf,'tag','MapColorbar'));
    end
    return
elseif ischar(clim) % catch 'off', 'hide', 'delete' inputs, with axes handle
    if strcmp(clim,'off') || strcmp(clim,'hide') || strcmp(clim,'delete')
        h1=findobj(gcf,'tag','MapColorbar');
        for ii=1:numel(h1)
            if get(h1(ii),'userdata')==map
                delete(h1(ii))
            end
        end
    end
    return
end

mapsize=size(map,1);
hcb0=colorbar('peer',ax,varargin{:}); % original colorbar
c0=get(findobj(hcb0,'type','image'),'cdata');
hcb0loc=get(hcb0,'Location');
if strcmp(hcb0loc,'East') || strcmp(hcb0loc,'West') || ... % original colorbar was vertical
        strcmp(hcb0loc,'EastOutside') || strcmp(hcb0loc,'WestOutside')
    c=nan*ones(mapsize,2,3);
    c(:,1,:)=map;
    c(:,2,:)=map;
    x=[0 1];
    y=[clim(1) clim(2)];
elseif strcmp(hcb0loc,'North') || strcmp(hcb0loc,'South') || ... % original colorbar was horizontal 
        strcmp(hcb0loc,'NorthOutside') || strcmp(hcb0loc,'SouthOutside')
    c=nan*ones(2,mapsize,3);
    c(1,:,:)=map;
    c(2,:,:)=map;
    x=[clim(1) clim(2)];
    y=[0 1];
else % manual location; will guess orientation from image size
    if size(c0,1)>size(c0,2) % guess vertical
        c=nan*ones(mapsize,2,3);
        c(:,1,:)=map;
        c(:,2,:)=map;
        x=[0 1];
        y=[clim(1) clim(2)];
    else % guess horizontal
        c=nan*ones(2,mapsize,3);
        c(1,:,:)=map;
        c(2,:,:)=map;
        x=[clim(1) clim(2)];
        y=[0 1];
    end
end
hcb=axes('position',get(hcb0,'position'));
imagesc(x,y,c);
set( hcb,'ylim',y,'xlim',x,'ydir','normal', ...
    'xaxislocation',get(hcb0,'xaxislocation'), ...
    'yaxislocation',get(hcb0,'yaxislocation'), ...
    'tag','MapColorbar','userdata',ax);
if size(c0,1)>size(c0,2)
    set(hcb,'xtick',[]);
else
    set(hcb,'ytick',[]);
end
pos=get(ax,'position');
delete(hcb0);
set(ax,'position',pos);
set(gcf,'currentaxes',curax)

if nargout>0
    h=hcb;
end
