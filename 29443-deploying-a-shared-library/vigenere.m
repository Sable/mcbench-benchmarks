function v = vigenere
% VIGENERE Return a Vigenere square in a 27x27 matrix. 
    
    % Square 27 on a side
    count = 27;
    % Map letters to numbers, A=1, B=2, ... SPACE=27
    alpha = 1:count;
    % Create a matrix with 27 shifted substitution alphabets
    %   1 2 3 4 5 ... 26 27
    %   2 3 4 5 6 ... 27  1
    %   3 4 5 6 7 ...  1  2
    % etc.
    v = arrayfun(@(n) circshift(alpha, [0, -n]), 0:count-1, ...
                 'UniformOutput', false);
    v = reshape([v{:}], count, count);  