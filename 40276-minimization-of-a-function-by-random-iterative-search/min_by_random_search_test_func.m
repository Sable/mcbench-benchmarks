function b =min_by_random_search_test_func(v)
% Example function.
% This is the function to be minimized.
% In this example, N=2. (a two dimensional function)
% This function has multiple local minima.
% 
% Two input types are possible:
%
% single input: 
% the input, v, is a N*1 vector.
% the output, b, is a scalar.
%
% multiple inputs (M vectors):
% ine input, v, is a N*M matrix
% the output, b, is a 1*M vector

x = v(1,:);
y = v(2,:);
b = (x-1).*sin(x) + y.*sin(y+1);

end

