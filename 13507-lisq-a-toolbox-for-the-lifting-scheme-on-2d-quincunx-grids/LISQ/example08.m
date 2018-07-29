% Small technical example.
% Demonstrates how to show the details on the rotated quincunx grid.
%
disp('Small technical example.');
disp('Demonstrates how to show the details on the rotated quincunx grid.');
disp('FOR MORE INFORMATION:  help rota1001fill');
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
disp([' Dimensions of original      ' int2str( size(Orig) )]);
%---PARAMETERS-----------------------------------------------------------------
% How to execute, set parameters
%
 N=2;
%
 filtername='maxmin';
%
% Manage output, set preferences: see printshop
 dops   =3;
 dotiff =0;
%------------------------------------------------------------------------------
% Show original image
printshop('figOriginal', ' Original ', Orig, dops, dotiff, []);
%---DECOMPOSITION--------------------------------------------------------------
disp([' Filter type is ' filtername]);
disp([' Number of scales asked for is ' int2str(N)]);
[C,S] = QLiftDec2(Orig,N,filtername);
%
% Show the details (at level 1) on the rotated quincunx grid
[Detail10, Detail01] = retrieveQ1001(1, 'd', C, S);
background=max(max(max(Detail10)), max(max(Detail01)));
RotaDet=rota1001fill(Detail10, Detail01, background);
printshop('figDetail', 'Detail on the rotated quincunx grid', ...
          RotaDet, dops, dotiff, []);
%
Approx = retrieveR(N, 'a', C, S);
printshop('figApprox', 'Approximation', Approx, dops, dotiff, []);
