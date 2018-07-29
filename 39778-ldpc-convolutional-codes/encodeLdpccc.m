function v = encodeLdpccc(u, T, HT)
% Encode LDPC-CC 
%
%  u      : Bit sequence (0/1)
%  T      : Convolutional code period
%  HT     : Base of parity check matrix H transpose
%
%  v      : Encoded sequence (column vector)                   
%
% Bagawan S. Nugroho 2007

% Convolutional code memory
Ms = T + 1;

% Tail bits
u = [zeros(1, Ms + 1) u zeros(1, 2*(Ms + 1)) zeros(1, T)];

% Weight coeffs h1
for i = 1:T

   k = 1;
   for j = 0:-1:-T - 1
      indx = mod(j + i, T);
      if indx == 0
         indx = T;
      end % if
   
      h1(i, k) = HT(indx, k);
      k = k + 1;
   end % for j

end % for i   

% Convolutional code registers
reg1 = zeros(1, Ms + 1);
reg2 = zeros(1, Ms);

% Weight coeffs h2   
h2 = [zeros(T) ones(T, 1)];
      
% Convolutional code encoder
for i = 1:floor(length(u)/T)
   
   for j = 1:T
      
      % 1st shift register
      reg1 = [u((T)*(i - 1) + j) reg1(1, 1:end - 1)];
   
      % Get the feedback
      v2((T)*(i - 1) + j) = mod(sum(reg1.*h1( j, :)) + sum(reg2.*h2(j, :)), 2);
   
      % 2nd shift register
      reg2 = [v2((T)*(i - 1) + j) reg2(1, 1:end - 1)];
      
   end % for j
   
end % for i

u = u(1, 1:length(v2));

% Encoded sequence (column vector)
v = reshape([u; v2], 1, 2*length(u))';

% The length of v must be product of 2*(Ms + 1)
unusedBits = length(v) - floor(length(v)/(2*(Ms + 1)))*(2*(Ms + 1));
v = v(1:end - unusedBits, 1);