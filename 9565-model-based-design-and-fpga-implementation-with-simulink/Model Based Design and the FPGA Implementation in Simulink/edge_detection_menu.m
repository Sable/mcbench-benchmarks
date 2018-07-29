function example_sel2html(fn)
%Convert Dick Benson's example_sel text files to HTML documents

if nargin < 1
    fn = 'example_sel.txt';
end
f = textread(fn,'%s','delimiter','\n','whitespace','');

ln = [];
for n = 1:length(f)
    [st1,fn1,tk1] = regexp(f{n},'^([^\$]*)');
    [st2,fn2,tk2] = regexp(f{n},'\$(.*)$');
    % Blank line.  Also, ignore initialization lines (#)
    if isempty(tk1) | (strncmp(f{n},'#',1) & length(f{n})>1)
        ln(n).text = '';
        ln(n).code = '';
        ln(n).style = '';
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

s{1} = '<html><body>';
s{end+1} = '<title>Model Based Design and the Path to FPGAs</title>';
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
        s{end+1} = sprintf('<div class="%s"><a href="matlab:%s">%s</a></div>', ...
            ln(n).style,ln(n).code,ln(n).text);
    end
end
s{end+1} = '</body></html>';

web(['text://' s{:}]);
