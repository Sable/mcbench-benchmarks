% Small technical example.
% Performs a check on the computation of certain central moments
% on a quincunx grid.
%
disp('Small technical example.');
disp('Performs a check on the computation of certain central moments');
disp('on a quincunx grid.');
disp('FOR MORE INFORMATION:  help Q0011mupq');
disp(' ');
disp('See also the report http://repository.cwi.nl:8888/cwi_repository/docs/IV/04/04178D.pdf');
disp('Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>');
disp(' (C) 1998-2006 Stichting CWI, Amsterdam, The Netherlands');
disp(' ');
%---INSERT YOUR IMAGE HERE-----------------------------------------------------
if exist('imread','file') == 2
  Orig = double(imread('zenithgray.TIF','tiff'));
else
  load zenithgray; Orig = zenithgray; clear zenithgray;
end
%
disp([' Dimensions ' int2str( size(Orig) )]);
%---EXTRACT A QUINCUNX GRIDFUNCTION-----
F00 = getcolor00(Orig);
F11 = getcolor11(Orig);
disp('The dimensions of the extracted quincunx gridfunction read as follows');
disp([int2str(size(F00)) ' and ' int2str(size(F11))]);
%
%---COMPUTE MASS------------------------
mu00 = Q0011mupq(F00, F11, 0, 0);
disp([' Mass  ' num2str( mu00, '%+12.4e')]);
%---NICE CHECK: OUTCOME SHOULD VANISH---
mu10 = Q0011mupq(F00, F11, 1, 0);
disp(' NICE CHECK: First order central moment (x-dir) should vanish');
disp([' reads ' num2str( mu10, '%+12.4e')]);
%---NICE CHECK: OUTCOME SHOULD VANISH---
mu01 = Q0011mupq(F00, F11, 0, 1);
disp(' NICE CHECK: First order central moment (y-dir) should vanish');
disp([' reads ' num2str( mu01, '%+12.4e')]);
