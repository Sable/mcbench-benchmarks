% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% 
% 
% problem 1- Unilateral Laplace Transform computation 

syms s t
f=-1.25+3.5*t*exp(-2*t) +1.25*exp(-2*t);

F=laplace(f,s);
simplify (F);
pretty(ans) 

%verification
f=ilaplace(F,t);
simplify(f);
pretty(ans)
