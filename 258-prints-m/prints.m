function [] = prints(a,b)
%
%
%     Print Simulink model as EPS-file to the current working directory
%
%     Syntax: PRINTS('FILENAME','<OPTION>')
%
%     Filename must be given without extension, e.g. 'MyFile'.
%
%     Options: p = Portrait, l = Landscape
%     No option returns the default 'Portrait' paperorientation.
%
%     Written by Bjřrn R. Sřrensen (1997)
%     Narvik Institute of Technology
%     N-8505 Norway
%     E-mail: brs@hin.no
%
%     Tested on versions 5.0-5.3 of Matlab (simulink 3.0)
%
%
filename=[a];
if nargin==2
   if b=='p'
      % Set 'Paper orientation' 'Portrait'
      set_param(filename, 'PaperOrientation','Portrait');
   end;
   if b=='l'
      % Set 'Paper orientation' 'Landscape'
      set_param(filename, 'PaperOrientation','Landscape');
   end;
end;
if nargin==1
   set_param(filename, 'PaperOrientation','Portrait');
end;
eval(['print -deps -s ', filename]);
