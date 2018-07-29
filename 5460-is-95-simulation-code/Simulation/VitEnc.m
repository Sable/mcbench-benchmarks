function y = VitEnc(G, x);

%
% VitEnc			Viterbi Encoder function - performs Viterbi Encoder according to 
%					genration polynom
%
% 						Inputs: x - input data (binary form)
%  							  G = [g1; g2; ...; gN] - matrix of generation polynomials
%                         Walsh - Used row of Walsh matrix
% 						Outputs: y - Viterbi Encoding sequence

K = size(G, 1);
L = length(x);

yy = conv2(G, x');
yy = yy(:, 1:L);
y = reshape(yy,K*L, 1);

y = mod(y, 2);
