function [total, details] = roll(str)
%ROLL is a dice roller
%
% SYNOPSIS: [total, details] = roll(str)
%
% INPUT str: Dice to be rolled. XdY, where X and Y are scalars, rolls X
%            fair Y-sided dice. Both X and Y are necessary. 
%            If str is empty or omitted, '1d20' is used as default.
%
%            ROLL replaces the dice expression(s) by the rolled result, and
%            then evaluates the string. This makes it possible to use any
%            function call as input to ROLL as long as the function name
%            does not contain the signature of a roll (i.e. a number
%            followed by the letter 'd' followed by a number). In practice,
%            if you use ROLL for games, you most likely need only + and -.
%            
%            There is one special function, XdYbZ, that takes the best Z
%            rolls out of the X attempts. This is useful to generate
%            character abilities in role-playing games.
%
%
% OUTPUT total: total of the roll
%			details: individual rolls (cell array with results for each
%                    dice in the input
%
% REMARKS (1) If no output is requested, results are printed to screen
%         (2) Thanks to John D'Errico for pointing out that it is possible
%             to use any function with roll (as long as it takes the
%             results of dice rolls as input)
%
% EXAMPLES    roll 2d6  rolls two 6-sided dice
%             roll 1d8+1d4-2 rolls a 8-sided dice, a 4-sided dice and subtracts
%                       2 from the result
%             roll 1d2  rolls a 2-sided dice (i.e. a coin flip)
%             roll log(2^1d6) takes the natural logarithm of 2 to the power of 
%                       the result of the roll of a 6-sided dice.
%             roll 1+1  throws an error, because there are no dice to roll.
%
% created with MATLAB ver.: 7.8.0.8205 (R2009a) Beta (Mac Intel 64-bit) on Mac OS X  Version: 10.6.2 Build: 10C540 
%
% created by: jonas
% DATE: 04-Dec-2009
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% test input and assign defaults
if nargin < 1 || isempty(str)
    str = '1d20';
end

% check whether we need an output
printResult = nargout == 0;


% parse input. First, remove all spaces...
str = regexprep(str,'\s','');

% ...then find all dice expressions
[match,startIdx,endIdx]=regexp(str,...
    '(?<quant>\d+)d(?<dice>\d+)b(?<best>\d+)|(?<quant>\d+)d(?<dice>\d+)',...
    'names','start','end');

% loop matches and roll dice. Then replace the dice expression with the
% numeric result
nMatches = length(match);
details = cell(nMatches,1);

if nMatches == 0
    error('no matching signature for dice found in ''%s''.%sroll expects expressions containing #d#, where # are integers',str,char(10))
end

% keep original str for printing and debugging
if printResult
    pStr = str;
end
eStr = sprintf('%s;',str);

for m = nMatches:-1:1 % count down to preserve startIdx,endIdx
    % convert to double
    currentMatch = structfun(@str2double,match(m));    
    details{m} = randi(currentMatch(2),currentMatch(1),1);
    % check whether we should pick n best
    if ~isnan(currentMatch(3)) && currentMatch(3) < currentMatch(1)
        details{m} = -sort(-details{m});
        details{m} = details{m}(1:currentMatch(3));
    end
    
    eStr = sprintf('%s(%i)%s',eStr(1:startIdx(m)-1),sum(details{m}),eStr(endIdx(m)+1:end));
    if printResult
        newStr = sprintf(repmat('%i+',1,currentMatch(1)),details{m});
        pStr = sprintf('%s(%s)%s',pStr(1:startIdx(m)-1),newStr(1:end-1),pStr(endIdx(m)+1:end));
    end
end

% evaluate the string to get the total rolled number
if printResult
    fprintf('%s :\n%s = %i\n',str,pStr,eval(eStr));
else
total = eval(eStr);
end



    
        
    