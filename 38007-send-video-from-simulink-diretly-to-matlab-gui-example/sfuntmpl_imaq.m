function sfuntmpl_imaq(block)
%% This function is a Level-2 MATLAB S-Function that is used to send Image 
% data from Simulink and display it within a MATLAB GUI. It uses the
% Level-2 S-Function template supplied by MathWorks.
%
% Created by Roni Peer, 4-Sep-2012
  setup(block);

%endfunction

function setup(block)
  
  %% Register number of ports
  block.NumInputPorts  = 3; % If you want to disply a RGB video.
  block.NumOutputPorts = 0; % Only a 'sink'.
  
  %% Setup functional port properties
  block.SetPreCompInpPortInfoToDynamic;

  % Need three inputs for each color. Level-2 sfunctions can't receieve
  % signals greater than 2 dimensions, so have to split the input to 3
  % signals.... :-(
  block.InputPort(1).DatatypeID   = 3; %uint8
  block.InputPort(1).Complexity   = 'Real';
  block.InputPort(1).SamplingMode = 'Sample';
  block.InputPort(2).DatatypeID   = 3; %uint8
  block.InputPort(2).Complexity   = 'Real';
  block.InputPort(2).SamplingMode = 'Sample';
  block.InputPort(3).DatatypeID   = 3; %uint8
  block.InputPort(3).Complexity   = 'Real';
  block.InputPort(3).SamplingMode = 'Sample';
  
  
  %% Register dialog parameters
  block.NumDialogPrms = 0; % Not needed.

  %% Set the block simStateCompliance to none.
  % This will ensure that the handle store in dwork is not saved and restored
  block.SimStateCompliance = 'HasNoSimState';

  %% Register block methods
  block.RegBlockMethod('SetInputPortDimensions',  @SetInpPortDims);
  block.RegBlockMethod('Outputs',                 @Output);


function SetInpPortDims(block,idx,di) %#ok<INUSL>
  block.InputPort(1).Dimensions = di; % Get the dimension from the block.
  block.InputPort(2).Dimensions = di;
  block.InputPort(3).Dimensions = di;
%endfunction

  
function Output(block)
% This function plots the image directly to the GUI.
fig = simpleGUI_imaq; % Get handle to the GUI.
h = guihandles(fig);  
a = get(h.figure1,'Children'); % Needed to get to the axes..

% Concatenate the 3 images into one.
img = cat(3,...
    block.InputPort(1).Data,...
    block.InputPort(2).Data, ...
    block.InputPort(3).Data);

% Display Original Image:
axes(a(2))
imshow(img);
title('RGB Image');
axis off;
axes(a(1))
%Display image with Edges:
gr = rgb2gray(img);
bw = uint8(edge(gr,'canny')*255);
img = img+cat(3,bw/255,bw,bw/255);
imshow(img);
axis off;
title('Image with Edges');
% image(img);
