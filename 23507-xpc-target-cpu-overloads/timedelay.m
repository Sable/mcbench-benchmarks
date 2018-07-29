function timedelay(block)
setup(block);

function setup(block)

% Register number of ports
block.NumInputPorts  = 0;
block.NumOutputPorts = 0;

% Register parameters
block.NumDialogPrms     = 1;

% Register sample times
%  [0 offset]            : Continuous sample time
%  [positive_num offset] : Discrete sample time
%
%  [-1, 0]               : Inherited sample time
%  [-2, 0]               : Variable sample time
block.SampleTimes = [-1 0];
block.SetAccelRunOnTLC(false);

block.RegBlockMethod('Outputs', @Outputs);     % Required
block.RegBlockMethod('Terminate', @Terminate); % Required
block.RegBlockMethod('WriteRTW', @WriteRTW);
%end setup

function Outputs(block) %#ok<INUSD>
%end Outputs

function Terminate(block) %#ok<INUSD>
%end Terminate

function WriteRTW(block)
block.WriteRTWParam('matrix', 'delay', block.DialogPrm(1).Data);
