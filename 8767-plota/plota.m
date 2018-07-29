function plota(varargin)
% PLOTA 
%  is the same as standard PLOT function, BUT it plots each new plot
%    using other color ( making 'hold on' automatically and cycling 
%    through the colors in the order specified by the current axes 
%    ColorOrder property )
%
%  EXAMPLE:
%  figure;
%  plota(randn(1,100));
%  plota(randn(1,100));
%  plota(randn(1,100));
%  legend('First call to plota', 'Second call to plota', 'Third call to plota')

% Version 1.0
% Alex Bur-Guy, October 2005
% alex@wavion.co.il
%
% Revisions:
%       Version 1.0 -   initial version
ca = get(get(0,'CurrentFigure'),'CurrentAxes');
if isempty( ca )     
     ordi0 = 0;
else
     ordi0 = length(get(ca,'Children'));
     set( gca, 'NextPlot', 'add' );
end
hp = plot( varargin{:} );
ColOrd = get(gca, 'ColorOrder');
children = get(gca,'Children');
ordi = length(children);
ord = mod((ordi0+1:ordi)-1, size(ColOrd,1));
cc = 0;
for ii = (ordi - ordi0): -1 : 1
     cc = cc + 1;
     set(children(ii), 'Color', ColOrd(((ordi0+cc)<=size(ColOrd,1))*(ordi0+cc) + ((ordi0+cc)>size(ColOrd,1))*(ord(cc)+1), :));
end