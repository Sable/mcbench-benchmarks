%% Get data from an HTML table straight into MATLAB
% Copyright 2008 - 2010 The MathWorks, Inc.

%% Navigate to a webpage with a table 
% You have to use the MATLAB browser because this takes advantage of the
% matlabcolon (matlab:) protocol.
web('http://finance.yahoo.com/q/ks?s=GOOG')
% give it time to load the page
pause(3)
%% Call the function to grab the data
getTableFromWeb
%% Updated Browser
% This shows what the browser looks like.  This is just a screenshot but it
% would be whatever page you are on with MATLAB icons next to tables.
im = imread('mlPage.jpg');
imshow(im);
%% Select the table 
% You can select the table interactively by clicking on the MATLAB icon or
% passing a number to the getTableFromWeb function.  I have selected to get
% the Valuation Measures
myTableData = getTableFromWeb(8)