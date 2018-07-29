% MYDISPLAY Simulink S-function wrapper for GPRINTF.
% function MYDISPLAY is used to create formatted text displays
% in Simulink.  Input variable u contains the data passed from
% Simulink.  Variable io is the S-function parameters which
% specify which GPRINTF display to send output to.
%
% See GPRINTF.M and EXAMPLE.MDL for more information.

% Version 1.0.
% Mark W. Brown
% mwbrown@ieee.org

function [sys,x0] = mydisplay(t,x,u,flag,io)

if flag == 0
  x0 = 0;
  num_inputs = 8;  % <--- EDIT ME!
  sys = [0 1 0 num_inputs 0 0];
elseif flag == 9
  % PUT YOUR GPRINTF COMMANDS HERE:
  gprintf(-io,'Gain = %5.2f (dB)\n',u(1));
  gprintf(-io,'Noise Figure = %5.2f (dB)\n',u(2));
  gprintf(-io,'Third-Order Intercept = %5.2f (dBm)\n',u(3));
  gprintf(-io,'Detection Bandwidth = %5.2f (MHz)\n',u(4));
  gprintf(-io,'1dB Compression Point = %5.2f (dBm)\n',u(5));
  gprintf(-io,'Detection Sensitivity = %5.2f (dBm)\n',u(6));
  gprintf(-io,'Single-Tone Dynamic Range = %5.2f (dB)\n',u(7));
  gprintf(-io,'Two-Tone Dynamic Range = %5.2f (dB)\n',u(8));
  gprintf(-io,'------------------------------\n');
else
end
