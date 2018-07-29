function [stringTokens, numberOfTokens] = stringTokenizer( stringTarget, delimiter )
%STRINGTOKENIZER 
% stringTarget = ';;ab;cd de=0==';
% delimiter = '; =';

% regexpression
pattern = ['\w*[^' delimiter ']\w*'] ; 
[startIndices, endIndices] = regexp(stringTarget, pattern);

stringTokens = [];
index = 1;

for i = 1:length(startIndices)
    stringTokens = [stringTokens {stringTarget(startIndices(i):endIndices(i))}];
end

numberOfTokens = length(stringTokens);

end

