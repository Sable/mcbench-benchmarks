function [status,varargout] = spellcheck(text)

%SPELLCHECK checks the spelling of word(s) and returns suggestions if misspelled.
%
% [status,suggestions] = spellcheck(text);
% status = spellcheck(text);
%
%     text:         a word or string of words separated by space(s).
%     status:       returns '1' if words exist in dictionary or '0' otherwise.
%     suggestions:  an array of suggested corrections of the misspelled word
%                   or otherwise returns a message 'Correct Spelling'.
%
% Examples:
%      [status,suggestions] = spellcheck('Hellow');
%      [status,suggestions] = spellcheck('My Name is Fahad!');
%      status = spellcheck('Emirates');
%
%   Copyright 2004 Fahad Al Mahmood
%   Version: 1.0 $  $Date: 30-Jun-2004
%   Version: 1.5 $  $Date: 01-Jul-2004 (Multiple words check & status,
%                                       thanks Michael Kleder!)
%   Version: 1.6 $  $Date: 11-Jul-2004 (Fixed the 'no suggestions' result,
%                                       thanks Sander Stepanov!)


% Separating string of words into arrays of words.
k=1;
temp='';
for n=1:length(text);
    if ~isspace(text(n))
        temp = [temp text(n)];
    else
        if ~isspace(text(n-1))
            words{k} = temp;
        end
        temp='';
        k=k+1;
    end
end
words{k} = temp;

% Opening MS Word and Starting the Spelling Check

Doc = actxserver('Word.Application');
m=1;
for n=1:length(words)
    if ~isempty(words{n})
        status(m) = invoke(Doc,'CheckSpelling',words{n},[],1,1);
        if nargout==2
            invoke(Doc.Documents,'Add');
            X = invoke(Doc,'GetSpellingSuggestions',words{n});
            count = get(X,'Count');
            suggestions{m,1} = words{n};
            if count~=0
                for k=2:count+1
                    suggestion = invoke(X,'Item',k-1);
                    suggestions{m,k} = get(suggestion,'Name');
                end
            elseif count==0 & status(m)==1
                suggestions{m,2} = 'Correct Spelling';
            elseif count==0 & status(m)==0
                suggestions{m,2} = 'No Suggestions!';
            end
            varargout = {suggestions};
        end
        m=m+1;
    end
end

status = all(status);

invoke(Doc,'Quit');
delete(Doc);