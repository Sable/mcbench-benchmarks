%Function to convert a gray coded sequence to a decimal sequence

function dec = gc2dec(gra)

% Description: This function converts a gray coded string to its equivalent
% decimal representation.
%
% Call Syntax: [output_variables] = function_name(input_variables)
%
% Input Arguments:
%	Name: gra
%	Type: matrix
%	Description: each row represents a gray coded string


% Output Arguments:
%	Name: dec
%	Type: vector
%	Description: decimal numbers in column vector form of size, size(gra,1) x 1 
%
% Creation Date: 08/07/2005
% Author : Arjun Srinivasan Rangamani

%*************************************************************************

%------------------
% Check valid input
%------------------
if (nargin ~= 1)
   error('Error (gc2dec): must have only 1 input argument.');
end   


s1 = size(gra,1);%num of rows in input vector
s2 = size(gra,2);%num of columns in the input vector
dec = zeros(s1,1);%size of the o/p decimal number sequence
bin = char(zeros(1,s2));


%gray to binary conversion
for j1 = 1:1:s1 
    for j2 = s2:-1:2
        temp = mod(sum(gra(j1,1:j2-1)),2);
        if temp == 1
            bin(j2) = num2str(1 - gra(j1,j2));
        else
            bin(j2) = num2str(gra(j1,j2));
        end
    end    
    bin(1) = num2str(gra(j1,1));
    dec(j1,1) = bin2dec(bin);
end


