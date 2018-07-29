% JPRINTSFUN Simulink S-function wrapper for JPRINTF.
% function JPRINTSFUN is used to create formatted text displays
% in Simulink.  Input variable u contains the data passed from
% Simulink.  Parameter io specifies which JPRINTF display to 
% send output to.  Parameter fmtstr is a cell array of format
% strings to apply during initialzation, update, and termination.
%
% See JPRINTF.M and DEMO.MDL for more information.

% Version 1.0.
% Mark W. Brown
% mwbrown@ieee.org

function [sys,x0] = jprintsfun(t,x,u,flag,io,fmtstr)

if flag == 0 %initialization
  x0 = 0;
  sys = [0 1 0 -1 0 1];
  jprintf(-io,fmtstr{1});
elseif flag == 3 %update
  jprintf(-io,fmtstr{2});
  jprintf(-io,fmtstr{3},u);
  jprintf(-io,fmtstr{4});
elseif flag == 9 %termination
  jprintf(-io,fmtstr{5});
  jprintf(-io,fmtstr{6},u);
  jprintf(-io,fmtstr{7});
end
