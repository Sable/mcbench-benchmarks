%%%% EVALUATES CONSTRIANT ERROR

% Course: Robotic Manipulation and Mobility
% Advisor: Dr. V. Krovi
% 
% Homework Number: MIDTERM
% 
% Names: Sourish Chakravarty 
% 	Hrishi Lalit Shah

function [Cerr]= CONSTRAINT_ERROR_1(th1,x2,y2,th2)

global l1 lc1 l2 lc2

Cerr=[];

for i=1:length(th1)

    c1=cos(th1(i));
    c2=cos(th2(i));
    s1=sin(th1(i));
    s2=sin(th2(i));


    C= [x2(i)-l1*c1-lc2*c2;
        y2(i)-l1*s1-lc2*s2];
    Cerr=[Cerr;abs(C')];
end

return
