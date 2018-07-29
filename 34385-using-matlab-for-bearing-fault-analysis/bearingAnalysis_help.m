%% BEARING FAULT ANALYSIS
% This program demonstrates how you can analyze the operation of a bearing,
% and how faults can be found by means of Signal Processing.
%
% _Created by Roni Peer_, Last Revision: *December 30th, 2011*
%%

%% Why to use this program
% In order to fully leverage this program, I recommend reading some theory,
% as can be found on Wikipedia or other textbooks. This program takes a
% ball-bearing, simulates a fault in its inner or outer ring, and tries to
% show how you can view the fault, by means of finding the resonance
% frequencies.

%% Menus and Options
% There are several key options you can select with this program.
%% Bearing Fault type:
% On the right popup menu select between the *"Inner Ring"* or *"Outer
% Ring"*
% fault. An inner ring fault would generate a sinewave-like signal, an
% Outer ring fault would generate a pulsing signal.
%
%% Rotation Speed
% A slider of the Rotation Speed (in RPM), in which the bearing is
% operating. Input range is between 1 and 2000.
%
%% Analysis Type
% A pop-up menu to choose between 4 types of analysis: *Spectral Analysis,
% Kurtosis, Envelope, and Time/Frequency*. 
%
%% Kurtosis Option
% The Kurtosis option on the pop-up menu will generate 3 Kurtosis numbers
% (compatible with the 3 different resonances, of 120, 500, 1500
% [rad/sec]), which will be shown below. 
%
%% Filter for Envelope
% The 'Filter For Envelope' button enables a band pass filter over a preset
% bandwidth of the envelope. To set the bandwidth press the *'Filter For
% Envelope'* button.  set the first band limit by dragging the cursor on the
% graph. press "Enter", a 2nd cursor will appear, set it up to the 2nd
% limit of the desired bandwidth.  press "Enter" again to get the filtered signal.
%
%% Run Button
% The 'Run' button is needed to be pressed so that the changes we made will
% effect the calculations and graphs of the program. 
%
%% Plots and Axes
% You can view several different aspects of the bearing system at hand.
%
%% Top Left Graph
% This graph shows the input signal - the signal measured at the faulty
% bearing.
%
%% Top Right Graph
% This graph shows the BODE frequency-Magnitude plot of the system.
%
%% Central Graph
% This graph shows the system response.
%
%% Bottom Graph
% This graph shows the output of the selected analysis plot.
%