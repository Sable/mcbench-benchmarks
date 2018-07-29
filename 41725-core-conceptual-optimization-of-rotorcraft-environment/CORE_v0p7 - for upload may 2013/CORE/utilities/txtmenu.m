function k = txtmenu(HeaderPrompt,varargin)
%TXTMENU   Generate a numbered list text menu in the command window.
%   CHOICE = TXTMENU(PROMPT, DEFAULT, ITEM1, ITEM2, ..., ITEMn) where all
%   arguments are strings displays
%
%   ------- PROMPT -------
%  
%     [0]   DEFAULT
%      1    ITEM1
%      2    ITEM2
%      ...  ... 
%      n    ITEMn
%
%   Select a menu number: 
% 
%   and the user is prompted to select a menu number, which is returned as
%   CHOICE. No selection (i.e. hitting return key without an input) returns
%   0. TXTMENU will return ONLY zero or a positive integer for CHOICE.
%
%   CHOICE = TXTMENU(PROMPT, ITEMLIST) where ITEMLIST is a cell array of
%   the form {DEFAULT, ITEM1, ITEM2, ..., ITEMn} is also valid.
%
%   If DEFAULT is an empty matrix or string ([] or ''), the first line is
%   omitted and both 0 and no selection are illegal inputs and TXTMENU will
%   only return a positive integer.
% 
%   PROMPT may also be a cell array, where the first string is still the
%   header row and the second string in the cell array replaces the default
%   input line 'Select a menu number: '. If the PROMPT string or first
%   element of the PROMPT cell array is an empty matrix or string, the
%   entire header line is omitted. 
%
%   Input strings may use \n (linefeed), \t (tab), etc. Linefeed is useful
%   for visually separating groups of options. Use \\ to produce a
%   backslash character and %% to produce the percent character. Call
%   SPRINTF for an item for more elaborate formatting.
%
%   Example:
%     choice = txtmenu('Main menu',...
%       {'Return / up menu\n'
%        'Change project''s name\n\t\t\t-or-\n\t\tCreate new project\n'
%        'Load project data'
%        sprintf('Save project %0.4f \n',pi)
%        'Visualize and modify data'})
%
%   Author:   Sky Sartorius
%             sky.sartorius(at)gmail.com
%
%   See also MENU, SPRINTF, INPUT.

if nargin < 2 || isempty(varargin{1})
    disp('No menu items to choose from.')
    k=NaN;
    return;
elseif nargin==2 && iscell(varargin{1}),
  ArgsIn = varargin{1};
else
  ArgsIn = varargin;
end

if isempty(ArgsIn{1})
    usedefault = false;
else
    usedefault = true;
end

numItems = length(ArgsIn);

if numItems == 1 && usedefault == 0;
    disp('Incomplete item list')
    k=NaN;
    return
end

prompt = 'Select a menu number: ';
if iscell(HeaderPrompt)
    xHeader = HeaderPrompt{1};
    if length(HeaderPrompt) == 2;
        prompt = HeaderPrompt{2};
    end
else
    xHeader = HeaderPrompt;
end

while 1,
    disp(' ')
    if ~isempty(xHeader)
        disp(['------- ',sprintf(xHeader),' -------'])
    end
    disp(' ')

    if usedefault
%         disp( [ '  [0]   ' sprintf(ArgsIn{1}) ] )
        disp( [ '  (0)   ' sprintf(ArgsIn{1}) ] )
    end
    for n = 1 : numItems-1
        if n<10
            xgap = '   ';
        elseif n<100
            xgap = '  ';
        elseif n<1000
            xgap = ' ';
        else
            xgap = '';
        end
        disp( [ xgap int2str(n) '    ' sprintf(ArgsIn{n+1}) ] )
    end
    disp(' ')
    k = input(sprintf(prompt));

    if isempty(k) || k == 0
        if usedefault
            k = 0;
        else
            k = -1;
        end
    end
        
    if  (k < 0) || (k > numItems-1) ...
        || ~strcmp(class(k),'double') ...
        || ~isreal(k) || (isnan(k)) || isinf(k) ...
        || k ~= round(k)
        disp(' ')
        disp('Selection out of range. Try again.')
        disp(' ')
    else
        disp (' ')
        disp (' ')
        return
    end
end

% Revision history:
%   V1.0    24 July 2010
%   V2.0    26 July 2010
%       Allowed for the use of \n, \t, etc. in input strings
%       Put prompt as first active line so it can be easily changed, but
%       decided not to have it be a second input for reasons of
%       compatibility with previous versions as well as MENU, and also
%       because of complicating use.
%   V3.0    4 August 2010
%       Moved default option to beginning of list. The numerical sequence
%       is maintained this way, and since the default value will often be
%       known very early in development, it saves more changing of
%       following code.
%       Allow empty header and omission of header line
%   V3.1    15 February 2011
%       You can now control the input prompt by using a 2 cell array for
%       the first input