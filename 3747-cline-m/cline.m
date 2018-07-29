% This function plots a 3D line (x,y,z) encoded with scalar color data (c)
% using the specified colormap (default=jet);
%
% SYNTAX: h=cline(x,y,z,c,colormap);
%
% DBE 09/03/02

function h=cline(x,y,z,c,cmap);

if nargin==0  % Generate sample data...
  x=linspace(-10,10,101);
  y=2*x.^2+3;
  z=sin(0.1*pi*x);
  c=exp(z);
  w=z-min(z)+1;
  cmap='jet';
elseif nargin<4
  fprintf('Insufficient input arguments\n');
  return;
elseif nargin==4
  cmap='jet';
end

cmap=colormap(cmap);                      % Set colormap
yy=linspace(min(c),max(c),size(cmap,1));  % Generate range of color indices that map to cmap
cm = spline(yy,cmap',c);                  % Find interpolated colorvalue
cm(cm>1)=1;                               % Sometimes iterpolation gives values that are out of [0,1] range...
cm(cm<0)=0;

% Lot line segment with appropriate color for each data pair...
  for i=1:length(z)-1
    h(i)=line([x(i) x(i+1)],[y(i) y(i+1)],[z(i) z(i+1)],'color',[cm(:,i)],'LineWidth',3);
  end

return
