function [upperH lowerH nextOffsetV] = parityCheckMatrixHT(T, baseMatrix, offsetV)
% Create one period parity check matrix H transpose
%
%  T           : Convolutional code period 
%  baseMatrix  : Basic structure of HT (see text)
%  offsetV     : H transpose starting point
%
%  upperH      : Upper H transpose
%  lowerH      : Lower H transpose 
%  nextOffsetV : H transpose starting point for next period
%  
% Bagawan S. Nugroho 2007

% Convolutional code memory
Ms = T + 1;

% Create the base of H transpose matrix
[baseMatrix ones(T, 1) zeros(T) ones(T, 1)];
baseHT = reshape([baseMatrix'; ones(1, T); zeros(T); ones(1, T)], T + 2, 2*T)';

% Upper HT and lower HT      
upperH = zeros(2*(Ms + 1) - 2, 3*(Ms + 1) - 2);
lowerH = zeros(2*(Ms + 1), 3*(Ms + 1) - 2);
subLowerH = zeros(2*(Ms + 1) - 2, 4*(Ms + 1) - 2);

% Lower H
offsetH = 0;
for i = 1:2:(2*(Ms + 1))
      
   for j = 1:Ms + 1
      lowerH(i, j + Ms + offsetH) = baseHT(mod(i + offsetV, 2*T), j);
      lowerH(i + 1, j + Ms + offsetH) = baseHT(2, j);
   end
   offsetH = offsetH + 1;
   
end % for i

for i = 1:2:(2*(Ms + 1) - 2)
   
   offset = mod(2*(Ms + 1), 2*T);
   for j = 1:Ms + 1
      subLowerH(i, j + Ms + offsetH) = baseHT(mod(i + offset + offsetV, 2*T), j);
      subLowerH(i + 1, j + Ms + offsetH) = baseHT(2, j);
   end
   offsetH = offsetH + 1;
   
end % for i

% Upper H
offsetH = 0;
for i = (2*(Ms + 1) - 2) - 1:-2:1

   for j = 1:Ms + 1
      upperH(i, j + T + offsetH) = baseHT(mod(i + offsetV - 2, 2*T), j);
      upperH(i + 1, j + T + offsetH) = baseHT(2, j);
   end
   offsetH = offsetH - 1;
   
end % for i

% Adjust for final dimension 
upperH = upperH(:, (Ms + 1):end);
lowerH = [lowerH; subLowerH(:, 1:end - (Ms + 1))];
lowerH = lowerH(:, (Ms + 1):end);

% Vertical offset for next period
nextOffsetV = mod(offsetV + 2*(Ms + 1), 2*T); 
