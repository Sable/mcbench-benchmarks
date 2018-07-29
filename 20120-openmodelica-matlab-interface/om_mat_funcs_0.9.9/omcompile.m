function omcompile (filename,modelname,varargin)  % Filename des *.mo-files, modellname, libraries, debug
%
% Loads Modelica-File *.mo and compiles  Model modelname,
% optionally loads additional libraries such as 'Modelica' or sets debug flag, first all old files
% are deleted. After compilation the *_init.txt file is copied to *_init_original.txt 
%
% SYNTAX: omcompile(filename,modelname,libraries,debug) modelica:
% optional 0/1, debug: optional 0/1
% z.B. omcompile('Testrig.mo','package.modelname','Modelica','Modelica_Fluid',0)
% 
% IMPORTANT: Under Windows, the path to omc.exe has to be adapted (see code)!!
%
% Feedback/problems: Christian Schaad, ingenieurbuero@christian-schaad.de

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Adapt path here!!!!%%%%%%%%%
win_om_path='C:\OpenModelica1.4.4\bin\';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

linux=isunix;
%L??schen des MOS-Files, der Executable und Resultdateien, etc.
omcleanup(modelname);
delete([modelname,'_res.mat']); 
delete([modelname,'.exe']);
delete(modelname);
delete([modelname,'_init.xml']);
debug=0;
if  ~isempty(varargin)
switch varargin{end}
    case 1
        debug=1;
        varargin(end)=[];
    case 0
        debug=0;
        varargin(end)=[];
end
end
% Erzeugen des MOS-Files


mosstring=['loadModel(Modelica);\n loadFile("',filename,'");\n instantiateModel(',modelname,');\n  buildModel(',modelname,');\n'];
for i=1:length(varargin)
mosstring=cat(2,[' loadFile("',varargin{i},'");\n'],mosstring)
end
 %if exist('modelica')&&modelica==1
%    mosstring=['loadModel(Modelica);\n loadModel(Modelica_Fluid);\n loadFile("',filename,'");\n instantiateModel(',modelname,');\n simulate(',modelname,');\n'];
%end




% Kompilieren und Simulieren der Kommandos im Modelica-Script-File "simo.mos"

if exist('debug')&&debug==1
    switch linux
        case 1
            fid = fopen('simo.mos','w');
            fprintf(fid,mosstring);
            fclose(fid);
           
           system('LD_LIBRARY_PATH= omc +d=failtrace +s simo.mos')
           % eval(['system(''Compile ',modelname,''')'])
           %system('omc +s simo.mos')
            pause(0.5)
	    eval(['system(''cp ',modelname,'_init.xml ',modelname,'_init_original.xml'')']);

        case 0
            fid = fopen('simo.mos','w');
            fprintf(fid,mosstring);
            fclose(fid);
            system([win_om_path,'omc.exe +d=failtrace +s simo.mos'])
	    eval(['!copy ',modelname,'_init.xml ',modelname,'_init_original.xml']);

	    
    end
else
    switch linux
        case 1
            fid = fopen('simo.mos','w');
            fprintf(fid,mosstring);
            fclose(fid);
            system('LD_LIBRARY_PATH= omc +s simo.mos')
           %system('omc +s simo.mos')
           % eval(['system(''Compile ',modelname,''')'])
	    eval(['system(''cp ',modelname,'_init.xml ',modelname,'_init_original.xml'')']);

        case 0
            fid = fopen('simo.mos','w');
            fprintf(fid,mosstring);
            fclose(fid);
            system([win_om_path,'omc.exe +s simo.mos'])
            eval(['!copy ',modelname,'_init.xml ',modelname,'_init_original.xml']);

    end
end

% if exist('debug')
%     if debug==1
%         switch linux
%             case 1
%                 fid = fopen('~/OpenModelica/work/simo.mos','w');
%                 fprintf(fid,mosstring);
%                 fclose(fid);
%                 eval(['!cp ',filename,' ~/OpenModelica/work/']);
%                 system('omc +d=failtrace +s simo.mos')
%             case 0
%                 fid = fopen('simo.mos','w');
%                 fprintf(fid,mosstring);
%                 fclose(fid);
%                 system([win_om_path,'omc.exe +d=failtrace +s simo.mos'])
%         end
%     end
% end
% Kopieren der Konfiguratonsdatei nach *originial



