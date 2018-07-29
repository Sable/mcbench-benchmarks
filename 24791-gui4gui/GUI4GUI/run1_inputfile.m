function varargout = run1_inputfile(varargin)
% function run1_inputfile(varargin)
% This inputfile is for type = 'run1'. You can have as many applications
% of the same template as you wish. For each app, you need to set up a
% separate set of data. In this example, there are two applications:
% 'Reaction time task' and 'Fixed duration task'
%

GID(1).guiName = 'Reaction_time_task_GUI'; % name of your GUI
GID(1).bgcolor = 'white';  % background color
GID(1).fontsize = 10;      % font size
GID(1).fontweight = 'bold';% font type: 'bold', 'normal'
GID(1).position = [0.1 0.1 0.6 0.6];  % [lower-left, lower-bottom, width, height] range (0,1)
GID(1).resize = 'off';  % whether window is resizable
GID(1).title = ['Lateral intraparietal area!(Eq. 28, p. 1370: Grossberg & Pilly (2008))']; 
GID(1).fn1 = 'After changing each parameter, press "Enter".';  % footnote 1
GID(1).fn2 = 'To see each parameter heuristic, please click on the PDF logo.';  % footnote 2
GID(1).run = 'RTtasknew(A9,g_f,g_h,lambda,sigLIP,Tdec)';  % what to do when "run" is pressed
   % I could do without the argument list as it can readily be derived 
   % from the string list. Good or bad ?
GID(1).string(1:6,1:4) = { '' };
% input parameter, default value, description, further reading material
GID(1).string(1,1:4) = { 'A9' '1' 'Parameter that ...' 'A9_heur.pdf' };
GID(1).string(2,1:4) = { 'g_f' '1' 'Gain of recurrent self-excitation ...' 'g_f_heur.pdf' };
GID(1).string(3,1:4) = { 'g_h' '5' 'Gain of recurrent inhibition ...' 'g_h_heur.pdf' };
GID(1).string(4,1:4) = { 'lambda' '5' 'Gain of bottom-up excitation ...' 'lambda_heur.pdf' };
GID(1).string(5,1:4) = { 'sigLIP' '5' 'Gain of recurrent ...' 'sigLIP_heur.pdf' };
GID(1).string(6,1:4) = { 'Tdec' '55' 'Threshold LIP ...' 'Tdec_heur.pdf' };


GID(2).guiName = 'Fixed_duration_task_GUI';
GID(2).bgcolor = 'white';
GID(2).fontsize = 10;
GID(2).fontweight = 'bold';
GID(2).position = [0.1 0.1 0.6 0.6];
GID(2).resize = 'off';
GID(2).title = ['Lateral intraparietal area!(Eq. 34, p. 1370: Grossberg & Pilly (2008))']; 
GID(2).fn1 = 'After changing each parameter, press "Enter".';
GID(2).fn2 = 'To see each parameter heuristic, please click on the PDF logo.';
GID(2).run = 'FDtasknew(A9,g_f,g_h,lambda,sigLIP,g_delay)';
GID(2).string(1:6,1:4) = { '' };
% input parameter, default value, description, further reading material
GID(2).string(1,1:4) = { 'A9' '4.5' 'Parameter that ...' 'A9_heur.pdf' };
GID(2).string(2,1:4) = { 'g_f' '2' 'Gain of recurrent self-excitation ...' 'g_f_heur.pdf' };
GID(2).string(3,1:4) = { 'g_h' '5' 'Gain of recurrent inhibition ...' 'g_h_heur.pdf' };
GID(2).string(4,1:4) = { 'lambda' '5' 'Gain of bottom-up excitation ...' 'lambda_heur.pdf' };
GID(2).string(5,1:4) = { 'sigLIP' '5' 'Gain of recurrent ...' 'sigLIP_heur.pdf' };
GID(2).string(6,1:4) = { 'g_delay' '9' 'Threshold LIP ...' 'g_delay_heur.pdf' };

varargout{1} = GID;

save run1_inputfile GID
