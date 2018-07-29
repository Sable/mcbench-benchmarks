% Simple Hill Climbing
% for the Rosenbrock function
% By Kyriakos Tsourapas
% You may contact me through the Mathworks site
% University of Essex 2002

% The string used was divided as follows:
% 1 bit for the sign
% 2 bits for the integer part
% 10 bits for the decimal part
% 1 bit for the sign of the 2nd variable
% 2 bits for the integer part of the 2nd variable
% 10 bits for the decimal part of the 2nd variable
% total : 26 bits

clear;
clc;
TRUE = 1;
FALSE = 0;

t = 0;
uplimit  = 2.048;
lowlimit = -2.048;
start_points = 20;

% START THE HILL CLIMBING

% LOOK IN start_points STARTING POINTS
while t < start_points
    local = FALSE;
    
    % CREATE A NEW STRING AT RANDOM, WITHIN THE LIMITS
    num1 = 10; % just to get in the loop
    num2 = 10; % just to get in the loop
    while num1 < lowlimit | num1 > uplimit | num2 < lowlimit | num2 > uplimit
        str = rand(26,1);

        for i=1:size(str,1)
            if str(i) < 0.5 
                str(i) = 0;
            else
                str(i) = 1;
            end
        end
        [num1, num2] = myconvert(str);
    end

    % SEARCH UNTIL LOCAL OPTIMUM IS REACHED
    while ~local
        k = 1;
        F = myfunc(str);
        % CREATE 26 DIFFERENT STRINGS AND KEEP THE BEST
        % BY FLIPPING A SIGLLE BIT AT A TIME
        while k < 27        
            new_str = newstr(str, k);
            newF = myfunc(new_str);
            
            if k == 1
                bestStr_sofar = new_str;
            else
                bestF_sofar = myfunc(bestStr_sofar);
                if newF < bestF_sofar
                    bestStr_sofar = new_str;
                end
            end
                

            k = k + 1;
        end

        % COMPARE THE BEST OF THE 26 STRINGS WITH
        % THE STARTING STRING
        if F > bestF_sofar
            str = bestStr_sofar;
        else
            local = TRUE;
        end
        
    end

    F = myfunc(str);

    if (t == 0) | (F < bestF)
        bestF = F;
        best_str = str;
    end
    
    disp( sprintf('%4d. F=%10f x=%10f y=%10f', t, F, num1, num2) );
    t = t + 1;
end

[num1, num2] = myconvert(best_str);
bestF = myfunc(best_str);
disp( sprintf('\nBest Found\nF=%10f x=%10f y=%10f', bestF, num1, num2) );
