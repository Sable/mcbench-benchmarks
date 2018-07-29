% Small technical example.
% Demonstrates an expedient for showing an image.
%
disp('Small technical example.');
disp('Demonstrates an expedient for showing an image.');
disp('FOR MORE INFORMATION:  help printshop');
disp(' ');
disp('See also the report http://repository.cwi.nl:8888/cwi_repository/docs/IV/04/04178D.pdf');
disp('Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>');
disp(' (C) 1998-2006 Stichting CWI, Amsterdam, The Netherlands');
disp(' ');
%------------------------------------------------------------------------------
load zenithgray; Orig = zenithgray; clear zenithgray;
printshop('original','Nice watch', Orig, 3, 0, []);
