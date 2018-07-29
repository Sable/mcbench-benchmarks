% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
%

% problem 3 - u'(t)=dirac(t)


syms r t
int(dirac(r),r,-inf,t)
