%% subplotPPT _ Demo script
% Demonstrates different ways in which the function subplotPPT can work
%
% Copyright 2008, The MathWorks, Inc. MATLAB and Simulink are registered
% trademarks of The MathWorks, Inc. See www.mathworks.com/trademarks for a 
% list of additional trademarks. Other product or brand names may be 
% trademarks or registered trademarks of their respective holders.


%% Individual usage
% Here we plot successive windows to the third  slide in a  presentation

close all
clear
h(1) = figure;
peaks;
h(2) = figure;
membrane;
h(3) = figure;
spy;
h(4) = figure;
image;

for ii = 1:numel(h)
    subplotPPT(2,2,ii,h(ii),[pwd,filesep,'test.ppt'],1);
end


%% Call together
% Instead of calling the function in a for loop we can group the figures
% and call the function once
close all
clear
h(1) = figure;
peaks;
h(2) = figure;
membrane;
h(3) = figure;
spy;
h(4) = figure;
image;

subplotPPT(2,2,[4:-1:1],h,[pwd,filesep,'test.ppt'],[]);


%% Try merging plots (Similar to subplot)
close all
clear
h(1) = figure;
peaks;
h(2) = figure;
membrane;
h(3) = figure;
spy;
h(4) = figure;
image;
h(5) = figure;
tori4;

subplotPPT(3,3,[1 4; 2 3; 5 5; 6 9; 7 8],h,[pwd,filesep,'test.ppt'],3,...
    'region',[.1 .1 .8 .8],'hgap',10,'vgap',10);

%% Try different way of specifying region
close all
clear
h(1) = figure;
peaks;
h(2) = figure;
membrane;
h(3) = figure;
spy;
h(4) = figure;
image;
h(5) = figure;
tori4;

subplotPPT(3,3,[1 4; 2 3; 5 5; 6 9; 7 8],h,[pwd,filesep,'TestImage.gif'],4,...
    'region',[200 100 500 340],'hgap',10,'vgap',10,'units','pixels');

%% Create image files
% rather than save to clipboard now create image files in a separate
% directory akin to the puiblish command

subplotPPT(3,3,[1 4; 2 3; 5 5; 6 9; 7 8],h,[pwd,filesep,'test.ppt'],7,...
    'region',[200 100 500 340],'hgap',.1,'vgap',.1,'gapunits','norm','units','pixels',...
    'ImageFormat','emf');

%% Create image files
% rather than save to clipboard now create image files in a separate
% directory akin to the puiblish command
close all
clear
h(1) = figure;
peaks;
h(2) = figure;
membrane;
h(3) = figure;
spy;
h(4) = figure;
image;
h(5) = figure;
tori4;
%%
subplotPPT(3,3,[1 4; 2 3; 5 5; 6 9; 7 8],h,[],5,...
    'region',[200 100 500 340],'hgap',.1,'vgap',.1,'gapunits','norm','units','pixels',...
    'ImageFormat','emf');

%% Create image files
% rather than save to clipboard now create image files in a separate
% directory akin to the puiblish command
close all
clear
h(1) = figure;
peaks;
h(2) = figure;
membrane;
h(3) = figure;
spy;
h(4) = figure;
image;
h(5) = figure;
tori4;

ext = {'.ppt','.bmp','.emf','.gif','.jpg','.png','.tif'};
Idx = 3;

subplotPPT(3,3,[1 4; 2 3; 5 5; 6 9; 7 8],h,['test',ext{Idx}],3,...
    'region',[200 100 500 340],'hgap',.1,'vgap',.1,'gapunits','norm','units','pixels',...
    'ImageFormat','emf');