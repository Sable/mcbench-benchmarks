%RESIZE_LEGEND_TEST - Demo script for RESIZE_LEGEND
%
% Syntax:  resize_legend_test
%
% See also: RESIZE_LEGEND, LEGEND

% Author: Denis Gilbert, Ph.D., physical oceanography
% Maurice Lamontagne Institute, Dept. of Fisheries and Oceans Canada
% http://www.qc.dfo-mpo.gc.ca/iml/
% December 1999; Last revision: 21-Aug-2002


%Create synthetic data 
x = 0:10;
y1 = x/10;
y2 = x.^2/100; 
y3 = x.^3/1000;
y4 = x.^4/10000;
y5 = x.^5/100000;
y6 = x.^6/1000000;

%Plot the data
figTest = figure;
hold on
plot (x, y1, '-')
plot (x, y2, '.-')
plot (x, y3, 'v-')
plot (x, y4, '^-')
plot (x, y5, 's-')
plot (x, y6, '*-')

%Produce legend
hL = legend (...
   'Line 1', ...
   'Line 2', ...
   'Line 3', ...
   'Line 4', ...
   'Line 5', ...
   'Line 6',2);

%Display interactive dialog
disp(' ');
disp('Hit the space bar to increase legend size by a factor of 1.5');
disp(' ');
pause

%Increase legend fontsize by a factor of 1.5
resize_legend(hL, 1.5)
% legend('boxoff')

disp(' ');
disp('You may need to reposition the legend''s position')
disp('manually by dragging it with the mouse');
disp(' ');

%------------- END OF CODE --------------