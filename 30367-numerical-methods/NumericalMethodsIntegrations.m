%Program by Asutosh Mishra% 
%Initializations And Start of program%
clc;
close all;
clear all;
y1 = input('Press "y" and "Enter" to Start The Program:: ','s');
disp(' ')
if (y1 ~= 'y')
    errordlg('**Please Type "y" to continue Else The Program Will Terminate**','Caution');
    y1 = input('Press "y" and Enter to Continue:: ','s');
end
y2 = y1;
y3 = 'n';
clc;
C = 0;
helpdlg('This Program Involves User Defined Functions which can be given in Line no.5 of UserInputFunction.m','Please Note');
%Code For reruning program%
while (y1 == 'y') && (y2 == 'y')
    %Code For Looking previous Analysis%
if (y3 == 'y') 
    clc;
    choice = questdlg('Do you want to keep the previous analysis ?', ...
	'**********', ...
	'Yes','No','Yes');
    switch choice
        case 'Yes'
           disp('[------------------------------------------------------------]')
           disp(' ****PREVIOUS ANALYSIS****')
           disp(D);
           disp(['Start Point Of Integration :: ',num2str(P1)]);
           disp(['End Point Of Integration :: ',num2str(P2)]);
           disp(['Width Of Subdivisions :: ',num2str(P3)]);
           disp(['The Solution Is :: ',num2str(Y2)]);
           disp('[------------------------------------------------------------]')
           disp(' ');
           j = 1;
        case 'No'
           clc;
           j = 0;
    end
end 
%Main Program%
disp('[---------------------------------------------------]')
disp(' ****Numerical Methods For Integrating Functions**** ')
disp('[---------------------------------------------------]')
disp(' ')
C = input('1.Trapizoidal Rule \n \n2.Simpsons Rule \n \n3.Mid-Ordinate Rule \n \nEnter Your Choice Number :: ');
disp(' ')
if (C == 1)
    D = ' ****Trapizoidal Rule**** ';
    disp(D)
    disp(' ');
    G = 0;
    P1 = input('Enter The Start Point Of The Integration :: ');
    disp(' ');
    P2 = input('Enter The End Point Of The Integration :: ');
    disp(' ');
    P3 = input('Enter The Width Of The Subdidvided Interval :: ');
    disp(' ');
    for n = P1:P3:P2
        x = n;
        y = 0;
        P = UserInputFunction(x,y);
        if (n == P1)
            P = P.*0.5;
        end
        if (n == P2)
            P = P.*0.5;
        end
        G = P + G;
    end
    Y2 = G.*P3;
    disp(['The Value Of The Integral is :: ',num2str(Y2)]);
    disp(' ');
else
    if (C == 2)
        D = ' ****Simpsons Rule**** ';
        disp(D)
        disp(' ');
        G = 0;
        P1 = input('Enter The Start Point Of The Integration :: ');
        disp(' ');
        P2 = input('Enter The End Point Of The Integration :: ');
        disp(' ');
        P3 = input('Enter The Width Of The Subdidvided Interval :: ');
        disp(' ');
        K = 0;
        K1 = 0;
        K2 = 0;
        K3 = 0;
        for n = P1:P3:P2
            x = n;
            y = 0;
            N = (n - P1)./P3;
            N1 = round(N);
            P = UserInputFunction(x,y);
            if (rem(N1,2)~=0) && (n ~= P1) && (n ~= P2)
                K = K + P;
            end
            if (rem(N1,2)==0) && (n ~= P1) && (n ~= P2)
                K1 = K1 + P; 
            end
            if (n == P1)
                K2 = P;
            end
            if (n == P2)
                K3 = P;
            end
            G = 4.*K + 2.*K1 + K2 + K3;
        end
        Y2 = G.*P3.*(1./3);
        disp(['The Value Of The Integral is :: ',num2str(Y2)]);
        disp(' ');
    else
        if (C == 3)
            D = ' ****Mid-Ordinate Rule**** ';
            disp(D)
            disp(' ');
            G = 0;
            P1 = input('Enter The Start Point Of The Integration :: ');
            disp(' ');
            X = P1;
            P2 = input('Enter The End Point Of The Integration :: ');
            disp(' ');
            P3 = input('Enter The Width Of The Subdidvided Interval :: ');
            disp(' ');
            G = 0;
            for n = P1:P3:(P2-P3)
                x = (X + X + P3)./2;
                y = 0;
                P = UserInputFunction(x,y);
                G = P + G;
                X = X + P3;
            end
            Y2 = G.*P3;
            disp(['The Value Of The Integral is :: ',num2str(Y2)]);
            disp(' ');
        else
            errordlg('Invalid Choice','ERROR');
            clc;
        end
    end
end
y2 = input('Do you want to Rerun Program again?(y/n)::  ','s');
if (y2 ~= 'y')&&(y2 ~= 'n')
    disp(' ');
    disp('Please Type "y" or "n"');
    disp(' ');
    y2 = input('Do you want to Rerun Program again?(y/n)::  ','s');
end
y3 = y2;
end
%Loop Ending%
if (y2 == 'n')
    disp(' ');
    disp('Program Terminated');
    disp(' ');
    disp('*****You can "Press Any Key" to clear screen and "End Program"*****');
    pause
    pause on;
    clc;
end