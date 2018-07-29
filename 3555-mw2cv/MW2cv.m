function x = MW2cv(P,N)
%MW1CV   critical Mann-Whitney's U associated to a p-value. 
%It obtain a Mann-Whitney's U of two random variables with continuous cumulative
%distribution associated to a p-value. This procedure is highly recommended for sample sizes
%7< nx & ny <=40. For nx & ny <=7 it is recommended to use the MW1cv function;
%otherwise, U-value may be a poor approximation.
%It works with a procedure to get the nearest cumulative distribution relative value to P.
%[Based on the Fortran77 algorithm AS 62 Appl. Statist. (1973)]
%
%   Syntax: function x = MW2cv(P,N) 
%      
%     Inputs:
%          P - cumulative probability value of interest.
%          N - 2-element vector of sample sizes for the two samples []. 
% The input quantities should be scalars.
%     Outputs:
%          x - Mann-Whitney's U statistic.
%
%    Example: For two independent samples we are interested to get the
%             Mann-Whitney's statistic U with an associated cumulative
%             probability P = 0.95. Sample sizes are n1 = 36 and n2 = 14.
%
%                              P = 0.95; N = [36,14];
%
%     Calling on Matlab the function: 
%             x = MW2cv(P,N)
%
%       Answer is:
%
%                 328    
%

%  Created by A. Trujillo-Ortiz and R. Hernandez-Walls
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.mx
%
%  May 23, 2003.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A. and R. Hernandez-Walls. (2003). MW2cv: Critical Mann-Whitney's U 
%    associated to a p-value: nx or ny >7. A MATLAB file. [WWW document]. URL http://
%    www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=3555&objectType=FILE
%
%  References:
% 
%  Mann, H. B. and Whitney, D. R. (1947), On a test of whether one of two   
%           random variables is stochastically larger than the other. Annals
%           of Mathematical Statistics, 18: 50-60.
%  Algorithm AS 62 (1973). Journal of Applied Statistics, 22(2):1-3.
%

if nargin <  2,
   error('Requires two input arguments.');
end

nmin = min(N);  %largest sample size.
nmax = max(N);  %smallest sample size.

if (nmin <= 7) & (nmax <= 7);
   fprintf('Warning: For nx and ny <= 7, the p-value may be a poor approximation.\n'); 
   fprintf('It is recommended to use the MW1cv function you can find on the\n');
   fprintf('Matlab>File Exchange Antonio Trujillo-Ortiz'' Author Page.\n');
   disp(' ');
   cont=input('Do you want to continue anyway (y/n):','s');
   
   if (cont=='y');
      disp('Here it goes.');
      
      mn1 = prod(N)+1;
      n1 = nmax+1;
      freq = [ones(n1,1); zeros(mn1-n1,1)];
      
      lwrk = floor((mn1+1)/2 + nmin);
      work = zeros(lwrk,1);
      
% Generate successively higher-order distributions
      in = nmax;
      for i = 2:nmin
         in = in+nmax;
         n1 = in+2;
         l = 1 + in/2;
         k = i;
         
% Generate complete distribution from outside inwards
         for j = 1:l
            k = k+1;
            n1 = n1-1;
            summ = freq(j) + work(j);
            freq(j) = summ;
            work(k) = summ - freq(n1);
            freq(n1) = summ;
         end;
      end;
      
      freq = freq/sum(freq);  % Make distribution relative
      
% Cumulative frequency distribution
      cumfreq = cumsum(freq);
      
%Location of the interested Mann-Whitney's U on all the possible U's for this 2-sample sizes.
%Here we are using a procedure to get the nearest fc value to P.
      cumfreq=cumfreq-P;
      u = find(abs(cumfreq)==min(abs(cumfreq(:))));
      
      UU = [0:length(freq)-1];  %vector of all the possible Mann-Whitney's U values.
      
%Association of the interested Mann-Whitney's U with its cumulative distribution.
      x = UU(u);
   else
   end
else
   
   mn1 = prod(N)+1;
   n1 = nmax+1;
   freq = [ones(n1,1); zeros(mn1-n1,1)];
   
   lwrk = floor((mn1+1)/2 + nmin);
   work = zeros(lwrk,1);
   
%Generate successively higher-order distributions
   in = nmax;
   for i = 2:nmin
      in = in+nmax;
      n1 = in+2;
      l = 1 + in/2;
      k = i;
      
%Generate complete distribution from outside inwards
      for j = 1:l
         k = k+1;
         n1 = n1-1;
         summ = freq(j) + work(j);
         freq(j) = summ;
         work(k) = summ - freq(n1);
         freq(n1) = summ;
      end;
   end;
   
   freq = freq/sum(freq);  % Make distribution relative
   
% Cumulative frequency distribution
   cumfreq = cumsum(freq);
   
%Location of the interested Mann-Whitney's U on all the possible U's for this 2-sample sizes.
%Here we are using a procedure to get the nearest fc value to P.
   cumfreq=cumfreq-P;
   u = find(abs(cumfreq)==min(abs(cumfreq(:))));
   
   UU = [0:length(freq)-1];  %vector of all the possible Mann-Whitney's U values.
   
%Association of the interested Mann-Whitney's U with its cumulative distribution.
   x = UU(u);      
end
