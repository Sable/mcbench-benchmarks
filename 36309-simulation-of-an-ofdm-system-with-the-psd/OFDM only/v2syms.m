function [numberOfSymbols numberOfZeros symbols]=v2syms(data,N)
%% v2syms : Vector of size (1,L) to Symbols (nRows,N)
% [numberOfSymbols numberOfZeros symbols]=v2syms(data,N)
%% INPUTS: data, and N; as follows
% where L = number of the elements in the vector [data]
% N is the required (input) number of elements in each symbol
%% Outputs: 
% numberOfSymbols: (nRows) is the resultant number of symbols (rows)
% numberOfZeros: (zeros) is the total number of the attached zeros to the
% last symbol
% symbols: is the resultant symbols of (numberOfSymbols,N)
s=length(data);
r=rem(s,N);
if r==0
    row=floor(s/N);
    numberOfZeros=0;
else
    row=floor(s/N)+1;
    numberOfZeros=N-r;
end
nData=[data zeros(1,numberOfZeros)];
l=length(nData);
numberOfSymbols=row;
symbols=reshape(nData,N,row);