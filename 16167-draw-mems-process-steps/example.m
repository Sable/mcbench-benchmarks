%This is an example of using the matlab scripts for drawing MEMS fabrication process cross-section. Only support deposit, lithography, and etch(isotropic and anisotropic is not differentied here.). Materials can be used is Si, SiNi,SiO2, metal, PR(photoresistor).

% basic syntax:
% 1. deposit ('materialName', layerThickness), where materialName is one of Si, SiNi, SiO2, metal, PR. layerThickness is an integer, normally it is between 1 and 20.
% 2. liga(mask), where mask is an series of char combined by ' ' and '-', this function lithography photoresistor, so it should used after an layer of PR is deposited.
% 3. etch('materialName'): material which is appointed will be etched from top to bottom until meet an fully cover other material layer.
% 4. removepr('PR'): remove all the photoresistor.
% 5. drawlayers(); draw current result.
% DATE: 30/8/2007
% muwn.gu@gmail.com
%========donot modify the head
clear all;
clear global;
loadlayerprofile('MEMS');
global layerMatrix;
global Layerprofile;
figure(1);
%===================

%*******************replace below to your own process
mask1 = ' --     ---     --      -  ';	% metal 1
mask2 = '    -----------            ';   % SiO2 beam
mask3 = '  ---------------          ';
mask4 = '                       --- ';  % SiO2
mask5 = '                      ---  ';	% metal 2

deposit ('Si', 10);
deposit('SiO2', 20);
deposit('SiNi', 5);

% electrode
deposit('metal', 5); % metal 1 thick 
deposit('PR', 10);
liga(mask1);
etch ('metal');
removepr('PR');
drawlayers();

% beams
deposit('SiO2', 5);
deposit('PR', 10);
liga(mask2);
etch('SiO2');
removepr('PR');
drawlayers();


deposit('PoSi', 10);
deposit('PR', 10);
liga(mask3);
etch('PoSi');
removepr('PR');
drawlayers();
etch('SiO2');

% electrode
deposit('metal', 2); % metal 2 thin 
deposit('PR', 10);
liga(mask4);
etch ('metal');
removepr('PR');
drawlayers();
%**********************************************

%=================donot modify below===================
axis ([15 80 0 Layerprofile.currentY])
