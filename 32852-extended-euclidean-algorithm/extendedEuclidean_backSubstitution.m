function [x, y] = extendedEuclidean_backSubstitution (d, q, a, b, f)
             x = 0;
             y = 1;
             
         % print steps
         numberOfSteps = numel(f) - 1;
         fprintf ('Switching the equations.\n\n');
         step = 1;
         
         for i = (numberOfSteps):-1:1
             fprintf('%d = %d - (%d * %d)\n', q(i+1), d(i), f(i), q(i));
             
             if (mod(step, 2) ~= 0)                 
                 x = x + y * f(i);
             else
                 y = y + x * f(i);
             end
             
             step = step + 1;
         end      
         
         x = x * (-1);
         
         fprintf('\n\nAnswer:\n');
         if (gcd(d(1),q(1)) == (x * d(1) + y * q(1)))
         fprintf('(%d) * %d + (%d) * %d = %d \n', x, d(1), y, q(1), (x * d(1) + y * q(1)) );
         else
         fprintf('(%d) * %d + (%d) * %d = %d \n', y, d(1), x, q(1), (y * d(1) + x * q(1)) );
         end
end
