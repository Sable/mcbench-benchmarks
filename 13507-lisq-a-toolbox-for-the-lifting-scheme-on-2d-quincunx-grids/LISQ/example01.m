% Small technical example.
% Performs a check on the computation of certain central moments.
%
disp('Small technical example.');
disp('Performs a check on the computation of certain central moments.');
disp('FOR MORE INFORMATION:  help mupq');
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
%------------------------------------------------------------------------------
disp([' Mass  ' num2str( mupq(Orig, 0, 0), '%+12.4e')]);
%
disp(' NICE CHECK: First order central moment (x-dir) should vanish');
disp([' reads ' num2str( mupq(Orig, 1, 0), '%+12.4e')]);
%
disp(' NICE CHECK: First order central moment (y-dir) should vanish');
disp([' reads ' num2str( mupq(Orig, 0, 1), '%+12.4e')]);
%
