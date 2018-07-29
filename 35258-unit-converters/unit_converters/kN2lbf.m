function [lbf] = kN2lbf(kN)
% Convert force from kilonewtons to pounds-force. (Use of lbf is to clarify
% that this is not lbm)
% Chad Greene 2012
lbf = kN/(4.4482216152605/1000);