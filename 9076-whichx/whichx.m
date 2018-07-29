function varargout = whichx(inputstr)
%WHICHX   file search within matlab search path using wildcards
%   For example, WHICHX *.m lists all the M-files in the matlab search paths.
%
%   D = WHICHX('*.m') returns the results in an M-by-1
%   structure with the fields: 
%       name  -- filename
%       date  -- modification date
%       bytes -- number of bytes allocated to the file
%       isdir -- 1 if name is a directory and 0 if not%
%       path  -- directory
%
%   See also  WHICH, DIR, MATLABPATH.

% Autor: Elmar Tarajan [MCommander@gmx.de]
% Version: 2.2
% Date: 2006/01/12 09:10:05

if nargin == 0
   help('whichx')
   return
end% if
%
if ispc
   tmp = eval(['{''' strrep(matlabpath,';',''',''') '''}']);
elseif isunix
   tmp = eval(['{''' strrep(matlabpath,':',''',''') '''}']);
else
   error('plattform doesn''t supported')
end% if
%
if ~any(strcmpi(tmp,cd))
   tmp = [tmp {cd}];
end% if
%
output = [];
for i=tmp
   tmp = dir(fullfile(char(i),inputstr));
   if ~isempty(tmp)
      for j=1:length(tmp)
         tmp(j).path = fullfile(char(i),tmp(j).name);
      end% for
      output = [output;tmp];
   end% if
end% for
%
if nargout==0
   if ~isempty(output)
      if usejava('jvm')
         out = [];
         h = [];
         for i=1:length(output)
            %
            if ~mod(i,200)
               if ishandle(h)
                  waitbar(i/length(output),h,sprintf('%.0f%%',(i*100)/length(output)))
               elseif isempty(h)
                  h = waitbar(i/length(output),'','Name',sprintf('Please wait... %d files are founded.',length(output)));
               else
                  return
               end% if
               drawnow
            end% if
            %
            [p f e] = fileparts(output(i).path);
            p = strrep([p filesep],[filesep filesep],filesep);
            e = strrep(['.' e],'..','.');
            fl = strrep(output(i).path,'''','''''');
            switch lower(e)
               case '.m'
                  out = [out sprintf('<a href="matlab: %s">run</a> <a href="matlab:cd(''%s'')">cd</a> %s<a href="matlab:edit(''%s'')">%s%s</a>\n', f, p, p, fl, f, e)];
               case {'.asv' '.cdr' '.rtw' '.tmf' '.tlc' '.c' '.h' '.ads' '.adb'}
                  out = [out sprintf('    <a href="matlab:cd(''%s'')">cd</a> %s<a href="matlab:open(''%s'')">%s%s</a>\n', p, p, fl, f, e)];
               case '.mat'
                  out = [out sprintf('    <a href="matlab:cd(''%s'')">cd</a> %s<a href="matlab:load(''%s'');disp([''%s loaded''])">%s%s</a>\n', p, p, fl, fl, f, e)];
               case '.fig'
                  out = [out sprintf('    <a href="matlab:cd(''%s'')">cd</a> %s<a href="matlab:guide(''%s'')">%s%s</a>\n', p, p, fl, f, e)];
               case '.p'
                  out = [out sprintf('<a href="matlab: %s">run</a> <a href="matlab:cd(''%s'')">cd</a> %s\n', f, p, fl)];
               case '.mdl'
                  out = [out sprintf('    <a href="matlab:cd(''%s'')">cd</a> %s<a href="matlab:open(''%s'')">%s%s</a>\n', p, p, fl, f, e)];
               otherwise
                  if output(i).isdir
                     out = [out sprintf('    <a href="matlab:cd(''%s'')">cd</a> %s\n', [p f], output(i).path)];
                  else
                     out = [out sprintf('    <a href="matlab:cd(''%s'')">cd</a> %s<a href="matlab:try;winopen(''%s'');catch;disp(lasterr);end">%s%s</a>\n', p, p, fl, f, e)];                   
                  end% if
            end% switch
         end% for
         close(h)
         disp(char(out));
      else
         disp(char(output.path));
      end% if
   else
      disp(['''' inputstr '''' ' not found.'])
   end% if
else
   varargout{1} = output;
end% if