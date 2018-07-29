function googlesearch_test
%GOOGLESEARCH_TEST Tests for GOOGLESEARCH.

% Make a simple call.
s = googlesearch('matlab');
if ~isstruct(s)
    error('Did not return a structure.')
end
if ~isfield(s,'ResultElements')
    error('No field "ResultElements".')
end
resultElements = s.ResultElements;
if ~isstruct(resultElements)
    error('ResultElements is not a structure."')
end
if ~isequal(size(resultElements),[1 10])
    error('"ResultElements is not the right size.')
end
url = resultElements(5).URL;
if ~ischar(url) & ~isempty(url)
    error('URLs not returned properly.')
end

%% Make a fancier call.
s = googlesearch('matlab mathworks',90);
%%
if ~isequal(size(s.ResultElements),[1 90])
    error('"ResultElements is not the right size.')
end
if (s.StartIndex ~= 1)
    error('StartIndex is wrong.')
end
if (s.EndIndex ~= 90)
    error('EndIndex is wrong.')
end
title = s.ResultElements(72).Title;
if ~ischar(title) && ~isempty(title) 
    error('"Title" is wrong.')
end