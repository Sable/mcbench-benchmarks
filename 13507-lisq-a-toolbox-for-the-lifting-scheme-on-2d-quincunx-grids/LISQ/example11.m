% Small technical example.
% Demonstrates how to show an all-scales image (superimage) of the
% multiresolution decomposition that has been made in the way of LISQ.
%
disp('Small technical example.');
disp('Demonstrates how to show an all-scales image (superimage) of the');
disp('multiresolution decomposition that has been made in the way of LISQ.');
disp('FOR MORE INFORMATION:  help QLsuperimage');
disp(' ');
disp('See also the report http://repository.cwi.nl:8888/cwi_repository/docs/IV/04/04178D.pdf');
disp('Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>');
disp(' (C) 1998-2006 Stichting CWI, Amsterdam, The Netherlands');
disp(' ');
%---PARAMETERS-----------------------------------------------------------------
% How to execute, set parameters
%
 N=4;
%
 filtername='maxmin';
%filtername='Neville4';
%
% Manage output, set preferences: see printshop
 dops   =3;
 dotiff =0;
%
%---INSERT YOUR IMAGES HERE----------------------------------------------------
%
if exist('imread','file') == 2
% Convert files with .tif format into matrix of grayvalues
  Orig = double(imread('trui.tif','tiff'));
else
  load trui; Orig = trui; clear trui;
end
% load zenithgray; Orig = zenithgray; clear zenithgray;
%------------------------------------------------------------------------------
% Some preliminaries
disp([' Filter type is ' filtername]);
disp([' Number of scales asked for is ' int2str(N)]);
%
% Show original image
printshop('figOriginal', ' Original ', Orig, dops, dotiff, []);
%
% Decomposition
%
[C,S] = QLiftDec2(Orig,N,filtername);
%
% Create an image that comprises all levels of the decomposition
% as is.
superima = QLsuperimage(C, S);
printshop('figSuper1', 'Decomposition as is', superima, dops, dotiff, []);
%
% Create an image that comprises all levels of the decomposition
% but remove outliers first.
superima = QLsuperimage(C, S, 2);
printshop('figSuper2', 'Decomp. without outliers', superima, dops, dotiff, []);
%
% Create an image that comprises all levels of the decomposition
% and enhance contrast using histogram equalisation (if available).
superima = QLsuperimage(C, S, 3);
printshop('figSuper3', 'Decomposition equalised', superima, dops, dotiff, []);
