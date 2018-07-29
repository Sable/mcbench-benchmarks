function omrun (modelname,datasetfile)  % Filename des *.mo-files, modellname
%
% Execute compiled Modelica-Model with 'datasetfile', containing
% parameters, etc. while the existing datasetfile 'modelname_init.txt' is copied to 'modelname_init_old.txt.
%
% SYNTAX: omrun(modelname,datasetfile) optional: datasetfile
% Beispiel: omrun('package.model','mydasetfile')
%
% Feedback/problems: Christian Schaad, ingenieurbuero@christian-schaad.de


delete([modelname,'_res.mat']); % Delete old result file

linux=isunix;
if exist('datasetfile')
% Originales Datasetfile sichern...
%switch linux
%    case 1
%eval(['!cp ',modelname,'_init.txt ',modelname,'_init_old.txt']);
%    case 0
%eval(['!copy ',modelname,'_init.txt ',modelname,'_init_old.txt']);
%end
% Neues Datasetfile kopieren...
switch linux
    case 1
eval(['!cp ',datasetfile,' ',modelname,'_init.xml']);
    case 0
        eval(['!copy ',datasetfile,' ',modelname,'_init.xml']);
end
end
% Ausf???hren....



switch linux
    case 1
    %    eval(['system(''./',modelname,''') '])      %%% Use this for OM_1.4.4 (linux)
	 eval(['system(''LD_LIBRARY_PATH= ./',modelname, ''') '])    %%% Use this for OM_1.4.3   (linux)
    case 0
        eval(['system(''',modelname,'.exe'')'])
end


