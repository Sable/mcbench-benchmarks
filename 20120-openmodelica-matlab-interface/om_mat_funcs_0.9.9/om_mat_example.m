%  Examplescript for usage of omcompile, omrun, omparameter, omimport
%  and omcleanup
%  For more help, look into the help of the functions and the functions
%  themselves. E.g. it's important to adapt the path to omc.exe in
%  omcompile.m. You could maybe improve performance by changing some value in omimport.m 
%
%  Feedback/problems: Christian Schaad, ingenieurbuero@christian-schaad.de

clear all; close all;hold on;

modelname='HelloWorld.test';   % Set Modelname

omcompile('hello.mo',modelname);  % Load hello.mo, compile and run HelloWorld.test, do NOT load Modelica library (0), no debug (0)

omcleanup(modelname)  % Delete the compiler logs, makefile, etc. 


%omparameter(modelname,'stop value',2.5);  % Change "stop value" in parameter file

%omparameter(modelname,'step value',1e-02);% Change "step value" in parameter file 


j=1;
for value=2:1.5:10;   % Loop over values of parameter a

omparameter(modelname,'Hello1.a',num2str(value));  % Change parameter Hello1.a in parameter file to value

omrun(modelname)  % Run the compiled model 

omimport(modelname);  % Read results into Matlab workspace


plot(time,Hello1.x)   % plot, legend, save or whatever...
hold all;
legende(j).name=['Hello1.a=',num2str(value)]; 
j=j+1;
end;

legend(legende.name)

clear legende i j
grid on;

% Use omparvar.m for automatical creation of plots with different
% parameters...



