function x = rsc_encode(G,m,termination)
% Copyright 1998, Yufei Wu, MPRG lab, Virginia Tech. for academic use
% encodes a binary data block m (0/1) with a RSC (recursive systematic 
% convolutional) code defined by generator matrix G, returns the output 
% in x (0/1), terminates the trellis with all-0 state if termination>0
if nargin<3, termination = 0; end
[N,L] = size(G); % Number of output bits, Constraint length
M = L-1; % Dimension of the state
lu = length(m)+(termination>0)*M; % Length of the input
lm = lu-M; % Length of the message
state = zeros(1,M); % initialize the state vector
% To generate the codeword
x = [];
for i = 1:lu
   if termination<=0 | (termination>0 & i<=length(m))
     d_k = m(i);
    elseif termination>0 & i>lm
     d_k = rem(G(1,2:L)*state.',2); 
   end
   a_k = rem(G(1,:)*[d_k state].',2);
   xp = rem(G(2,:)*[a_k state].',2); % 2nd output (parity) bits
   state = [a_k state(1:M-1)]; % Next sttate
   x = [x [d_k; xp]]; % since systematic, first output is input bit
end