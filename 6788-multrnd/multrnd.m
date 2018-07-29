function [X,Y] = multrnd(n,p,m)
% MULTRND Multinomial random sequence of m simulations of k outcomes with p probabiltites 
%  in n trials.
%  Y = MULTRND(N,P,M) generates a random sequence of m simulations of k integers from a
%  multinomial distribution with n trials and k outcomes, where the probability for each
%  simulation is,
%                          n!    
%                 ----------------------  ×  p1^n1 × p2^n2 ×  . . .  × pk^nk .  
%                n1! × n2! ×  . . .  × nk!    
%
%  Then, a single sample {n1, n2,  . . .  , nk} have a multinomial joint distribution with
%  parameters n and p1, p2,  . . .  , pk. The parameter n is called the number of trials; 
%  the parameters p1, p2,  . . .  , pk are called the category probabilities; k is called
%  the number of categories. 
%
%  Syntax: function [X,Y] = multrnd(n,p,m) 
%      
%  Inputs:
%       n - number of trials.
%       p - vector of associated probabilities. 
%       m - number of simulations (default = 1).
%  Outputs:
%       X - multinomial random deviates (default).
%       Y - multinomial probabilities of the generated random deviates (optional).
%
%  Example. We are interested to get a multinomial random values of 4 outcomes with 
%  associated probabilities p=[0.1 0.06 .7 .14] with 2678 trials in 10 simulations.
%
%  Calling on Matlab the function: 
%             [X Y] = multrnd(n,p,m)
%
%  where n = 2678, p = [0.1 0.06 .7 .14] and m = 10
%
%  Answer is:
%
%  X =
%         271         152        1873         382
%         249         154        1890         385
%         266         172        1862         378
%         290         147        1882         359
%         247         153        1873         405
%         291         155        1842         390
%         268         141        1900         369
%         248         158        1899         373
%         267         181        1855         375
%         259         175        1884         360
%
%  Y =
%         0.1012    0.0568    0.6994    0.1426
%         0.0930    0.0575    0.7058    0.1438
%         0.0993    0.0642    0.6953    0.1412
%         0.1083    0.0549    0.7028    0.1341
%         0.0922    0.0571    0.6994    0.1512
%         0.1087    0.0579    0.6878    0.1456
%         0.1001    0.0527    0.7095    0.1378
%         0.0926    0.0590    0.7091    0.1393
%         0.0997    0.0676    0.6927    0.1400
%         0.0967    0.0653    0.7035    0.1344
%
%  Created by A. Trujillo-Ortiz, R. Hernandez-Walls and A. Castro-Perez
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.mx
%  Copyright (C) January 12, 2005.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A., R. Hernandez-Walls and A. Castro-Perez. (2005). multrnd:
%    Multinomial random sequence. A MATLAB file. [WWW document]. URL http://
%    www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=6788
%
%  References:
% 
%  Abramowitz, M. and Stegun,I. A. (1964), Handbook of Mathematical
%           Functions, Government Printing Office, 26.1.20. Available on
%           Internet at the URL address http://hcohl.shell42.com/as/frameindex.htm
%

if nargin < 3,
    if nargin == 2,
        m = 1;
    else
        error('You need to input at least two arguments.');
        return,
    end;
end;

if (length(n)~=1) | (fix(n) ~= n) | (n < 0),
   error('n must be a positive integer.');
   return,
end;

P = sum(p);
if P ~= 1,
    error('The sum of the input probabilities must be equal 1.')
    return,
end;
 
for i = 1:m
    o = ones(1,n);
    s = cumsum(p/P);
    r = rand(1,n);
    for j = 1:length(p);
        o = o + (r > s(j)); 
    end;
    for j = 1:length(p);
        X(i,j) = sum(o == j); 
    end;
end;

Y = X./n;
return,