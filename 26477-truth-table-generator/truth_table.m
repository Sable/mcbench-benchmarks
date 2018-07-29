function T = truth_table(N)
% Truth Table Generator
% Mustafa U. Torun (Jan, 2010)
% ugur.torun@gmail.com
%
% T = truth_table(N);
%
% Inputs:
% N: Number of bits;
%
% Outputs:
% T: Truth Table;
% 
% Example:
% T = truth_table(2)
% T =
%     0     0
%     0     1
%     1     0
%     1     1
L = 2^N;
T = zeros(L,N);
for i=1:N
   temp = [zeros(L/2^i,1); ones(L/2^i,1)];
   T(:,i) = repmat(temp,2^(i-1),1);
end