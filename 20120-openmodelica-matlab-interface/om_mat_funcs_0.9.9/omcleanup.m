function omcleanup (modelname) 
%
% Clean up all the compilation stuff...
%
% Feedback/problems: Christian Schaad, ingenieurbuero@christian-schaad.de

delete simo.mos;
delete([modelname,'.makefile']);
delete([modelname,'.log']);
delete([modelname,'.libs']);
delete([modelname,'.c']);
delete([modelname,'.h']);
delete([modelname,'.o']);
delete([modelname,'_functions.c']);
delete([modelname,'_functions.h']);
delete([modelname,'_records.c']);
delete([modelname,'_records.o']);

delete(['_',modelname,'.h']);

delete([modelname,'.cpp']);


