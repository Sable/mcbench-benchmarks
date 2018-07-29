function [val table]= muller(strEqn,strVar,p0,p1,p2,tol,n)
%MULLER uses the Muller's method to solve for a root of f(x)
%
% Find a solution to f(x) = 0 given three approximations p0, p1
% and p2 (Note that Muller's method may return complex roots)
%
%
%  INPUT:
%         strEqn: is the string representation of the equation f(x)
%         strVar: is the varialbe in strEqn
%     p0, p1, p2: initial guesses at the solution
%            tol: is the solution tolerence
%              n: is the maximum number of iterations of the algorithum.
%
%  OUTPUT:   val: is the approximate solution (can be complex)
%          table: is the iteration table
%
%
%  USAGE:   val = muller(strEqn,strVar,x0,x1,x2,tol,n)
%          [val table] = muller(...) to display a table of the iterations
%           val = muller('x^3+2*x^2-5','x',0,1,2,10^-4,100)
%
%     BY: Jonathan Lister (jlister1@utk.edu)

%% Additonal Examples
% 
%           strEqn = '16*x^4-40*x^3+5*x^2+20*x+6';
%           strVar = 'x';
%           tol = 10^-5;
% 
%           disp('p0 = 0.5, p1 = -0.5, p2 = 0.0')
%           [root1 table1]= muller(strEqn,strVar,0.5,-0.5,0,tol,100)
% 
%           disp('p0 = 0.5, p1 = 1.0, p2 = 1.5')
%           [root2 table2]= muller(strEqn,strVar,0.5,1.0,1.5,tol,100)
% 
%           disp('p0 = 2.5, p1 = 2.0, p2 = 2.25')
%           [root3 table3]= muller(strEqn,strVar,2.5,2.0,2.25,tol,100)
%

%% Input Error Checking
if nargin < 7
    error('Incorrect number of input arguments type "help muller"')
end

if tol < 0
    error('tolerance must be a positive number')
end

if ~ischar(strEqn)
    error('Input 1 Error, a string of the equation of interest is required')
end

if ~ischar(strVar)
    error('Input 3 Error, a string representation of the variable is required')
end

%parse equation
F = vectorize(inline(strEqn,strVar));

%intitialize output variables
val = [];
table ={};

%% Algorithm 2.8 from text.
%Step 1
h1 = p1 - p0;
h2 = p2 - p1;
del1 = (F(p1)-F(p0))./h1;
del2 = (F(p2)-F(p1))./h2;
d = (del2-del1)./(h2+h1);
I = 3;

%Step 2
while I <= n
    %Step 3
    b = del2+h2.*d;
    D = sqrt(b.^2-4.*F(p2).*d); % could be complex
    %Step 4
    if abs(b - D) < abs(b + D)
        E = b + D;
    else
        E = b - D;
    end
    %Step 5
    h = -2.*F(p2)./E;
    p = p2 + h;
    
    if I == 3
        table{1} = 'Muller''s Method Iterations';
        table{2}='  I             P                     f(P)           ';
        table{3}='-----------------------------------------------------';
    end
    str = sprintf('%3u:  % 6.6f + %6.6fi % 6.6f + %6.6fi',I,real(p),imag(p),real(F(p)),imag(F(p)));
    table{I + 1} = str; %#ok<*AGROW>    
    
    %Step 6
    if abs(h) < tol
        val = p;
        table = char(table);
        break
    end
    p0 = p1;
    p1 = p2;
    p2 = p;
    h1 = p1 - p0;
    h2 = p2 - p1;
    del1 = (F(p1)-F(p0))./h1;
    del2 = (F(p2)-F(p1))./h2;
    d = (del2-del1)./(h2+h1);
    I = I + 1;
end

if isempty(val)
    disp('The procedure was unsuccessful.')
    table = char(table);    
end