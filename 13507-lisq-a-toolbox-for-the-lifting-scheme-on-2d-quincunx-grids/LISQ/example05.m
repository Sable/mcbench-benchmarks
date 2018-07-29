% Small technical example.
% Shows how to ask for the maximum number of levels in a decomposition.
%
disp('Small technical example.');
disp('Shows how to ask for the maximum number of levels in a decomposition.');
disp('FOR MORE INFORMATION:  help QLmaxlev');
disp(' ');
disp('See also the report http://repository.cwi.nl:8888/cwi_repository/docs/IV/04/04178D.pdf');
disp('Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>');
disp(' (C) 1998-2006 Stichting CWI, Amsterdam, The Netherlands');
disp(' ');
%---PARAMETERS-----------------------------------------------------------------
% How to execute, set parameters
N = 20;        %  maximum level (even number) in lifting scheme
filtername = 'Neville4';
%
%---INSERT YOUR IMAGE HERE-----------------------------------------------------
if exist('imread','file') == 2
  Orig = double(imread('zenithgray.TIF','tiff'));
else
  load zenithgray; Orig = zenithgray; clear zenithgray;
end
%
disp([' Dimensions of original      ' int2str( size(Orig) )]);
%---AVOID SILLY VALUES FOR THE NUMBER OF LEVELS-------------------------------
disp([' Filter type is ' filtername]);
disp([' Number of scales asked for is ' int2str(N)]);
M = QLmaxlev(size(Orig), filtername);
disp([' Maximum number of scales is   ' int2str(M)]);
N = min(N,M);
disp([' Number of scales is set to    ' int2str(N)]);
%
%---DECOMPOSITION-------------------------------------------------------------
[C,S] = QLiftDec2(Orig,N,filtername);
