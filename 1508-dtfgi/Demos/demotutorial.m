%
%Demo Tutotarial for the Matlab interface
%for DT Open Layer Framegrabbers         
%
%
%Copyright (c) 2000 C. L. Wauters, R. Heil        
%SYNTAX demo('alias')                    
%
%
%
%DESCRIPTION This demonstration will give 
%the user an example of the options of the Matlab Frame 
%Grabber Interface (FGI). The user has to give the alias 
%from the device as input argument. The user has to 
%know this alias.
%
%INPUT The alias (alias) of the framegrabber device.
%
%
%EXAMPLE To start the framegrabber demo with alias 'DT3152' 
%type in the Matlab Command Window : 
%			
%demotutorial('DT3152');
%

function demotutorial(alias)
clc
disp ('***	The Device will be opened...')
fprintf('»m=openfg(''%s'')\n',alias)
disp('***	m is the device information structure')
disp(' ')
disp ('***	Press a key to continue')
pause
m = openfg(alias)
disp(' ')
disp ('***	Press a key to continue')
pause
clc
disp ('***	The Device can be closed in two ways')
disp ('***	We can close the device with the handle')
disp('»closefg(m)')
closefg(m)
disp(' ')
disp ('***	Press a key to continue')
pause
disp ('***	We can also close the device with the alias name')
fprintf('»closefg(''%s'');\n',alias)
m = openfg(alias);
closefg(alias)
m = openfg(alias);
disp(' ')
disp ('***	Press a key to continue')
pause
clc
disp ('***	If you lose the handle to the device you can get it back with the function gethandle')
disp ('***	Now we will clear the handle')
disp('»clear(m)')
disp(' ')
disp ('***	Press a key to continue')
pause
clear m;
disp ('***	Now we will get the handle back with the function gethandle')
disp(' ')
fprintf('»m=gethandlefg(''%s'');\n',alias)
disp ('***	Press a key to continue')
pause
m=gethandlefg(alias)
disp(' ')
disp('***	You can check if the device has been opened with the function isopenfg')
disp('***	isopenfg returns a boolean')
fprintf('»isopenfg(''%s'');\n',alias)
isopenfg(alias)
disp (' isopenfg returns 1, the device has been opened')
closefg(m);
disp ('***	Press a key to continue')
pause
clc
disp(' ')
		disp('***	press 1 for grabbing one image')
		disp('***	press 2 for getting and setting values')
		disp('***	press 3 for live streaming example')
      disp('***	press 4 for quitting the Demo')
inputvar = input('Enter your choice:  ','s');
while isempty(inputvar)
   disp('Please enter 1, 2, 3 or 4')
	inputvar = input('Enter your choice:  ','s');
end

while inputvar ~= '4' 
   if inputvar=='1'
      clc
      %the device will be opened
   	m=openfg(alias);
   	% grab the image in matrix im (' will transpose the matrix)
     	disp('*** Grabbing started...');
      im=grabfg(m)';
   	imagesc(im);
      disp('Grabbing sequence completed.');
      disp(' ')
      disp ('***	Press a key to continue')
		pause

      closefg(m);
		disp('***	press 1 for grabbing one image')
		disp('***	press 2 for getting and setting values')
		disp('***	press 3 for live streaming example')
      disp('***	press 4 for quitting the Demo')
		inputvar = input('Enter your choice:  ','s');
   end
   if inputvar=='2'
      clc
		disp('***	We will give an example of the functions getfg and setfg.');
  		disp('***	This function wil let you get and set values of the device information structure');
  		disp('***	We will open the device and show the device information structure');
  		disp(' ');
		fprintf('»m=openfg(''%s'');\n',alias)
  		m=openfg(alias)
   	if strcmp(alias,'DT3155')
      	disp('You are working with the DT3155 camera');
      	disp('We will get the value of Blacklevel from the structure');
  	   	disp('»getfg(m,''BlackLevel'');')
      	pause
      	disp(' ');
      	disp ('***	Press a key to continue')
      	disp ('***	The value of the parameter: ''BlackLevel'' will be printed...')
      	getfg(m,'BlackLevel')
      	disp('We will set the parameter ''Blacklevel'' from the structure to 16000');
      	disp('»setfg(m,''BlackLevel'',16000);')
      	setfg(m,'BlackLevel',16000);
      	closefg(m)
      	disp ('***	Press a key to continue')
      	pause
      	end
   	if ~strcmp(alias,'DT3155')
      	disp('*** setting parameter of this camera is in the demo not available');
      	disp('*** check the source code of the demo for examples of setting a parameter ');
      	disp ('***	Press a key to continue')
      	pause	
   		end
			clc   
		disp('***	press 1 for grabbing one image')
		disp('***	press 2 for getting and setting values')
		disp('***	press 3 for live streaming example')
      disp('***	press 4 for quitting the Demo')
			inputvar = input('Enter your choice:  ','s');
	end   
	if inputvar=='3'
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
		for i=1:500
		   set(c,'CData',grabfg(m)');
   		% CData has been filled
		   drawnow ;
   	end
		disp('Grabbing sequence completed.');
		disp ('***	Press a key to continue')
		pause
		closefg(m);
		clc
		disp('***	press 1 for grabbing one image')
		disp('***	press 2 for getting and setting values')
		disp('***	press 3 for live streaming example')
      disp('***	press 4 for quitting the Demo')
      
		inputvar = input('Enter your choice:  ','s');
	end;
end;

