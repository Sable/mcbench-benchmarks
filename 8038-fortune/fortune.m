%   This is a Matlab implementation of the program 'fortune' commonly found on
%   *nix type systems, that prints out random, sometimes funny/insightful
%   bits of wisdom at the terminal.  
%   All fortunes were collected from the original fortune program available
%   in *nix, as well as various other mod's available on the web (including
%   Calvin & Hobbes, Star Wars, Simpsons, and others), I did not collect
%   them and type them up, so if you have a problem with them do not blame
%   me. I'm also not too sure how legal collecting some of these is,
%   however all were available for download at various sites on the web for
%   use with the original fortune program.
%
%   Usage:
% 
%   fortune - prints a clean random fortune.
% 
%   fortune(typ,regex,num) - where typ is the string 'clean' or 'off', and
%   regex is a string expression defining the category of fortune to print.
% 
%       This prints the specified number of clean ('clean') or offensive 
%   ('off') fortune in the category of regex.  num can be an integer or 
%   'all', if an integer will print the first (num) fortunes in that 
%   category, if 'all' then it will print them all, and some have a lot.
% 
%   Be forewarned, if you don't want an offensive fortune then don't ask 
%   for it, some are bound to offend somebody.  These have been scrambled 
%   to make it difficult to offend someone by opening the mat file they are
%   contained in, if you are really worried then just delete the mat file.
%   If you don't want a particular set of fortunes, then just delete that 
%   variable from the mat file.
% 
%   I hope that you enjoy these as much as I do.
%
%   Robert M Flight, 2005

function fortune(typ,regex,num)

% Initialize random number generator, this way should get something
% approaching a truly random number
rand('state',sum(100*clock));
str = {};
% Just calling the function gives a random, clean fortune.
if nargin == 0
    cmp1 = 0;   % Dont need to check for offensive string
    regex = [];
    num = 0;
elseif nargin == 1
    cmp1 = strcmp(typ,'off');
    regex = [];
    num = 0;
elseif nargin == 2
    cmp1 = strcmp(typ,'off');
    num = 0;
elseif nargin == 3
    cmp1 = strcmp(typ,'off');
end

if cmp1 == 1;
    filnam = ('offensive_fortunes.mat');
else
    filnam = ('clean_fortunes.mat');
end
load(filnam);
vars = who('-file',filnam); % Get the list of possible choices
rnums = rand(1,2); % Generate random numbers to select category and fortune
numvars = length(vars);
rnum1 = ceil(rnums(1) * (numvars - 1)); %first one selects category

if length(regex) == 0
    workvar = vars{rnum1}; % Only do this if category was not specified by user
else
    ishere = exist(regex,'var'); % check that the variable exists
    if ishere == 0 | ishere ~= 1
        error('That variable doesn''t exist, try another.');
    else
        workvar = regex;
    end
end

expr1 = ['length(' workvar ')']; % Figure out number of fortunes in that category
iexpr = eval(expr1);
if num == 0
    if iexpr > 1
        rnum2 = ceil(rnums(2) * (iexpr - 1));
        expr2 = [workvar '{' num2str(rnum2) '}'];
    else
        expr2 = [workvar '{' num2str(iexpr) '}'];
    end
    numfort = 1;
else
    if length(num) == 1 % If it is an integer, get that number of fortunes
        numfort = num;
        if numfort >= iexpr   % make sure we dont go past the last line
            numfort = iexpr;
        end
    else
        numfort = iexpr; % Assume that if more than one number then it is a string
    end                  % and want all the fortunes in that category
end

if numfort > 1
    for i = 1:numfort
        rnum2 = i;
        expr2 = [workvar '{' num2str(rnum2) '}'];
        str{i} = eval(expr2);
    end
else
    str{1} = eval(expr2);
end
       
for j = 1:numfort   % Print out the number of fortunes required

    txt = str{j};
        
    if cmp1 == 1
        for n = 1:length(txt)
            ch = double(txt(n));
            if ch >= 65 & ch <= 90
                if (ch > (double('Z') - 13))
                    ch = ch - 13;
                else
                    ch = ch + 13;
                end

            elseif ch >= 97 & ch <= 122
                if (ch > (double('z') - 13))
                    ch = ch - 13;
                else
                    ch = ch + 13;
                end
            else
                ch = ch;
            end
            txt(n) = char(ch);
        end
    end
    fprintf('%s\n\n',txt);
    
end