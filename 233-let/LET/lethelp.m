% =========================================================================
%                            LET Main Program
% =========================================================================
%
% In the window of main program, users can
%
% * press the "Start" button to start the calculation of Lyapunov exponents
%
% * press the "Stop" button to interrupt the calculation 
%
% * press the "Setting" button to enter or change parameters
%
% * press the "New plot" button to redraw the figure (the redrawn figure
%   does not contain any GUI components). Note: the figure may not be
%   printed correctly when there are GUI components.
%
% * press the "Exit" button to quit the program
%
% * press the "Help" button to see the help text
%
% * choose the "On" radio button to show grid lines on the figure,
%   select the "Off" radio button to delete the grid lines
%
% * enter x, y limits in "X-range" and "Y-range" edit boxes to specify
%   the plotting limits of the window.
%   Note that the limits must be in the following format:
%
%   (for X-range):  Xmin, Xmax       (for Y-range): Ymin, Ymax
%
%   where Xmin and Ymin are the minimum values, Xmax and Ymax are the
%   maximum values.
%
% * enter a value c in the "Draw line at" edit box to draw a line at
%   y = c. Users can also enter more than one values (e.g. -15, -4, 1, 5)
%   To delete the previous drawn line, enter "del".  To delete all drawn
%   lines, enter "del*".
%
%
% The calculated Lyapunov exponents are displayed at the bottom of the
% window.  They are sorted in descending order (from left to right).
% The number in the brackets is the Lyapunov dimension (or Kaplan-Yorke
% dimension).  If the Lyapunov dimension cannot be determined or is
% undefined for the system, a zero will be shown. This will occur when
%
% a) the system is one-dimensional (e.g. the Logistic map), or
% b) all Lyapunov exponents of the system are negative ( i.e the system
%    is non-chaotic).
%
% The "Current time" and " Final time" text boxes show the progress of
% the calculation while the "Time used" text box displays the total
% time used in the calculation. All the values are in seconds.
%
%
% See also: SETHELP, README
%

% by Steve W. K. SIU, July 5, 1998.

help lethelp
