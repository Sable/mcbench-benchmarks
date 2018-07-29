function pltmap(latrange,lonrange,latd,lond,mrk,col,label)
% PLTNET  Plots a map of a network of points in decimal degrees
%   with labels.
% Version: 20 Jan 99
% Usage:   pltnet(latrange,lonrange,latd,lond,mrk,col,label)
% Input:   latrange - latitude range of base map [min max] (deg)
%          lonrange - lontidue range of base map [min max] (deg)
%          latd     - latitude of points (deg)
%          lond     - longitude of points (deg)
%          mrk      - symbol marker type for points (string)
%                     [o + * - x . v ^ > < square diamond pentagram
%                      hexagram none]; default='+'
%          col      - symbol marker color for points (string)
%                     [r b g y k] or any ColorSpec; default='k'
%          label    - point labels

% Copyright (c) 2011, Michael R. Craymer
% All rights reserved.
% Email: mike@craymer.com

if nargin<2
  error('Too few input arguments');
elseif nargin==2
  latd=[];
  mrk='+';
  col='k';
  label=[];
elseif nargin==3
  error('Too few input arguments');
elseif nargin==4
  mrk='+';
  col='k';
  label=[];
elseif nargin==5
  col='k';
  label=[];
elseif nargin==6
  label=[];
elseif nargin>7
  error('Too many input arguments');
end

%clf;
m_proj('equidistant cylindrical','lat',latrange,'lon',lonrange);
%m_coast('patch',[.7 .7 .7],'edgecolor','none');
m_coast('color','k');
m_grid;

n=length(latd);
%if n>0
  for i=1:n
    [x,y]=m_ll2xy(lond(i),latd(i));
    line(x,y,'marker',mrk,'markersize',4,'color',col,'markerfacecolor',col);
    text(x,y,label(i,:),'color','k','fontsize',10,'vertical','bottom');
  end
%end
