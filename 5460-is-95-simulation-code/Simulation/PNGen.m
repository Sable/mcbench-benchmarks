function [y, Z] = PNGen(G, Zin, N);
%
% PN_GEN		This function generates the Pseudo Noise sequnece of length (N)
%				according to Generation Polynom and input state.
%
% 						Inputs: G - Generation Polynom
%                         Zin - Initial state of Shift register
%                         N - The length of PN sequence
%
% 						Outputs: y - The resulting PN sequence
%                          Z - The output state of Shift register
%

L = length(G);
Z = Zin;    % initialize input state of shift register

y = zeros(N, 1);
for i=1:N
   y(i) = Z(L);
   Z = xor(G*Z(L), Z);
   Z = [Z(L); Z(1:L-1)];
end   
%yy = filter(1, flipud(G), [1; zeros(N-1, 1)]);
%yy = mod(yy, 2);
