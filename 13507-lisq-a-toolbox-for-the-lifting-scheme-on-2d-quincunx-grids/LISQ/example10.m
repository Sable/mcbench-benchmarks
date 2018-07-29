% Small technical example.
% Shows in what way a gridfunction of colour 10 at odd level is stored.
%
disp('Small technical example.');
disp('Shows in what way a gridfunction of colour 10 at odd level is stored.');
disp('FOR MORE INFORMATION:  help whatcoef2QL');
disp(' ');
disp('See also the report http://repository.cwi.nl:8888/cwi_repository/docs/IV/04/04178D.pdf');
disp('Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>');
disp(' (C) 1998-2006 Stichting CWI, Amsterdam, The Netherlands');
disp(' ');
%---PARAMETERS-----------------------------------------------------------------
% How to execute, set parameters
N = 6;                   %  maximum level (even number) in lifting scheme
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
%---DECOMPOSITION--------------------------------------------------------------
disp([' Filter type is ' filtername]);
[C,S] = QLiftDec2(Orig,N,filtername);
%
%---FIND OUT HOW DETAIL WITH COLOUR 10 AT ODD LEVEL HAS BEEN STORED------------
level = N-1;
[first, last] = whatcoef2QL(level, '10', 'd', S);
disp(['The storage of detail at level ' int2str(level) ' with colour 10']);
disp(['ranges from index ' int2str(first) ' to ' int2str(last)]);
