%   Uses a text file that contains the list of files to import.
%   Currently assumes that all files are formatted using the same format as
%   used for the Unix/Linux fortune program, each fortune is seperated by
%   a '%' character.

function fort_import(txtfil);

% Get the list of textfiles going to get everything from
filnams = textread(txtfil,'%s','delimiter','\n');
ifile = length(filnams);

for r = 1:ifile   % Do this for each file.
    fprintf('\nFile %d of %d',r,ifile);
    text = textread(filnams{r},'%s','delimiter','\n');  % get all the lines of the fortune
    delim = [];
    crap = [];

    % This part takes all the lines and finds the lines that contain the %
    % characters
    for n = 1:length(text); 
        line = text{n};
        dblchars = double(line);
        dblnew = [];
        if size(dblchars) ~= [0 0]
            crap(n) = dblchars(1);
        else
            crap(n) = 0;
        end
    end
    
    delim = find(crap == 37);   % figure out where the delimiters are
    
    start = 1;
    var = cell(1,(length(delim)));
    for k = 1:length(delim)
        str = [];
        stop = delim(k);
        if k == 1
            for j = 1:(stop - 1)
                str = [str char(10) text{j}];
            end
            start = stop + 1;
        else
            for j = start:(stop - 1)
                str = [str char(10) text{j}];
            end
            start = stop + 1;
        end
        var{k} = str;
    end
    assignin('base',filnams{r},var);
end
fprintf('\nAll Done.\n');