function y = MW1cdf(X,N)
%MW1CDF   Mann-Whitney's U cumulative distribution function. 
%Probability of obtaining a Mann-Whitney's U of two random variables with continuous
%cumulative distribution. This procedure is highly recommended for sample sizes
%nx & ny <=7. Although it gives an exact p-value, for greater sample sizes it will takes
%a longer run-time. Alternatively, it is recommended to use the MW2cdf function.
%(The variable x will be called stochastically smaller than y if f(a) > g(a) for every a).
%
%   Syntax: function y = MW1cdf(X,N) 
%      
%     Inputs:
%          X - Mann-Whitney's U statistic.
%          N - 2-element vector of sample sizes for the two samples []. 
% The input quantities should be scalars.
%     Outputs:
%          y - cumulative probability value associated to the given Mann-Whitney's statistic.
%
%    Example: From the random data of two independent samples we got the
%             Mann-Whitney's statistic U = 2. Sample sizes were n1 = 4,
%             n2 = 3. We are interested to get the associated cumulative 
%             probability value.
%
%                              U=2;N=[4,3];
%
%     Calling on Matlab the function: 
%             y = MW1cdf(U,N)
%
%       Answer is:
%
%                 0.1143    
%

%  Created by A. Trujillo-Ortiz and R. Hernandez-Walls
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.mx
%
%  May 16, 2003.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A. and R. Hernandez-Walls. (2003). MW1cdf: Mann-Whitney's U cumulative
%    distribution function: nx and ny <=7. A MATLAB file. [WWW document]. URL http://
%    www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=3493&objectType=FILE
%
%  References:
% 
%  Mann, H. B. and Whitney, D. R. (1947), On a test of whether one of two   
%           random variables is stochastically larger than the other. Annals
%           of Mathematical Statistics, 18: 50-60.
%

if nargin <  2,
   error('Requires two input arguments.');
end

U=X;  %Mann-Whitney's U statistic.

Um=prod(N);  %maximum Mann-Whitney's U.

if U > Um;
   fprintf('Error: For this 2-sample sizes the maximum Mann-Whitney''s U value must be: %2i\n\n', Um);
end

n = max(N);  %largest sample size.
m = min(N);  %smallest sample size.

if (n > 7) | (m > 7);
   fprintf('Warning: For nx or ny > 7, procedure will takes a bit long run-time.\n'); 
   fprintf('It is recommended to use the MW2cdf function you can find on the\n');
   fprintf('Matlab>File Exchange Antonio Trujillo-Ortiz'' Author Page.\n');
   disp(' ');
   cont=input('Do you want to continue anyway (y/n):','s');
   
   if (cont=='y');
      disp('On your own choose...Please, wait.');
      
      for i = 1:n
         x(i) = 0;
      end;
      
      for j = 1:m
         y(j) = 1;
      end;
      
      V = [x y];
      
      N = sum(N);
      M = 2^N-1;
      
%Procedure to get the matrix of the total number of combinations among the O's and 1's:
%the rows are the N!/n!m! different ways (vectors) of arranging.
%Also, for each arrangement estimates the placements of x(i) [the number of y's less
%than x(i)].
      kk = 1:M;
      bip = dec2bin(kk,N);
      clear kk
      p = find((sum(double(bip'))-N*48) == n);
      Bip = bip(p,:);
      clear bip
      nB = length(Bip);
      v=[];
      for k = 1:nB
         w = Bip(k,:);
         ns = find(w == '1');
         nw = length(ns);
         summ = 0;
         for kk = 1:nw
            r = w(ns(kk)+1:end);
            nic = length(find(r == '0'));
            summ = summ+nic;
         end;
         v = [v;summ];
      end;
      
      Bip;  %matrix of the different ways of arranging.
      v;  %vector of the sum of placements of x(i).
      
      vo = sort(v);  %ordered vector of the sum of placements of x(i).
      
      %Frequency distribution.
      F = [];
      for i = 0:max(vo)
         f = sum(vo == i);
         F = [F,f];
      end;
      
      Fc = cumsum(F);  %cumulative frequency distribution.
      fc = Fc*1/sum(F);  %make distribution relative.
      
      UU = [0:length(F)-1];  %vector of all the possible Mann-Whitney's U values.
      
      u = find(UU == U);  %location of the interested Mann-Whitney's U on all the possible U's for this 2-sample sizes.
      
      y = fc(u);  %association of the interested Mann-Whitney's U with its cumulative distribution.
      
   else
   end
else
   for i = 1:n
      x(i) = 0;
   end;
   
   for j = 1:m
      y(j) = 1;
   end;
   
   V = [x y];
   
   N = sum(N);
   M = 2^N-1;
   
%Procedure to get the matrix of the total number of combinations among the O's and 1's:
%the rows are the N!/n!m! different ways (vectors) of arranging.
%Also, for each arrangement estimates the placements of x(i) [the number of y's less
%than x(i)].
   kk = 1:M;
   bip = dec2bin(kk,N);
   clear kk
   p = find((sum(double(bip'))-N*48) == n);
   Bip = bip(p,:);
   clear bip
   nB = length(Bip);
   v=[];
   for k = 1:nB
      w = Bip(k,:);
      ns = find(w == '1');
      nw = length(ns);
      summ = 0;
      for kk = 1:nw
         r = w(ns(kk)+1:end);
         nic = length(find(r == '0'));
         summ = summ+nic;
      end;
      v = [v;summ];
   end;
   
   Bip;  %matrix of the different ways of arranging.
   v;  %vector of the sum of placements of x(i).
   
   vo = sort(v);  %ordered vector of the sum of placements of x(i).
   
   %Frequency distribution.
   F = [];
   for i = 0:max(vo)
      f = sum(vo == i);
      F = [F,f];
   end;
   
   Fc = cumsum(F);  %cumulative frequency distribution.
   fc = Fc*1/sum(F);  %make distribution relative.
   
   UU = [0:length(F)-1];  %vector of all the possible Mann-Whitney's U values.
   
   u = find(UU == U);  %location of the interested Mann-Whitney's U on all the possible U's for this 2-sample sizes.
   y = fc(u);  %association of the interested Mann-Whitney's U with its cumulative distribution.
end
