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
while (y1 == 'y') && (y2 == 'y')
if (y3 == 'y') 
    clc;
    choice = questdlg('Do you want to keep the previous analysis ?', ...
	'**********', ...
	'Yes','No','Yes');
    switch choice
        case 'Yes'
           disp('[------------------------------------------------------------]');
           disp(' ****PREVIOUS ANALYSIS**** ');
           disp(D);
           disp(['Step Size :: ',num2str(P1)]);
           disp(['Initial Input And Output :: ',num2str(P2)]);
           disp(['Final Input :: ',num2str(P3)]);
           disp(['Final Output :: ',num2str(Y2)]);
           disp('[------------------------------------------------------------]');
           disp(' ');
           j = 1;
        case 'No'
           clc;
           j = 0;
    end
end 
%Main Program%
disp('[------------------------------------------------------------]')
disp(' ****Numerical Methods For Solving Differential Equations**** ')
disp('[------------------------------------------------------------]')
disp(' ')
C = input('1.Euler Method \n \n2.Euler-Cauchy Method \n \n3.Runge-Kutta Method \n \nEnter Your Choice Number :: ');
disp(' ')
if (C == 1)
    D = ' ****Euler Method****';
    disp(D)
    disp(' ');
    G = 0;
    P1 = input('Enter The Step Size :: ');
    disp(' ');
    P2 = input('Enter The Initial Input And Output(within []) :: ');
    disp(' ');
    P3 = input('Enter The Value Of "x" to find "y" at that point :: ');
    disp(' ');
    Q = input('Do You Want To see all the values of y within the interval ? (y/n) :: ','s');
    disp(' ');
    Y1 = P2(1,1);
    Y2 = P2(1,2);
    for h = P2(1,1):P1:P3
        x = Y1;
        y = Y2;
        P = UserInputFunction(x,y);
        if (h ~= P2(1,1))
            G = Y2 + P1.*(P);
            Y2 = G;
            Y1 = Y1 + P1;
        end
        G1 = Y2;
        b = (((h-P2(1,1))./P1)+1);
        x = round(b);
        X = h;
        if (Q == 'y')
            disp(['"x" :: ',num2str(X)])
            disp(['"y" :: ',num2str(G1)])
            disp(' ')
        end
        G2(1,x) = Y2;
    end
    disp(['The Required Value is :: ',num2str(Y2)]);
    disp(' ');
    Q1 = input('Do You Want To Plot "y" vs "x" ?(y/n) :: ','s');
    if (Q1 == 'y')
        x = P2(1,1):P1:P3;
        plot(x,G2)
    end
else
    if(C == 2)
        D = ' ****Euler-Cauchy Method**** ';
        disp(D);
        disp(' ');
        G = 0;
        P1 = input('Enter The Step Size :: ');
        disp(' ');
        P2 = input('Enter The Initial Input And Output(within []) :: ');
        disp(' ');
        P3 = input('Enter The Value Of "x" to find "y" at that point :: ');
        disp(' ');
        Q = input('Do You Want To see all the values of y within the interval ? (y/n) :: ','s');
        disp(' ');
        Y1 = P2(1,1);
        Y2 = P2(1,2);
        for h = P2(1,1):P1:P3
            x = Y1;
            y = Y2;
            P = UserInputFunction(x,y);
            if (h ~= P2(1,1))
                G = Y2 + P1.*(P);
                G4 = P;
                x = Y1 + P1;
                y = G;
                P = UserInputFunction(x,y);
                G3 = Y2 + (1./2).*(P1.*G4) + (1./2).*(P1.*P);
                Y2 = G3;
                Y1 = Y1 + P1;
            end
            G1 = Y2;
            b = (((h-P2(1,1))./P1)+1);
            x = round(b);
            X = h;
            if (Q == 'y')
                disp(['"x" :: ',num2str(X)])
                disp(['The Value of "y" :: ',num2str(G1)])
                disp(' ');
            end
            G2(1,x) = Y2;
        end
        disp(['The Required Value is :: ',num2str(Y2)]);
        disp(' ');
        Q1 = input('Do You Want To Plot "y" vs "x" ?(y/n) :: ','s');
        if (Q1 == 'y')
            x = P2(1,1):P1:P3;
            plot(x,G2)
        end
    else
        if (C == 3)
            D = ' ****Runge-Kutta Method**** ';
            disp(D);
            disp(' ');
            G = 0;
            P1 = input('Enter The Step Size :: ');
            disp(' ');
            P2 = input('Enter The Initial Input And Output(within []) :: ');
            disp(' ');
            P3 = input('Enter The Value Of "x" to find "y" at that point :: ');
            disp(' ');
            Q = input('Do You Want To see all the values of y within the interval ? (y/n) :: ','s');
            disp(' ');
            Y1 = P2(1,1);
            Y2 = P2(1,2);
            for h = P2(1,1):P1:P3
                x = Y1;
                y = Y2;
                P = UserInputFunction(x,y);
                if (h ~= P2(1,1))
                    K1 = P;
                    x = Y1 + P1.*0.5;
                    y = Y2 + P1.*0.5.*P;
                    P = UserInputFunction(x,y);
                    K2 = P;
                    x = Y1 + P1.*0.5;
                    y = Y2 + P1.*0.5.*P;
                    P = UserInputFunction(x,y);
                    K3 = P;
                    x = Y1 + P1;
                    y = Y2 + P1.*P;
                    P = UserInputFunction(x,y);
                    K4 = P;
                    G = Y2 + (P1./6).*(K1 + 2.*K2 + 2.*K3 + K4);
                    Y2 = G;
                    Y1 = Y1 + P1;
                end
                G1 = Y2;
                b = (((h-P2(1,1))./P1)+1);
                x = round(b);
                X = h;
                if (Q == 'y')
                    disp(['"x" :: ',num2str(X)])
                    disp(['The Value of "y" :: ',num2str(G1)])
                    disp(' ')
                end
                G2(1,x) = Y2;
            end
            disp(['The Required Value is :: ',num2str(Y2)]);
            disp(' ');
            Q1 = input('Do You Want To Plot "y" vs "x" ?(y/n) :: ','s');
            if (Q1 == 'y')
                x = P2(1,1):P1:P3;
                plot(x,G2)
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