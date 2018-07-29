function b =min_by_random_search_test_func2(v)
% Example function.
% This is the function to be minimized.
% In this example, N=10. (a ten-dimensional function)
% This function has a single minimum at (1,2,3,4,5,6,7,8,9,10)
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

x1 = v(1,:);
x2 = v(2,:);
x3 = v(3,:);
x4 = v(4,:);
x5 = v(5,:);
x6 = v(6,:);
x7 = v(7,:);
x8 = v(8,:);
x9 = v(9,:);
x10 = v(10,:);

b = (x1-1).^2 + (x2-2).^2 + (x3-3).^2 ...
    + (x4-4).^2 + (x5-5).^2 + (x6-6).^2 ...
    + (x7-7).^2  + (x8-8).^2 + (x9-9).^2 ...
    + (x10-10).^2;

end

