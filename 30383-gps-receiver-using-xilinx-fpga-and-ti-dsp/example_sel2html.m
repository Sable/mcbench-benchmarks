function example_sel2html(fn,new)
%Convert Dick Benson's example_sel text files to HTML documents
% EXAMPLE_SEL2HTML creates a web-based example selector, using
% example_sel.txt in the current directory.
%
% EXAMPLE_SEL2HTML filename uses specified file
%
% EXAMPLE_SEL2HTML filename -new opens in a new web pages.
% Application Notes:
%You can populate the list box with the contents of a text file
%This works one of two ways:
%  Have a file called example_sel.txt in the CURRENT DIRECTORY
%  Specify the file name (w/ .txt extension) as input:
%     example_sel('MyFile.txt');
%
% Adding links to documentation:
%   - Put the name of the documentation file following a % after the
%   command
% ex:          My Demo       $my_demo.m  %my_demoHelp.html
%
% Adding Initialization Commands:
%   - Insert initialization commands by starting a line with #
%   - This will be evaluated in base workspace.
% Example:    #addpath(genpath(pwd))
%
% A title is automatically culled from the first line of the file.

if nargin < 1
    fn = 'example_sel.txt';
end

if nargin<2
    new = 0;
else
    new = 1;
end;

f = textread(fn,'%s','delimiter','\n','whitespace','');
titlestring = f{1};     % Title is first line
ln = [];
for n = 1:length(f)
    [st1,fn1,tk1] = regexp(f{n},'^([^\$]*)');
    [st2,fn2,tk2] = regexp(f{n},'\$(.*)$');
    % Blank line.  Also, ignore initialization lines (#)
    if isempty(tk1) | (strncmp(f{n},'#',1) & length(f{n})>1)
        ln(n).text = '';
        ln(n).code = '';
        ln(n).style = '';
        ln(n).help = '';
    else
        ln(n).text = deblank(f{n}(tk1{1}(1):tk1{1}(2)));
        ln(n).text = strrep(ln(n).text,'>','&gt;');
        ln(n).text = strrep(ln(n).text,'<','&lt;');

        % Determine the indent depending on how many spaces there are
        [st,fn] = regexp(ln(n).text,'^([\s]*)');
        if isempty(fn)
            ln(n).style = 'level1';
        elseif fn<=4
            ln(n).style = 'level2"';
        else
            ln(n).style = 'level3"';
        end
        
        if ~isempty(tk2)
            ln(n).code = f{n}(tk2{1}(1):tk2{1}(2));

            % Look for help file name: specified with a % in executable
            % code
            [st3,fn3,tk3] = regexp(f{n},'%\w*');
            if ~isempty(st3)
                helpfile = deblank(f{n}(st3+1:end));
                

                URL = which(helpfile);
%                 if isempty(URL)
%                     ln(n).help = '';
%                 end;

                URL = ['file:///' URL];
                ln(n).help =  helpfile;
            else
                ln(n).help = '';
            end;
        else
            ln(n).code = '';
        end
        
    end
    
    %Look for initialization commands:  Line starts with #
    if strncmp(f{n},'#',1) & length(f{n})>1
        evalin('base',f{n}(2:end),'disp([''fail to execute string: '',f{n}(2:end)])');
        disp('Evaluating Initialization commands');
    end;

end

s{1} = '<html>';
s{end+1} = ['<title>' titlestring '</title>'];
s{end+1} = '<body>';
s{end+1} = '<head>';
s{end+1} = '<style>';
s{end+1} = '.level1 {font-family:verdana, arial, sans-serif;';
s{end+1} = '    font-weight:bold;';
s{end+1} = '    background:#EEE;';
s{end+1} = '    font-size:12pt;';
s{end+1} = '}';
s{end+1} = '.level2 {font-family:verdana, arial, sans-serif;';
s{end+1} = '    text-indent:1em;';
s{end+1} = '}';
s{end+1} = '.level3 {font-family:verdana, arial, sans-serif;';
s{end+1} = '    text-indent:2em;';
s{end+1} = '}';
s{end+1} = '</style>';
s{end+1} = '</head>';

for n = 1:length(ln)
    if isempty(ln(n).code)
        if isempty(ln(n).text)
            % No text, no code
            s{end+1} = '<br/>';
        else
            % Text, no code
            s{end+1} = sprintf('<div class="%s">%s</div>', ...
                ln(n).style,ln(n).text);
        end
    else
        % Text and code
        s{end+1} = sprintf('<div class="%s"><a href="matlab:%s">%s</a>', ...
            ln(n).style,ln(n).code,ln(n).text);
        
        % Help
        if ~isempty(ln(n).help)
            s{end+1} = sprintf('<font size=2>  <a href="matlab:web(''%s'',''-new'')">help</a> </font>', ...
                ln(n).help);
%             s{end+1} = sprintf('<a href="matlab:web(''%s'',''-new'')"> help</a>', ...
%                 ln(n).help);
        end;
        
        s{end+1} = '</div>';    % End section
    end
end
s{end+1} = '</body></html>';

if new
    web(['text://' s{:}],'-new');
else
    web(['text://' s{:}]);
end;

