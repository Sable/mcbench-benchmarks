function  resize_legend (hL, ResizeFact)
%RESIZE_LEGEND - Changes LEGEND fontsize
%  while maintaining proper alignment between
%  the legend's text strings and line symbols
%
%Syntax:  resize_legend(hL, ResizeFact);
%
%Inputs: 
%        hL           Legend axes handle
%        ResizeFact   Factor by which to resize the legend.
%              
%Output: none
%
%Example: 
%         hL = legend(h,'string1','string2',...);
%         resize_legend(hL,2); %Make fontsize twice bigger
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: RESIZE_LEGEND_TEST,  LEGEND

% Author: Denis Gilbert with input from Jim Phillips, 03-Dec-1999
% Maurice Lamontagne Institute, Dept. of Fisheries and Oceans Canada
% Web: http://www.qc.dfo-mpo.gc.ca/iml/
% December 1999; Last revision: 28-Sep-2004


%------------- BEGIN CODE --------------

if nargin ~= 2 
    error('Two input arguments are required')
end

p = get(hL, 'position');
p(3) = p(3)*ResizeFact;
p(4) = p(4)*ResizeFact;
set(hL,'position', p)
ht = findobj( get(hL,'children'), 'type', 'text');
set(ht, 'FontSize', get(ht(1),'FontSize')*ResizeFact)
% set(gcf,'Resizefcn','')  %Uncomment this line in Matlab 5.x

%------------- END OF CODE --------------