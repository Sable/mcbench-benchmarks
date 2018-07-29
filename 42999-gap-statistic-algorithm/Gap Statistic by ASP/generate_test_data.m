function test_data = generate_test_data(data)

% -----------------------------------------------------------------------
%   FUNCTION
%   Generate Test Data (generate_test_data.m)
%
%   DESCRIPTION
%   This function is called in gap_statistics.m and it generates a
%   reference dataset with maximum entropy (i.e., sampled uniformly
%   from the original dataset's bounding rectangle).
%
%   AUTHOR
%   Alessandro Scoccia Pappagallo, 2013
%   Under the supervision of Ryota Kanai
%   University of Sussex, Psychology Dep.
% -----------------------------------------------------------------------

%% Feel free to change these parameters if the operation takes too long

leap_r = 1;
leap_c = 1;

%% A test dataset is generated


test_data = data;
size_data = size(data);

for id_row = 1:leap_r:size_data(1)
    for id_col = 1:leap_c:size_data(2)
        minimum = min(data(:,id_col));
        maximum = max(data(:,id_col)- minimum);
        test_data(id_row, id_col) = minimum + (rand*maximum);
    end  
end
