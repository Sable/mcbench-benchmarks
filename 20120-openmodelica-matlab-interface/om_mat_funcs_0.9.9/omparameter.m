function [success] = omparameter (modelname,name,wert);
% Change parameter in *_init.txt file; Returns linenumber replaced if
% succeeded, -1 if not.
% SYNTAX: [linenumber] = omparameter(modelname,parameter,value)
% Beispiel: omparameter('package.model','stop value',10)
%
% Feedback/problems: Christian Schaad, ingenieurbuero@christian-schaad.de

success=-1;
inputfile=[modelname,'_init_original.xml'];
outputfile=[modelname,'_init.xml'];
%def_output=['outputFormat   = "mat"'];
%plt_output=['outputFormat   = "plt"'];

fid=fopen(inputfile);
i=0;
while 1
    i=i+1;
    tline0 = fgetl(fid);
    if ~ischar(tline0), break, end
    tline= [tline0,char(10)];
    %if ~isempty(strfind(tline,def_output));
    %tline=[plt_output,char(10)];
    %disp('MAT-Output changed to PLT-Output')	
    %end
    if ~isempty(strfind(tline,['name = "',name,'"',char(10)]))
    for k=0:7
    dataset(i+k).string=tline;
    tline0 = fgetl(fid);
    tline= [tline0,char(10)];
    end
    i=i+k+1;

    tline=['<Real start="',wert,'" fixed="true" />',char(10)	];
    %disp(tline)
    success=i;
    end

    dataset(i).string=tline;
    clear tline tline0;
       
end
fclose(fid);

fid=fopen(outputfile,'w');
for j=1:i-1
fprintf(fid,[dataset(j).string]);
end
fclose(fid);
switch success
    case -1
        error(['Parameter ',name,' not found!']);
end; 
disp(['Replaced line number ',num2str(success),', parameter ',num2str(name),' with ',num2str(wert) ]);

