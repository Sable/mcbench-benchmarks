function X = newtonraphson(Eqn_Str,Start_Point,Max_Iter)

% Function :
%        X = newtonraphson(fun_str,Start_Point)
%              Finds the root of an equation by NEWTON-RAPHSON METHOD.
%          
%         x(n+1) = x(n) - (F(x(n))/diff(F(x(n)));
%
% INPUTS :
%        Eqn_Str     : The equation whose root has to be find.
%                      Eqn_Str Should be an string format.
%                      Example :  
%                       if  F(x) = x^4 - x - 10
%                       the Eqn_Str = 'x^4 - x - 10';
%        
%        Start_Point : Initial value of root X ==> x0
%
%        Max_Iter    : Maximum number of iterations
%           
% OUTPUT : 
%        X           : Estimeted root of Equation.
%--------------------------------------------------------------------------
% By :-
%      SANDEEP SOLANKI
%      rtm_sandeep@rediffmail.com
%--------------------------------------------------------------------------
if nargin < 2
    error('Not Enough Input Arguments');
end

if nargin < 3
    Max_Iter = 1000;
end

if ~ischar(Eqn_Str)
    error('Funtion Should Be an String');
end

fx = inline(Eqn_Str);
fxd = inline(diff(Eqn_Str));

x0 = Start_Point;
disp(['F(X) = ' Eqn_Str]);
disp(['X0 = ' num2str(x0)]);
% Iterating
for i = 1 : Max_Iter
    s1=sprintf('    Iteration : %1.0f',i);
    disp(s1);
    x1 = x0 - (fx(x0)/fxd(x0));
    
    s2=sprintf('              X(%0.0f) = %0.15f',i,x1);
    disp(s2);
    if x1 == x0
        disp('Terminating Process : Value of Root Repeated');
        break;
    else
        x0 = x1;        
    end
end

if x1 == NaN
    error('Start Point is Not Correct');
end
X = x1;