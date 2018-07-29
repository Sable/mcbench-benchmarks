function maxComplexity = getComplexity(filename)
%GETCOMPLEXITY  Calculate the maximum complexity in an M-file.
%   maxComplexity = getComplexity(filename)
%
%   "Complexity" refers to the McCabe complexity as returned by "mlint -cyc"
%   When there are multiple functions in a file, the maximum value is
%   returned.

msg = mlint('-cyc','-string',filename);
tk = regexp(msg,'McCabe complexity of [^\s]+ is (\d+)','tokens');
complexity = zeros(size(tk));
for j = 1:length(tk)
    complexity(j) = eval(tk{j}{1});
end
maxComplexity = max(complexity);
