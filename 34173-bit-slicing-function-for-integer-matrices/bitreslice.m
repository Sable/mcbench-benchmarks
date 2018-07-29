function E = bitreslice(A,b_old, b_new, echo_on)
% function E = bitreslice(A,b_old, b_new, echo_on)
% Author: Damon Bradley
% Purpose: A is an [M by N] matrix of integers. Implicit is each element's
% representaiton in binary, which is b_old bits wide. Matrix E is output
% which is an [M by L] matrix of integers, with the bits of A concatenated
% column-wise and re-split into b_new bit-wide elements. The number of bits
% per row, b_old*N must be evenly divisible by b_new to work.
% 
% Inputs:
% A         - An M by N matrix of unsigned integers
% b_old     - Number of bits to represent A, should be based on maximum value
% b_new     - New number of bits to slice each bit-concatenated row of A
% echo_on   - Choose 1 to display underlying bit representation. Don't specify otherwise

if nargin > 3,
    lookunderhood = true;
else
    lookunderhood = false;
end
[M N] = size(A);
TotalBitsPerRow = N*b_old;
L = TotalBitsPerRow/b_new;

%A = [3 4 7; 3 2 0; 10 5 5]
[MaxA pos] = max(A(:));
required_old_bits = ceil(log2(MaxA));
if b_old < required_old_bits,
    [i j] = ind2sub(size(A),pos);
    str = ['A(' num2str(i) ',' num2str(j) ')=' num2str(MaxA)]; 
    error(['D''oh! ' num2str(b_old) ...
        ' bits are not enough to represent largest element, (' str '), in the input matrix.' ])
end

if lookunderhood, 
    B = dec2binMx(A,b_old)
    C = cell2mat(B);
    D = mat2cell(C,ones(1,M), b_new*ones(1,L))
    E = bin2decMx(D);
else
    B = dec2binMx(A,b_old);
    C = cell2mat(B);
    D = mat2cell(C,ones(1,M), b_new*ones(1,L));
    E = bin2decMx(D);
end

end

function B = dec2binMx(A, bits)
% function y = dec2binMx(x, bits)
% Author: Damon Bradley
% Purpose: perform dec2bin but on matrices. If size(A) = [M N], then B is a
% cell array of string representations of the b-bit representation of the entries of A, sized [M N].

M = size(A,1);
Z = cellstr(dec2bin(A(:),bits));
B = reshape(Z,M,[]);

end

function B = bin2decMx(A)
% function B = bin2decMx(A, bits)
% Author: Damon Bradley
% Purpose: perform bin2dec on cell array obinary entries.

B = cellfun(@bin2dec2,A);

end

function dec = bin2dec2(binstring)
    bitvec = double(binstring) == 49;
    dec = polyval(bitvec, 2);
end