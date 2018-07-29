function [interleaved] = interleave(input, print)
%Simple linear interleaver, must be square input
a = sqrt(length(input));

%Make a square matrix
input_data = reshape(input, a, a);

if print
    input_data
end

output_data = input_data';

interleaved = reshape(output_data, 1, length(input));

if print
    output_data
end

