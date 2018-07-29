function res = SymPoly2Sym(F,Dexp,MaxCtr)
%SYMPOLY2SYM   Similar to poly2sym but can handle symbolic coefficients and
%indeterminate variables specified as equations
%
%   SymPoly2Sym('a*z^2 + b*z + c','z') = [a b c]
%   SymPoly2Sym('a*sin(x)^2 + b*sin(x) + c','sin(x)') = [a b c]

%%This function iteratively takes the derivative then evaluates at 0 to
%%determine the coefficients

if nargin<2,
    Dexp = 't'; %Default dependent variable
end
F = sym(subs(F,Dexp,'XX')); %Substitute independent variable 'XX' for dependent expression Dexp
   
if nargin<3,
    MaxCtr = 20; %Default maximum order
end

res = sym([]); %Initialize res as empty sym
ctr = 0; %Initialize counter
while F~=0,
    res(end+1) = subs(F,'XX',0); %Evaluate at XX=0 
    F = diff(F,'XX',1); %Take derivative
    
    %%%%Check ctr as a defense against recursive loops
    ctr = ctr+1; 
    if ctr>=MaxCtr,
        disp(['Error: Exceeded maximum number of terms (' num2str(MaxCtr) ')'])
        disp(['Inputs may be in invalid form (not a polynomial)'])
        disp('To increase maximum number, use SymPoly2Sym(F,DV,Max#)')
        res = [];
        return
    end
    %%%%%%%%
    
end
Fact = [1 cumprod(1:length(res)-1)]; %Create factorial vector
res = res./Fact; %Divide coefficients by the amount contributed by derivative operations
res = res(end:-1:1); %Reverse order to match poly2sym convention