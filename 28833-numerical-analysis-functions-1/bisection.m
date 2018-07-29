function [val table]= bisection(strEqn,strVar,a,b,tol,n)
%BISECTION finds a solution to f(x) = 0 using the bisection method
%
% find a root given the continuous function f on the interval [a,b], 
% where f(a) and f(b) have opposite signs.
%
%  INPUT:
%         strEqn: is the string representation of the equation f(x)
%         strVar: is the varialbe in strEqn
%            a,b: define the interval over which the method is exercised
%            tol:  is the solution tolerence
%              n: is the maximum number of iterations of the algorithum.
%
%  OUTPUT:   val: is the approximate solution
%          table: is the iteration table
%
%  USAGE:  val = bisection(strEqn,strVar,a,b,tol,n,tggl)
%         [val table] = bisection(...) to display a table of the iterations
%          val = bisection('x^2-3','x',1.0,2.0,10^-4,100)
%
%     BY: Jonathan Lister (jlister1@utk.edu)

if nargin < 6
    error('Incorrect number of input arguments type "help bisection"')
end

f = vectorize(inline(strEqn,strVar));

if a > b
    x = a;
    a = b;
    b = x;
end

if a==b
    error('Input (a) cannot equal (b)\n')
end

fa = f(a);
fb = f(b);

if fa*fb > 0
    error('f(a) and f(b) have the same sign\n')
end

if tol < 0
    error('tolerance must be a positive number')
end

% STEP 1
I = 1;
% STEP 2
while I <= n
    % STEP 3
    % Compute P(I)
    c = (b - a) / 2.0;
    p = a + c;
    % STEP 4
    fp = f(p);
    
      if I == 1
        table{1} = 'Bisection Method Iterations';
        table{2} = ' I        a        b        c        p    ';
        table{3} = '------------------------------------------'; 
      end
      table{3+I} = sprintf('%3u: % 5.5f % 5.5f % 5.5f % 5.5f',I,a,b,c,p); %#ok<*AGROW>
    
    if abs(fp) < 1.0e-20 | c < tol
        % procedure completed successfully
        val = p;
        table = char(table);
        break
    else
        % STEP 5
        I = I+1;
        % STEP 6
        % compute A(I) and B(I)
        if fa*fp > 0
            a = p;
            fa = fp;
        else
            b = p;
        end
    end
end
end