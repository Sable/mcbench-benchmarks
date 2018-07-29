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
W = 0;
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
           disp('Coefficient Matrix :: ');
           disp(P);
           disp('RHS matrix of Linear System :: ');
           disp(P1)
           disp('Initial Guesses :: ');
           disp(P2);
           disp('No. Of Iterations :: ');
           disp(P3)
           if (W > 0)
               disp(['Over Relaxation Factor :: ',num2str(W)])
               disp(' ')
           end
           disp('Solution Matrix :: ');
           disp(Y2)
           disp('[------------------------------------------------------------]')
           disp(' ');
           j = 1;
        case 'No'
           clc;
           j = 0;
    end
end 
%Main Program%
disp('[----------------------------------------------------]')
disp(' ****Numerical Methods For Solving Linear Systems**** ')
disp('[----------------------------------------------------]')
disp(' ')
C = input('1.Gauss-Seidel Iteration \n \n2.Jacobi Iteration \n \n3.SOR(Successive Over Relaxation) Iteration \n \nEnter Your Choice Number :: ');
disp(' ')
if (C == 1)
    D = ' ****Gauss Seidel Iteration**** ';
    disp(D)
    disp(' ')
    P = input('Enter The Coefficients in the form of a square Matrix :: ');
    disp(' ');
    P1 = input('Enter The Values Of Equalites (From RHS of Equations) in the form of row matrix :: ');
    disp(' ');
    L = length(P1);
    M = -1*P;
    for n = 1:1:L
        M(n,n) = 0;
        M(n,:) = M(n,:)./P(n,n);
    end
    P2 = input('Enter The Initial Guesses Of the Variables in a row matrix form :: ');
    disp(' ');
    M1 = P2;
    P3 = input('Enter The No. Of Iterations :: ');
    disp(' ');
    for i = 1:1:P3
        for m = 1:1:L
            M1(1,m) = M(m,:)*(M1') + (P1(1,m)./(P(m,m)));
        end
    end
    Y2 = M1;
    disp(['The Solution Is :: ',num2str(Y2)])
else
    if (C == 2)
        D = ' ****Jacobi Iteration**** ';
        disp(D)
        disp(' ')
        P = input('Enter The Coefficients in the form of a square Matrix :: ');
        disp(' ')
        P1 = input('Enter The Values Of Equalites (From RHS of Equations) in the form of row matrix :: ');
        disp(' ');
        L = length(P1);
        M = -1*P;
        for n = 1:1:L
            M(n,n) = 0;
            M(n,:) = M(n,:)./P(n,n);
        end
        P2 = input('Enter The Initial Guesses Of the Variables in a row matrix form :: ');
        disp(' ');
        M1 = P2;
        K1 = M1;
        P3 = input('Enter The No. Of Iterations :: ');
        disp(' ');
        for i = 1:1:P3
            for m = 1:1:L
                M1(1,m) = M(m,:)*(K1') + (P1(1,m)./(P(m,m)));
            end
            K1 = M1;
        end
        Y2 = M1;
        disp(['The Solution Is :: ',num2str(Y2)])
    else
        if (C == 3)
            D = ' ****SOR(Succesive Over Relaxation) Iteration**** ';
            disp(D)
            disp(' ');
            P = input('Enter The Coefficients in the form of a square Matrix :: ');
            disp(' ');
            P1 = input('Enter The Values Of Equalites (From RHS of Equations) in the form of row matrix :: ');
            disp(' ');
            P2 = input('Enter The Initial Guesses Of the Variables in a row matrix form :: ');
            disp(' ');
            L = length(P1);
            M = -1*P;
            M1 = P2;
            W = input('Enter The Over Relaxation Factor :: ');
            disp(' ');
            P3 = input('Enter The No. Of Iterations :: ');
            disp(' ');
            if (W > 1)
                for n = 1:1:L
                    M(n,n) = 0;
                end
                for i = 1:1:P3
                    for m = 1:1:L
                        M1(1,m) = (1 - W).*(M1(1,m)) + (W./P(m,m)).*(M(m,:)*(M1') + P1(1,m));
                    end
                end
                Y2 = M1;
                disp(['The Solution Is :: ',num2str(Y2)])
            else
                errordlg('W should be greater Than 1','Note');
                clc;
            end
        else
            errordlg('Invalid Choice','ERROR')
            clc;
        end
    end
end
disp(' ')
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