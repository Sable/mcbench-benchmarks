function [val table]= newton(strEqn,strDer,strVar,p0,tol,n)
%NEWTON uses the Newton-Raphson method to solve for a root of f(x)
%
% Finds a solution to f(x) = 0 given an initial approximation p0
%
%  INPUT:
%         strEqn: is the string representation of the equation f(x)
%         strDer: is the string representation of the equation f'(x)
%         strVar: is the varialbe in strEqn
%             p0: initial guess at the solution
%            tol: is the solution tolerence
%              n: is the maximum number of iterations of the algorithum.
%
%  OUTPUT:   val: is the approximate solution
%          table: is the iteration table
%
%
%  USAGE:   val = newton(strEqn,strDer,strVar,p0,tol,n)
%           [val table] = newton(...) to display a table of the iterations
%           val =newton('x^3+2*x^2-5','3*x^2_4*x','x',1,10^-4,100)
%
%    BY: Jonathan Lister (jlister1@utk.edu)

%% Input Error Checking
if nargin < 6
    error('Incorrect number of input arguments type "help newton"')
end

if tol < 0
    error('tolerance must be a positive number')
end

if ~ischar(strEqn)
    error('Input 1 Error, a string of the equation of interest is required')
end

if ~ischar(strDer)
    error('Input 2 Error, a string of the derrivative of the equation of interest is required')
end

if ~ischar(strVar)
    error('Input 3 Error, a string representation of the variable is required')
end

%% Parse input and setup variables
F = vectorize(inline(strEqn,strVar));
FP = vectorize(inline(strDer,strVar));
P0 = p0;
val = [];

%% Algorithm execution
% STEP 1
I = 1;
% STEP 2
while I <= n
    % STEP 3
    % compute P(I)
    P = P0 - F(P0)/FP(P0);
    % STEP 4
    
    if I == 1
        table{1} = 'Newton''s Method Iterations';
        table{2}=' I      P0      P      ';
        table{3}='-----------------------';
    end
    str = sprintf('%3u:  % +5.5f % +5.5f',I,P0,P);
    table{3+I} = str; %#ok<*AGROW>
    
    if abs(P-P0) < tol
        % procedure completed successfully
        val = P0;
        table = char(table);
        break
    else
        % STEP 5
        I = I+1;
        % STEP 6
        P0 = P;
    end
end
if isempty(val)
    disp('No solution was found!')
    table = char(table);
end