function results = wordcount(filename, num)

% NAME: Wordcount (Written on Apr 8, 2008)
%
% AUTHOR: Suri Like ( surilike@gmail.com )
%
% PURPOSE:
% This function reads the alphanumeric words (e.g. Finance, recycle, M16)
% from a plain text document (.txt) and displays the most frequently
% used words in the document. For example, after processing a document
% containing pizza recipes, I got the following output from this function:
% 
%     'WORD'      'FREQ'    'REL. FREQ'
%     'dough'     [ 170]    '1.1336%'  
%     'flour'     [  84]    '0.5601%'  
%     'oven'      [  70]    '0.4668%'  
%     'pizza'     [  49]    '0.3268%'  
%     'sauce'     [  47]    '0.3134%'  
%     'cheese'    [  39]    '0.2601%'  
%
% The first column consists of the most frequently used words in this
% document. The second column consists of the frequency of the word (i.e. 
% the number of times that word appeared in the document). The last column
% contains the relative frequency of the word, which is simply the
% frequency of the word divided by the total number of words in the
% document. This function might be useful for statistical purposes such as
% studying the writing habits of a particular author. Please note that the
% words are case-sensitive, which means 'Great' and 'great' are treated as
% two different words.
%
% INPUTS:
% The first input, 'filename', is simply the name of the text file.
% The second input, 'num', is the number of words you want to have the
% function display. For example, if you only want to see the top 10 most
% frequenly used words, simply set 'num' to 10. However, please note that
% this function only displays the words which were used at least twice.
% Therefore, if the number of words used more than once is less than the
% value of 'num', only those words will be displayed and you will see less
% words in the output than you specified.
% 
% OUTPUT:
% The output, 'results', simply shows a table that looks like the output in
% the pizza recipe example described above.
%
% HOW TO USE:
% Say you want to find out the most frequenly used words in a article you
% found on the web. Simply copy that article and paste it into Notepad.
% Save the text file with whatever name you want (e.g. 'article.txt'). Then
% navigate to the directory containing the text file in Matlab and type:
% results = wordcount('article.txt', 10)
% to see the top 10 most frequently used words in article.txt.

%% First import the words from the text file into a cell array
fid = fopen(filename);

words = textscan(fid, '%s');

%% Get rid of all the characters that are not letters or numbers
for i=1:numel(words{1,1})
    ind = find(isstrprop(words{1,1}{i,1}, 'alphanum') == 0);
    words{1,1}{i,1}(ind)=[];
end

%% Remove entries in words that have zero characters
for i = 1:numel(words{1,1})
    if size(words{1,1}{i,1}, 2) == 0
        words{1,1}{i,1} = ' ';
    end
end

%% Now count the number of times each word appears
unique_words = unique(words{1,1});

freq = zeros(numel(unique_words), 1);

for i = 1:numel(unique_words)
    if max(unique_words{i} ~= ' ')
        for j = 1:numel(words{1,1})
            if strcmp(words{1,1}(j), unique_words{i})
                freq(i) = freq(i) + 1;
            end
        end
    end
end

%% Finally, print out the results

u_freq = unique(freq);

sorted_freq = sort(u_freq, 'descend');

results={ 'WORD' 'FREQ' 'REL. FREQ' };

for i = 1:min(numel(find(sorted_freq > 1)), num)
    ind = find(freq == sorted_freq(i));
    results{i+1, 1} = unique_words{ind};
    results{i+1, 2} = unique(freq(ind));
    results{i+1, 3} = sprintf('%.4f%s', unique(freq(ind)/numel(words{1,1}))*100, '%');
end

sprintf('*NOTE: Only words that appeared more than once are displayed below\nTotal number of words in "%s" = %d\nTotal number of unique words = %d', filename, numel(words{1,1}), numel(find(freq)))

status = fclose(fid);