function [ comp, dict ] = huffman_cod( input_matrix)
% function computing huffman codes
% input_matrix is a m, n matrix
% comp is huffman codes, dict is a dictionary (for encoding)
symbols = unique(input_matrix);
L = length(symbols);
m = size(input_matrix, 1);
n = size(input_matrix, 2);
symbols = reshape(symbols, 1, L);
if length(symbols) < 2
    comp = 0;
    dict = [0 1];
    return;
end
probs = histc(input_matrix(:),symbols)./(m*n);
s = round(sum(probs)); % round to prevent an inequation 1 ~= 1.0000
if (s ~= 1)
    input('error in prob_hist')
end
[dict, avglen] = huffmandict(symbols, probs);
comp = huffmanenco(input_matrix(:),dict);
end