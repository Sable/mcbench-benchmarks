function tap_delay = tapped_delay_fcn(input)
% The Tapped Delay function delays its input by the specified number 
% of sample periods, and outputs all the delayed versions in a vector
% form. The output includes current input

% NOTE: To instruct Embedded MATLAB to compile an external function, 
% add the following compilation directive or pragma to the function code
%#eml

persistent u_d;
if isempty(u_d)
    u_d = fi(zeros(1,40), numerictype(input), fimath(input));
end


u_d = [u_d(2:40), input];

tap_delay = u_d;
