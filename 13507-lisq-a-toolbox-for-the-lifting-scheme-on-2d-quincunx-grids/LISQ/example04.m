% Small technical example.
% Shows how to call for the multiresolution reconstruction of an image
% after its decomposition.
%
disp('Small technical example.');
disp('Shows how to call for the multiresolution reconstruction of an image');
disp('after its decomposition.');
disp('FOR MORE INFORMATION:  help QLiftRec2');
disp(' ');
disp('See also the report http://repository.cwi.nl:8888/cwi_repository/docs/IV/04/04178D.pdf');
disp('Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>');
disp(' (C) 1998-2006 Stichting CWI, Amsterdam, The Netherlands');
disp(' ');
%---PARAMETERS-----------------------------------------------------------------
% How to execute, set parameters
N = 6;        %  maximum level (even number) in lifting scheme
%filtername = 'Neville4';
filtername = 'maxmin';
%
%---INSERT YOUR IMAGE HERE-----------------------------------------------------
if exist('imread','file') == 2
  Orig = double(imread('zenithgray.TIF','tiff'));
else
  load zenithgray; Orig = zenithgray; clear zenithgray;
end
%
disp([' Dimensions of original      ' int2str( size(Orig) )]);
%---DECOMPOSITION-------------------------------------------------------------
disp([' Filter type is ' filtername]);
[C,S] = QLiftDec2(Orig,N,filtername);
%
%---RECONSTRUCTION------------------------------------------------------------
X = QLiftRec2(C,S,filtername);
%
diff = X - Orig;  two_norm_difference = sum(sum(diff.*diff))^(1/2);
disp(' The 2-norm of the difference between the original and its reconstruction');
disp([' reads ' num2str( two_norm_difference, '%+12.4e')]);


