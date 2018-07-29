%
%BASIC Demo for the Matlab interface 
%for DT Open Layer Framegrabbers     
%
%Date: 16-05-2000                    
%Copyright (c) 2000 C. L. Wauters, R. Heil   
%SYNTAX demo1('alias')               
%
%
%DESCRIPTION This demo function will give the user an
%example of the BASIC options of the Matlab Frame Grabber 
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
%demo1('DT3152');
%

function demo1(alias)
disp ('***	The Device will be opened...')
fprintf('»m=openfg(''%s'');',alias)
disp('***	m is the device information structure')
m = openfg(alias)
disp ('***	The Device can be closed in two ways')
disp ('***	We can close the device with the handle')
disp('»closefg(m)')
closefg(m)
disp ('***	We can also close the device with the alias name')
fprintf('»closefg(''%s'');',alias)
m = openfg(alias);
closefg(alias)
% grabbing one image
%the device will be opened
m=openfg(alias);
% grab the image in matrix im (' will transpose the matrix)
im=grabfg(m)';
imagesc(im);
% also possible in matlab: imagesc(grabfg(m)')
closefg(alias);
disp('***	We will give an example of the functions getfg and setfg.');
disp('***	This function wil let you get and set values of the device information structure');
m=openfg(alias)
disp('We will get the value of the variable InputChannel from the structure');
disp('»getfg(m,''InputChannel'');')
getfg(m,'Inputchannel');
disp('We will set the parameter ''InputChannel'' from the structure to 2');
disp('»setfg(m,''InputChannel'',2);')
setfg(m,'InputChannel',2);
closefg(m)
