function [currL newLqij LQi] = minSum(Lci, prevL, Lqij, HT, Ms)
% Min-sum product algorithm LDPC decoder
%
%  Lci      : Received log-likelihood vector (column vector)
%  prevL    : Previous statistics matrix
%  Lqij     : Statistics matrix
%  HT       : LDPC-CC H transpose matrix
%  Ms       : Convolutional code memory
%
%  currL    : Current statistics matrix
%  newLqij  : Updated statistics matrix
%  LQi      : Final statistics vector (column vector)
%
% Bagawan S. Nugroho 2007

% Get the H transpose dimension
[M N] = size(HT);

% Save the current statistics value for next period decoding
currL = [Lqij(3:2*(Ms + 1), (Ms + 1) + 1:end) zeros(2*(Ms + 1) - 2, (Ms + 1))];

% Prior log-likelihood.
Lqij = [prevL; Lqij];

% Update the statistics
Lrji = zeros(M, N);

% Get the sign and magnitude of L(qij)   
alphaij = sign(Lqij);  
betaij = abs(Lqij);

% ------ Vertical step ------
for i = 1:N

   % Find non-zeros in the column
   c1 = find(HT(:, i));
   
   % Get the minimum of betaij
   for k = 1:length(c1)
         
      % Minimum of betaij\c1(k)
      minOfbetaij = realmax;
      for l = 1:length(c1)
         if l ~= k  
            if betaij(c1(l), i) < minOfbetaij
               minOfbetaij = betaij(c1(l), i);
            end
         end           
      end % for l
                 
      % Multiplication alphaij\c1(k) (use '*' since alphaij are -1/1s)
      prodOfalphaij = prod(alphaij(c1, i))*alphaij(c1(k), i); 
         
      % Update L(rji)
      Lrji(c1(k), i) = prodOfalphaij*minOfbetaij;
      
   end % for k
      
end % for i

% ----- Horizontal step -----

% Process the statistics within Ms + 1 period
for j = (2*(Ms + 1) - 1):(4*(Ms + 1) - 2)

   % Find non-zero in the row
   r1 = find(HT(j, :));
      
   for k = 1:length(r1)         
         
      % Update L(qij) by summation of L(rij)\r1(k)
      newLqij(j - (2*(Ms + 1) - 2), r1(k)) = Lci(j - (2*(Ms + 1) - 2))...
         + sum(Lrji(j, r1)) - Lrji(j, r1(k));
      
   end % for k
   
   % Final statistics for decision
   LQi(j - (2*(Ms + 1) - 2)) = Lci(j - (2*(Ms + 1) - 2)) + sum(Lrji(j, r1));
        
end % for j
