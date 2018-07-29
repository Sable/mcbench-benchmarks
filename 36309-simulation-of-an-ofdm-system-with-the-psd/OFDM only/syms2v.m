function data=syms2v(symbols,numberOfZeros)
%% syms2v : Symbols (nRows,N) to Vector of size (1,L)
% data=syms2v(symbols,numberOfZeros)
%% INPUTS: symbols, and numberOfZeros; as follows
% where L = number of the elements in the vector [data]
%% Outputs: 
% data: is the original vector without the originally attached zeros
[r c]=size(symbols);
d=reshape(symbols,1,r*c);
data=d(1:end-numberOfZeros);