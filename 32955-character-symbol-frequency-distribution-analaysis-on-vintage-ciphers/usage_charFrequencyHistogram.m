clear all;
clc;

inputFileFolder = 'inputFiles';
fileTarget = 'email.txt';
fileTarget = strcat(inputFileFolder, '\', fileTarget);

textContents = textread(fileTarget, '%s', 'whitespace', '');
textContents = char(textContents);
textContents = lower(textContents);

plotCharDistributionFreq( textContents, fileTarget );
title('Frequency distribution');
% textContentsWithoutWhitespaces = regexprep(textContents,'[^\w'']','');
% 
% charDistributionOfContentsWithoutWhitespaces = histc(textContentsWithoutWhitespaces, characters);
% charDistributionOfContentsWithoutWhitespacesPercent = charDistributionOfContentsWithoutWhitespaces/ sum(textContentsWithoutWhitespaces);
% plot(charDistributionOfContentsWithoutWhitespacesPercent, 'g');

fprintf('Content profiles\n');
fprintf('File title: %s\n', fileTarget);
fprintf('Total number of characters(including whitespaces): %d\n', sum(textContents));
% fprintf('Total number of characters(excluding whitespaces): %d\n', sum(textContentsWithoutWhitespaces));


%{
set(gca,'XTickLabel',{characters(1), characters(2), characters(3), characters(4), characters(5), ...
    characters(6), characters(7), characters(8), characters(9), characters(10), ...
    characters(11), characters(12), characters(13), characters(14), characters(15), ...
    characters(16), characters(17), characters(18), characters(19), characters(20), ...
    characters(21), characters(22), characters(23), characters(24), characters(25), ...
    characters(26)});
%}

%{
known limitation of demo:
??? Error using ==> dataread
Buffer overflow (bufsize = 4095) while reading string from
file (row 1, field 1). Use 'bufsize' option. See HELP TEXTREAD.
%}