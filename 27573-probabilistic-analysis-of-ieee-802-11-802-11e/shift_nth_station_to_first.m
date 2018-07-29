function matrix_new = shift_nth_station_to_first(matrix,n)

% The function moves the station from position 'n' to the first place
% (for further operations).
% It is realized by direct interchange of the first and 'n'-th row.

matrix_new = matrix; %copy

% interchange the rows
if n ~= 1
    matrix_new(1,:) = matrix(n,:);
    matrix_new(n,:) = matrix(1,:);
end