function [val table]= fixedpoint(strEqn,strVar,p0,tol,n)
%FIXEDPOINT uses the fixed-point method to solve for a root of f(x)
%
% Finds a solution to f(x) = 0 given an initial approximation p0
%
%  INPUT:
%         strEqn: is the string representation of the equation f(x)
%         strVar: is the varialbe in strEqn
%             p0: initial guess at the solution
%            tol: is the solution tolerence
%              n: is the maximum number of iterations of the algorithum.
%
%  OUTPUT:   val: is the approximate solution
%          table: is the iteration table
%
%
%  USAGE:   val = fixedpoint(strEqn,strVar,p0,tol,n)
%           [val table] = fixedpoint(...) to display a table of the iterations
%           val =fixedpoint('x^3+2*x^2-5','x',1,10^-4,100)
%           
%   NOTE: You must place your f(x) in fixed point form x = g(x) and input
%         the g(x) into this function.
%
%     BY: Jonathan Lister (jlister1@utk.edu)

if nargin < 5
    error('Incorrect number of input arguments type "help fixedpoint"')
end

if ~ischar(strEqn)
    error('Input 1 Error, a string of the equation of interest is required')
end

if ~ischar(strVar)
    error('Input 2 Error, a string representation of the variable is required')
end

if tol < 0
    error('tolerance must be a positive number')
end

G = vectorize(inline(strEqn,strVar));
P0 = p0;

% STEP 1
I = 1;
% STEP 2
while I <= n
    % STEP 3
    % compute P(I)
    P = G(P0);
    
    if I == 1
        table{1} = 'Fixed-Point Method Iterations';
        table{2} = ' I        P0        P      ';
        table{3} = '---------------------------';
    end
    str = sprintf('%3u: % 5.5f % 5.5f',I,P0,P);
    table{3+I} = str; %#ok<*AGROW>
    
    % STEP 4  
    if abs(P-P0) < tol
        val = P;
        table = char(table);
        success = true;
        break
    else
        % STEP 5
        I = I+1;
        % STEP 6
        % update P0
        P0 = P;
    end
end
if ~success
   val = [];
   disp('failed to converge to solution')
   table = char(table);
end
