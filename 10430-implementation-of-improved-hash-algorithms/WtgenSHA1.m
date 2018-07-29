function output = WtgenSHA1(input)
%   Generate the matrix Wt
%

% Convert input to numbers (from char)
input_char = reshape(input,32,16)'; [u1,u2] = size(input_char);
for kk = 1:u1
    input_num(kk,:) = str2num(input_char(kk,:)')';
end

output = [input_num; zeros(64,32) ];

for tt = 17:80
   output(tt,:) = cls( xor(xor(xor(output(tt-3,:),output(tt-8,:)), output(tt-14,:)), output(tt-16,:)) ,1 ) ;
end


 %   error ('Must use L or R for Left or Right')