function [d, q, a, b, f] = extendedEuclidean_forward(p, q)
   %  return array [d, a, b] such that d = gcd(p, q), ap + bq = d
f = [];

   while (q(end) ~= 0)
       f = [f floor(p(end)/q(end))];
       p = [p q(end)];
       q = [q mod(p(end-1), q(end))];
   end
               
   % updates
         q = q(1:(end));
       
         d = p(1:(end-1));
         a = 1;
         b = 0;
         
         
         % print steps
         numberOfSteps = numel(f) - 1;
         
         fprintf ('Euclidean algorithm. Forward process.\n\n');
         for i = 1:numberOfSteps+1
             fprintf('%d = %d * %d + %d \n', d(i), f(i), q(i), q(i+1));
         end
         
         fprintf ('\n\n');
end

%{
    d    = f * q +  _

(1) 1239 = 1 * 735 + 504
(2) 735 = 1 *  504 + 231
(3) 504 = 2 * 231 + 42
(4) 231 = 5 * 42 + 21
(5) 42 = 2 * 21
%}