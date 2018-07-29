%% Copyright (c) 2013, The MathWorks, Inc.
function AtTargetFlag = updateTargetParams(XYPosAndTgt)

AtTargetFlag = single(1);
coder.extrinsic('num2str', 'evalin');
newval = num2str(XYPosAndTgt');
evalin('base',['set_param(''LEGOModel/xym'',''value'',''[ ' newval ' ]'');']);
% evalin('base','get_param(''LEGO_Robot_Algorithm/AtTargetFlag'',''RuntimeObject'');');
% AtTargetFlag = evalin('base','rto.OutputPort(1).Data');

end
