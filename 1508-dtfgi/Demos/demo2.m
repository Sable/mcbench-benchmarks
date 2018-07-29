%
%ADVANCED Demo for the Matlab interface 
%for DT Open Layer Framegrabbers        
%
%Date: 16-05-2000                       
%Copyright (c) 2000 C. L. Wauters, R. Heil       
%SYNTAX demo2('alias')                  
%
%
%
%DESCRIPTION This demo function will give the user an
%example of the ADVANCED options of the Matlab Frame Grabber 
%Interface(FGI). The user has to give the alias from the device 
%as input argument. The user has to know this alias.
%
%
%INPUT The alias (alias) of the framegrabber device.
%
%
%EXAMPLE To start the framegrabber demo with alias 'DT3152' 
%type in the Matlab Command Window : 
%			
%demo2('DT3152');
%

function demo2(alias)
fprintf('»m=openfg(''%s'');',alias)
m = openfg(alias)
disp ('***	If you lose the handle to the device you can get it back with the function gethandle')
disp ('***	Now we will clear the handle')
disp('»clear(m)')
clear m;
disp ('***	Now we will get the handle back with the function gethandle')
fprintf('»m=gethandlefg(''%s'');',alias)
m=gethandlefg(alias)
disp('***	You can check if the device has been opened with the function isopenfg')
disp('***	isopenfg returns a boolean')
fprintf('»isopenfg(''%s'');',alias)
isopenfg(alias)
disp (' isopenfg returns 1, the device has been opened')
closefg(m);
disp ('*** Example Livestreaming gray 256')
disp('*** Grabbing sequence started...');
disp('*** Please wait...');
%the device will be opened
m=openfg(alias);
disp('***	We will set the colormap to gray(256)');
disp('»colormap gray(256)')
imagesc(grabfg(m)');
colormap gray(256);
%We will fill the matrix with the data
c=get(gca,'Children');
%  get(c);
%	We will set the EraseMode to None for reducing the blinking 
set(c,'EraseMode','None');   
for i=1:10
set(c,'CData',grabfg(m)');
% CData has been filled
drawnow ;
end
disp('Grabbing sequence completed.');
closefg(m);
