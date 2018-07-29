% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% This program accepts a mark between 1 and 10 as user input. According to 
% the input mark the program  returns an answer pass (for mark >5) or fail.



a=input('mark? ')

if (a>0 &a<5)
    disp('fail')
end

if (a>=5 & a<=10)
    disp('pass')
end

if (a<=0 |a>10)
    disp('choose again')
end