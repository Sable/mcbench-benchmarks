% command_window_text() - Function for returning the text in the command window
% Formatted into a cell, per line of output (preceding >> can be removed).
% Also outputs raw string, and the handle to the object if desired.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: [output_cell output_string handle]=command_window_text(strip_angle_brackets)
%
% Inputs:
% strip_angle_brackets: can be left out. If nonzero, strips the '>> ' from the start of lines
%
% Outputs:
% output_cell: the text in the command window parsed to lines (blank lines removed) 
% output_string: the raw string taken from the window
% handle: container for handle; handle(1) is the handle we need (should only be one unless something weird is going on)
%
% Requires findjobj.m, available at:
% http://www.mathworks.com/matlabcentral/fileexchange/14317-findjobj-find-java-handles-of-matlab-graphic-objects

function [output_cell output_string text_container]=command_window_text(varargin)
%[handle] = findjobj(0, 'nomenu', 'class','XCmdWndView');
[cmdWin]=com.mathworks.mde.cmdwin.CmdWin.getInstance;
cmdWin_comps=get(cmdWin,'Components');
subcomps=get(cmdWin_comps(1),'Components');
text_container=get(subcomps(1),'Components');
output_string=get(text_container(1),'text');

output_cell=textscan(output_string,'%s','Delimiter','\r\n','MultipleDelimsAsOne',1);
output_cell=output_cell{1};
if nargin==1 && varargin{1}~=0 || nargin==0
    typed_commands=strncmp('>> ',output_cell,3);
    output_cell(typed_commands)=cellfun(@(t) t(4:end),output_cell(typed_commands),'UniformOutput',0);
end