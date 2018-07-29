function string_maker(block)
% Level-2 MATLAB file S-Function for times two demo.
%   Copyright 1990-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $ 

  setup(block);
  
%endfunction

function setup(block)
  
  %% Register number of input and output ports
  block.NumDialogPrms  = 3;
  block.NumInputPorts  = 3;
  block.NumOutputPorts = 1;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
 
  block.InputPort(1).DirectFeedthrough = true;
  block.InputPort(1).DimensionsMode   = 'Fixed';
  block.InputPort(1).Dimensions       = 1;
  
  block.InputPort(2).DirectFeedthrough = true;
  block.InputPort(2).DimensionsMode   = 'Fixed';
  block.InputPort(2).Dimensions       = 1;
  
  block.InputPort(3).DirectFeedthrough = true;
  block.InputPort(3).DimensionsMode   = 'Fixed';
  block.InputPort(3).Dimensions       = 1;
  
  block.OutputPort(1).DimensionsMode   = 'Fixed';
  block.OutputPort(1).Dimensions       = 15;
  block.OutputPort(1).DatatypeID       = -1; 
  %% Set block sample time to inherited
  block.SampleTimes = [-1 0];
  
  %% Set the block simStateCompliance to default (i.e., same as a built-in block)
  block.SimStateCompliance = 'DefaultSimState';

  %% Run accelerator on TLC
  block.SetAccelRunOnTLC(true);
  
  %% Register methods
  block.RegBlockMethod('Outputs',                 @SetOutPortDims);
  block.RegBlockMethod('Outputs',                 @Output);  
  
  
%endfunction

function SetOutPortDims(block)   %% SetOutputPortDims - Check and set output port dimensions
    block.InputPort(1).Dimensions  = 1;
    block.InputPort(2).Dimensions  = 1;
    block.InputPort(3).Dimensions  = 1;
    
    block.OutputPort(1).Dimensions = 15;

%endfunction

  
  %% Output
function Output(block)
%out_temp = 'A0'; 
temp_str_1 = num2str(block.InputPort(1).Data);
temp_str_2 = num2str(block.InputPort(2).Data);
temp_str_3 = num2str(block.InputPort(3).Data);
%string1 = strcat(out_temp,temp_str);
  block.OutputPort(1).CurrentDimensions = 15;
  block.OutputPort(1).Data(1) = block.DialogPrm(1).Data;
  block.OutputPort(1).Data(2) = 48;
  block.OutputPort(1).Data(3) = temp_str_1(1);
  block.OutputPort(1).Data(4) = temp_str_1(2);
  block.OutputPort(1).Data(5) = temp_str_1(3);
   
  block.OutputPort(1).Data(6) = block.DialogPrm(2).Data;
  block.OutputPort(1).Data(7) = 48;
  block.OutputPort(1).Data(8) = temp_str_2(1);
  block.OutputPort(1).Data(9) = temp_str_2(2);
  block.OutputPort(1).Data(10) = temp_str_2(3);
  
  block.OutputPort(1).Data(11) = block.DialogPrm(3).Data;
  block.OutputPort(1).Data(12) = 48;
  block.OutputPort(1).Data(13) = temp_str_3(1);
  block.OutputPort(1).Data(14) = temp_str_3(2);
  block.OutputPort(1).Data(15) = temp_str_3(3);
  
  
%endfunction

