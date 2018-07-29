% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% This program accepts a mark between 1 and 10 as user input. According to 
% the input mark the program  returns an answer pass (for mark >5) or fail.



a=input('mark? ')

switch(a)
    case{1,2,3,4}
        disp('fail')
    case{5,6,7,8,9,10}
        disp('pass')
    otherwise
        disp('choose again')
end 