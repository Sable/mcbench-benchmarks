% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% This function is terminated if the input matrix is not invertible 



function B = det1(A)
       if det(A)==0
           disp('non invertible matrix')
           B=NaN;
           return
       else
         B=inv(A);
       end