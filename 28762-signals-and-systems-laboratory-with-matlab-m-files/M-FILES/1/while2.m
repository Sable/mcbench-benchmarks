% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% In this program if the user input is not valid (i.e., between 1 and 10)
% the user is requested to enter again his mark

a=1;
while(1)
    a=input('Mark ?')
    if (a>0 & a<5)
        disp('fail')
        break;
    elseif (a>=5 & a<=10)
        disp('pass')
        break;
    else
        disp('choose again');
    end
end