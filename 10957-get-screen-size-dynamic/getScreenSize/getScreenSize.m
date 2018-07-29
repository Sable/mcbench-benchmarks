function getScreenSize
% GETSCREENSIZE Same as get( 0, 'ScreenSize' ), but dynamic
% 
%  SZ = GETSCREENSIZE returns a 1x4 vector of doubles giving the size of
%  the display in pixels, in the same way as get( 0, 'ScreenSize' ),
%  except it reads the current settings rather than reading a static copy
%  made at MATLAB startup time.
%
%  GETSCREENSIZE uses a Win32 API call and therefore will only work on
%  Windows
%
%  <a href="matlab:doc rootobject_props">Root object properties</a>