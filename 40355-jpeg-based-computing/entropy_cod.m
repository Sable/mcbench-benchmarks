function [ entropy_out ] = entropy_cod( input_matrix, n)
% compute entropy codes using zigzag ordering
y = fliplr(input_matrix);
s = size(input_matrix,1);
entropy_out(1) = diag(y,s-1);
for i=s-2:-1:-(s-1) % for each diagonal
    d = diag(y,i);
    d = reshape(d, 1, numel(d));
    if ( mod(i,2) == 1)
       d = fliplr(d);  % flip odd diagonals
    end
    entropy_out = cat(2, entropy_out, d);
end
% we need to have size of the out same as the input matrix to use blockproc
% out = out(1:find(out,1,'last')); % uncomment if figure out how to simply use
% blockproc for any output size
entropy_out = reshape(entropy_out, n, n); % reshape to fit input size
end

