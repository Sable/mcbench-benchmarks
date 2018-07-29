% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% This program illustrates the non execution of the statements for i=3
% with the use of the command continue.



for i=1:5
    if (i==3)
        continue;
    end
    b(i)=i^2;
end
display(b)