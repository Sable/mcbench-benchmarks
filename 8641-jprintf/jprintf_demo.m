% This is a demo of the JPRINTF function...

% Create a window with simple text:
jprintf(-1,'Hello World.\nWelcome to JPRINTF!\n');

% Create a second window with formatted numeric display:
X = [pi,exp(1),sqrt(2)];
jprintf(-2,'pi = %6.4f\n',X(1));
jprintf(-2,'e = %6.4f\n',X(2));
jprintf(-2,'square root of 2 = %6.4f\n',X(3));

% Add some more text to the first window:
jprintf(-1,'JPRINTF is really cool.  Try the pulldown menus!\n');
jprintf(-1,'With Matlab R14 (or later), JPRINTF supports drag & drop editing and hardcopy printing.\n');

% Use JPRINTF to print a string to the command window.
% (Note the sign change on the device specifier)
jprintf(1,'JPRINTF is really cool.  It even does FPRINTF functions to the command window or files!\n');
jprintf(1,'Try it in you Simulink models, too!\n')

% Get a handle to the first window:
h = jprintf(-1,'');

% Use the handle to modify the window characteristics:
jprintf(h,'fontname','Arial')
jprintf(h,'foreground',[0 0 1])
jprintf(h,'background','red')
jprintf(h,'size',[300,400])

