function speak(varargin)

%SPEAK using Excel to speak entered texts or numbers
%
% speak(text)
%
% Examples:
%
%   speak('Hello');
%   speak('How are you doing my friend?');
%   speak('speak('I can count!',1,2,3,4,'I am smart!');

%   Copyright 2004 Fahad Al Mahmood
%   Version: 1.0 $  $Date: 15-Apr-2004
%   Version: 1.1 $  $Date: 19-May-2004  % Modified to speed the speech
%                                         process for multiple input arguments



% Opening Excel
try Excel = actxserver('Excel.Application');
catch error('Excel could not be accessed!'); end

text='';
for n=1:nargin
    if ischar(varargin{n})
        text = [text ' ' varargin{n}];
    else
        text = [text ' ' num2str(varargin{n})];
    end
end

% Convert Number to String
if isnumeric(text)
    text = num2str(text);
end

% Speaking
try invoke(Excel.Speech,'Speak',text);
catch 
    if ~exist('text','var')
        error('You did not enter anything for me to say!');
    end
    invoke(Excel,'Quit');
    delete(Excel);
    error('Excel does not have Speech Tool!'); 
end

invoke(Excel,'Quit');
delete(Excel);