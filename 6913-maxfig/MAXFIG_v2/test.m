function test
%test function for maxfig
%designed for R14SP2
%(c) M.Moldovan@mfi.ku.dk
%press any key to advance

clc

%Standard 'Windows' maximize
delete(gcf); plot (0); title ('Standard Windows maximize; Press any key to continue')
maxfig (gcf, 'DESKTOP')
pause

%maximize ignoring Taskbar
delete(gcf); plot (0); title ('Maximize ignoring Taskbar; Press any key to continue')
maxfig (gcf, 'SCREEN')
pause

delete (gcf)
