function [h,clim,cm]=shadedpcolor(x,y,Z1,Z2,clim1,clim2,shadelim,cmap,pcol);
% h = shadedpcolor(x,y,Z1,Z2,clim1,clim2,shadelim,cmap);
%
% Takes two data sets, Z1 and Z2.  Z1 is imaged with colors given in cmap.
% Z2 is shaded on each pixel as a value between shadedlim and 1.  Z1 and
% Z2 must be the same size.  
%
% caxis limits are needed for both data sets (clim1 and clim2).
%
% The major colormap is needed (cmap).  If empty, the current colormap is
% used.  
%
% The last optional argument is whether to use PCOLOR (default, pcol=1) or
% IMAGESC (pcol=0) to render the image.  IMAGESC is faster on most
% machines, but the x and y axes are not scaled properly if x or y
% spacing is variable.  
%
% To see a demo, run with no args.  Demo requires Udemo.mat, redblue.m
% and shadedcolorbar.m.  Note the demo uses the "redblue" colormap.  I
% find the shading works best with fewer hues than what "jet" provides. 
%
% SEE ALSO: shadedcolorbar.m

% Acknowledgements: This visualization was originaly used by Rob Pinkel.
% The code here is loosely based on code made by Matthew Alford, with
% hints from the excellent freezeColors routine by John Iversen.  
% mailto: jklymak@uvic.ca

% $Id: shadedpcolor.m,v 1.2 2007/03/04 18:28:12 jklymak Exp $ 

if nargin==0
  run_demo;
  return;
end;


% ARGUMENTS....
if nargin<5
  clim1=[];
end;
if isempty(clim1)
  good =find(~isnan(Z1));
  clim1=[min(Z1(good)) max(Z1(good))];
end;
if nargin<6
  clim2=[];
end;
if isempty(clim2)
  good =find(~isnan(Z2));
  clim1=[min(Z2(good)) max(Z2(good))];
end;
if nargin<7
  shadelim=[];
end;
if isempty(shadelim)
  shadelim=0.6;
end;
if nargin<8;
  cmap=[];
end;
if isempty(cmap)
  cmap=colormap;
end;  
if nargin<9
  pcol=1;
end;

% DONE ARGUING START WORKING....
    
% get the C1 from Z1
Z1= clip(Z1,clim1(1)+10*eps,clim1(2)-10*eps);
Z2= (clip(Z2,clim2(1),clim2(2))-clim2(1))/diff(clim2);

Z2 = Z2*(1-shadelim)+shadelim;
if pcol
  hp = pcolor(x,y,Z1);
else
  hp = imagesc(x,y,Z1)
  %  echo('Using imagesc');
end
caxis(clim1);


g = get(hp);
cdata = g.CData;
idx = g.CData;

siz = size(cdata);
nColors = size(cmap,1);

idx = ceil( (double(cdata) - clim1(1)) / (clim1(2)-clim1(1)) * nColors);

for i = 1:3,
  c = cmap(idx,i).*Z2(:);
  c = reshape(c,siz);
  realcolor(:,:,i) = c;
end
set(hp,'cdata',realcolor);

return;

function x=clip(y,miny,maxy);
% function x=clip(y,miny,maxy);
%
% clip y by the min and max.
  
x=y;
x(find(x<miny))=miny;
x(find(x>maxy))=maxy;


function run_demo

% [cmp,hueout] = twohue(7/12,1/12,64,0.3,0.2,0.3,0.7,1)
cmp = redblue(64);

load Udemo 
dU = conv2(diff(U),ones(2,1)/2,'full');
dU = conv2(dU,ones(1,3)/3,'same')/3;

figure(1);

subplot(2,1,1);
imagesc(U)
caxis([-1 1]/4);

subplot(2,1,2);
imagesc((dU))
caxis([-1 1]/300);
colormap(cmp);

figure(2);
subplot(2,1,1);
shadedpcolor(x,z,U,(dU),[-1 1]/4,[-1 1]/300,0.7,cmp,0);
shading flat;
axis ij;
shadedcolorbar('v',[-1 1]/4,0.7,cmp);

subplot(2,1,2);
shadedpcolor(x,z,U,(dU),[-1 1]/4,[-1 1]/300,0.55,cmp,0);
shading flat;
axis ij;
shadedcolorbar('v',[-1 1]/4,0.55,cmp);

