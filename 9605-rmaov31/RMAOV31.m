function [RMAOV31] = RMAOV31(X,alpha)
% RMAOV31 Three-way Analysis of Variance With Repeated Measures on One Factor Test.
%   This is a three-factor analysis of variance design in which there are repeated measures
%   on only one of the factors. In repeated measures designs, the same participants are used
%   in all conditions. This is like an extreme matching. This allows for reduction of error
%   variance due to subject factors. Fewer participants can be used in an repeated measures
%   design. Repeated measures designs make it easier to see an effect of the independent 
%   variable on the dependent variable (if there is such an effect). 
%   There are two different error terms. One of the error terms involves subject-to-subject
%   variability within each group or, in the case of the present design, within each cell
%   formed by the two between-group factors. The other error term involves the variability
%   within subjects. The within-subject variability can be divided into five components, 
%   which include the main effect of the RM factor and all of its interactions.
%   The SS components are divided up for this design in a way that is best illustrated in a
%   SS tree, as shown:
%
%                                                      /
%                                                     | SSA
%                                            /        |
%                                           | SSAB   <  SSB
%                                           |         |
%                                 /         |         | SSAxB
%                                | SSB-S   <           \
%                                |          |
%                                |          |
%                                |          | [SSEAB]
%                                |           \         
%                                |
%                        SSTO   <           
%                                |           /                     
%                                |          | SSC
%                                |          |
%                                |          | SSAxC
%                                |          |
%                                | SSW-S   <  SSBxC
%                                 \         |
%                                           | SSAxBxC
%                                           | 
%                                           | [SSEC]
%                                            \         
%                    
%   Syntax: function [RMAOV31] = RMAOV31(X,alpha) 
%      
%     Inputs:
%          X - data matrix (Size of matrix must be n-by-5;dependent variable=column 1;
%              independent variable 1=column 2;independent variable 2=column 3;
%              independent variable 3=column 4; subject=column 5). 
%      alpha - significance level (default = 0.05).
%    Outputs:
%            - Complete Analysis of Variance Table.
%
%    Example: From the example of Howell (2002, p. 494-498). Involving a comparision of two approaching educational 
%             programs (intervention) to reduce the risk of HIV infection among African-American adolescents. Subjects
%             were male and female adolescents, and measures were taken on four different times. This is a 2x2x4 
%             repeated-measures design, with intervention and sex as between-subjects factors and time as the 
%             within-subjects factor. The data (table below) are frequency of condom-protected intercourse [log(x+1)].
%             We take a significance level = 0.05.
%
%                                         I1                                                       I2
%             --------------------------------------------------------------------------------------------------------------------
%                          M                            F                           M                            F               
%             --------------------------------------------------------------------------------------------------------------------
%    Subject     T1     T2     T3     T4      T1     T2     T3     T4      T1     T2     T3     T4      T1     T2     T3     T4 
%    -----------------------------------------------------------------------------------------------------------------------------
%       1         7     22     13     14       0      6     22     26       0      0      0      0      15     28     26     15  
%       2        25     10     17     24       0     16     12     15      69     56     14     36       0      0      0      0        
%       3        50     36     49     23       0      8      0      0       5      0      0      5       6      0     23      0
%       4        16     38     34     24      15     14     22      8       4     24      0      0       0      0      0      0      
%       5        33     25     24     25      27     18     24     37      35      8      0      0      25     28      0     16      
%       6        10      7     23     26       0      0      0      0       7      0      9     37      36     22     14     48   
%       7        13     33     27     24       4     27     21      3      51     53      8     26      19     22     29      2
%       8        22     20     21     11      26      9      9     12      25      0      0     15       0      0      5     14
%       9         4      0     12      0       0      0     14      1      59     45     11     16       0      0      0      0
%      10        17     16     20     10       0      0     12      0      40      2     33     16       0      0      0      0
%    -----------------------------------------------------------------------------------------------------------------------------
%                                       
%     Data matrix must be:
%     X = [7 1 1 1 1;22 1 1 2 1;13 1 1 3 1;14 1 1 4 1;25 1 1 1 2;10 1 1 2 2;17 1 1 3 2;24 1 1 4 2;50 1 1 1 3;36 1 1 2 3;49 1 1 3 3;
%     23 1 1 4 3;16 1 1 1 4;38 1 1 2 4;34 1 1 3 4;24 1 1 4 4;33 1 1 1 5;25 1 1 2 5;24 1 1 3 5;25 1 1 4 5;10 1 1 1 6;7 1 1 2 6;23 1 1 3 6;
%     26 1 1 4 6;13 1 1 1 7;33 1 1 2 7;27 1 1 3 7;24 1 1 4 7;22 1 1 1 8;20 1 1 2 8;21 1 1 3 8;11 1 1 4 8;4 1 1 1 9;0 1 1 2 9;12 1 1 3 9;
%     0 1 1 4 9;17 1 1 1 10;16 1 1 2 10;20 1 1 3 10;10 1 1 4 10;0 1 2 1 11;6 1 2 2 11;22 1 2 3 11;26 1 2 4 11;0 1 2 1 12;16 1 2 2 12;
%     12 1 2 3 12;15 1 2 4 12;0 1 2 1 13;8 1 2 2 13;0 1 2 3 13;0 1 2 4 13;15 1 2 1 14;14 1 2 2 14;22 1 2 3 14;8 1 2 4 14;27 1 2 1 15;
%     18 1 2 2 15;24 1 2 3 15;37 1 2 4 15;0 1 2 1 16;0 1 2 2 16;0 1 2 3 16;0 1 2 4 16;4 1 2 1 17;27 1 2 2 17;21 1 2 3 17;3 1 2 4 17;
%     26 1 2 1 18;9 1 2 2 18;9 1 2 3 18;12 1 2 4 18;0 1 2 1 19;0 1 2 2 19;14 1 2 3 19;1 1 2 4 19;0 1 2 1 20;0 1 2 2 20;12 1 2 3 20;
%     0 1 2 4 20;0 2 1 1 21;0 2 1 2 21;0 2 1 3 21;0 2 1 4 21;69 2 1 1 22;56 2 1 2 22;14 2 1 3 22;36 2 1 4 22;5 2 1 1 23;0 2 1 2 23;
%     0 2 1 3 23;5 2 1 4 23;4 2 1 1 24;24 2 1 2 24;0 2 1 3 24;0 2 1 4 24;35 2 1 1 25;8 2 1 2 25;0 2 1 3 25;0 2 1 4 25;7 2 1 1 26;0 2 1 2 26;
%     9 2 1 3 26;37 2 1 4 26;51 2 1 1 27;53 2 1 2 27;8 2 1 3 27;26 2 1 4 27;25 2 1 1 28;0 2 1 2 28;0 2 1 3 28;15 2 1 4 28;59 2 1 1 29;
%     45 2 1 2 29;11 2 1 3 29;16 2 1 4 29;40 2 1 1 30;2 2 1 2 30;33 2 1 3 30;16 2 1 4 30;15 2 2 1 31;28 2 2 2 31;26 2 2 3 31;15 2 2 4 31;
%     0 2 2 1 32;0 2 2 2 32;0 2 2 3 32;0 2 2 4 32;6 2 2 1 33;0 2 2 2 33;23 2 2 3 33;0 2 2 4 33;0 2 2 1 34;0 2 2 2 34;0 2 2 3 34;0 2 2 4 34;
%     25 2 2 1 35;28 2 2 2 35;0 2 2 3 35;16 2 2 4 35;36 2 2 1 36;22 2 2 2 36;14 2 2 3 36;48 2 2 4 36;19 2 2 1 37;22 2 2 2 37;29 2 2 3 37;
%     2 2 2 4 37;0 2 2 1 38;0 2 2 2 38;5 2 2 3 38;14 2 2 4 38;0 2 2 1 39;0 2 2 2 39;0 2 2 3 39;0 2 2 4 39;0 2 2 1 40;0 2 2 2 40;0 2 2 3 40;
%     0 2 2 4 40];
%
%     Calling on Matlab the function: 
%             RMAOV31(X)
%
%     Answer is:
%
%    The number of IV1 levels are: 2
%    The number of IV2 levels are: 2
%    The number of IV3 levels are: 4
%    The number of subjects are:   40
%
%    Three-Way Analysis of Variance With Repeated Measures on One-Factor (Within -Subjects) Table.
%    -------------------------------------------------------------------------------------------------
%    SOV                           SS          df           MS             F        P      Conclusion
%    -------------------------------------------------------------------------------------------------
%    Between-Subjects         21490.344        39
%    IV1                        107.256         1        107.256         0.215   0.6457       NS
%    IV2                       3358.056         1       3358.056         6.731   0.0136        S
%    IV1xIV2                     63.756         1         63.756         0.128   0.7228       NS
%    Error(IV1xIV2)           17961.275        36        498.924
%
%    Within-Subjects          13914.250       120
%    IV3                        274.069         3         91.356         0.896   0.4456       NS
%    IV1xIV3                   1377.819         3        459.273         4.507   0.0051        S
%    IV2xIV3                    779.919         3        259.973         2.551   0.0594       NS
%    IV1xIV2xIV3                476.419         3        158.806         1.558   0.2037       NS
%    Error(IV3)               11006.025       108        101.908
%    -------------------------------------------------------------------------------------------------
%    Total                    35404.594       159
%    -------------------------------------------------------------------------------------------------
%    With a given significance level of: 0.05
%    The results are significant (S) or not significant (NS).
%
%    Created by A. Trujillo-Ortiz, R. Hernandez-Walls and F.A. Trujillo-Perez
%               Facultad de Ciencias Marinas
%               Universidad Autonoma de Baja California
%               Apdo. Postal 453
%               Ensenada, Baja California
%               Mexico.
%               atrujo@uabc.mx
%
%    Copyright.January 7, 2006.
%
%    ---Special thanks are given to Georgina M. Blanc from the Vision Center Laboratory of the 
%       Salk Institute for Biological Studies, La Jolla, CA, for encouraging us to create
%       this m-file-- 
%
%    To cite this file, this would be an appropriate format:
%    Trujillo-Ortiz, A., R. Hernandez-Walls and F.A. Trujillo-Perez. (2006). Three-way 
%      Analysis of Variance With Repeated Measures on One Factor Test. A MATLAB file. 
%      [WWW document]. URL http://www.mathworks.com/matlabcentral/fileexchange/
%      loadFile.do?objectId=9605
%
%    References:
%    Howell, D. C. (2002), Statistical Methods for Psychology. 5th ed. 
%             Pacific Grove, CA:Duxbury Wadsworth Group.
%

if nargin < 2,
   alpha = 0.05; %(default)
end; 

if (alpha <= 0 | alpha >= 1)
   fprintf('Warning: significance level must be between 0 and 1\n');
   return;
end;

if nargin < 1, 
   error('Requires at least one input argument.');
   return;
end;

a = max(X(:,2));
b = max(X(:,3));
c = max(X(:,4));
s = max(X(:,5));

disp('   ');
fprintf('The number of IV1 levels are:%2i\n', a);
fprintf('The number of IV2 levels are:%2i\n', b);
fprintf('The number of IV3 levels are:%2i\n', c);
fprintf('The number of subjects are:   %2i\n\n', s);

CT = (sum(X(:,1)))^2/length(X(:,1));  %correction term
SSTO = sum(X(:,1).^2)-CT;  %total sum of squares
v10 = length(X(:,1))-1;  %total degrees of freedom
   
%procedure related to the subjects.
S = [];
indice = X(:,5);
for l = 1:s
    Xe = find(indice==l);
    eval(['S' num2str(l) '=X(Xe,1);']);
    eval(['x =((sum(S' num2str(l) ').^2)/length(S' num2str(l) '));']);
    S = [S,x];
end;

%--Procedure Related to the Between-Subjects--
%procedure related to the IV1 (independent variable 1 [between-subject]).
A = [];
indice = X(:,2);
for i = 1:a
    Xe = find(indice==i);
    eval(['A' num2str(i) '=X(Xe,1);']);
    eval(['x =((sum(A' num2str(i) ').^2)/length(A' num2str(i) '));']);
    A = [A,x];
end;
SSA = sum(A)-CT;  %sum of squares for the IV1
v1 = a-1;  %degrees of freedom for the IV1
MSA = SSA/v1;  %mean square for the IV1

%procedure related to the IV2 (independent variable 2 [between-subject]).
B = [];
indice = X(:,3);
for j = 1:b
    Xe = find(indice==j);
    eval(['B' num2str(j) '=X(Xe,1);']);
    eval(['x =((sum(B' num2str(j) ').^2)/length(B' num2str(j) '));']);
    B =[B,x];
end;
SSB = sum(B)-CT;  %sum of squares for the IV2
v2 = b-1;  %degrees of freedom for the IV2
MSB = SSB/v2;  %mean square for the IV2

%procedure related to the IV1 and IV2 (between- and between- subject).
AB = [];
for i = 1:a
    for j = 1:b
        Xe = find((X(:,2)==i) & (X(:,3)==j));
        eval(['AB' num2str(i) num2str(j) '=X(Xe,1);']);
        eval(['x =((sum(AB' num2str(i) num2str(j) ').^2)/length(AB' num2str(i) num2str(j) '));']);
        AB = [AB,x];
    end;
end;
SSAB = sum(AB)-sum(A)-sum(B)+CT;  %sum of squares of the IV1xIV2
v3 = v1*v2;  %degrees of freedom of the IV1xIV2
MSAB = SSAB/v3;  %mean square for the IV1xIV2

%procedure related to the IV1-IV2-error.
SSEAB = sum(S)-sum(AB);  %sum of squares of the IV1-IV2-error
v4 = s-(a*b);  %degrees of freedom of the IV1-IV2-error
MSEAB = SSEAB/v4;  %mean square for the IV1-IV2-error

%F-statistics calculation.
F1 = MSA/MSEAB;
F2 = MSB/MSEAB;
F3 = MSAB/MSEAB;

%Probability associated to the F-statistics.
P1 = 1 - fcdf(F1,v1,v4);    
P2 = 1 - fcdf(F2,v2,v4);   
P3 = 1 - fcdf(F3,v3,v4);

SSBS = SSA+SSB+SSAB+SSEAB;
vBS = v1+v2+v3+v4;

%--Procedure Related to the Within-Subjects--
%procedure related to the IV3 (independent variable 3 [within-subject]).
C = [];
indice = X(:,4);
for k = 1:c
    Xe = find(indice==k);
    eval(['C' num2str(k) '=X(Xe,1);']);
    eval(['x =((sum(C' num2str(k) ').^2)/length(C' num2str(k) '));']);
    C =[C,x];
end;
SSC = sum(C)-CT;  %sum of squares for the IV2
v5 = c-1;  %degrees of freedom for the IV2
MSC = SSC/v5;  %mean square for the IV2

%procedure related to the IV1 and IV3 (between- and within- subject).
AC = [];
for i = 1:a
    for k = 1:c
        Xe = find((X(:,2)==i) & (X(:,4)==k));
        eval(['AC' num2str(i) num2str(k) '=X(Xe,1);']);
        eval(['x =((sum(AC' num2str(i) num2str(k) ').^2)/length(AC' num2str(i) num2str(k) '));']);
        AC = [AC,x];
    end;
end;
SSAC = sum(AC)-sum(A)-sum(C)+CT;  %sum of squares of the IV1xIV3
v6 = v1*v5;  %degrees of freedom of the IV1xIV3
MSAC = SSAC/v6;  %mean square for the IV1xIV3

%procedure related to the IV2 and IV3 (between- and within- subject).
BC = [];
for j = 1:b
    for k = 1:c
        Xe = find((X(:,3)==j) & (X(:,4)==k));
        eval(['BC' num2str(j) num2str(k) '=X(Xe,1);']);
        eval(['x =((sum(BC' num2str(j) num2str(k) ').^2)/length(BC' num2str(j) num2str(k) '));']);
        BC = [BC,x];
    end;
end;
SSBC = sum(BC)-sum(B)-sum(C)+CT;  %sum of squares of the IV2xIV3
v7 = v2*v5;  %degrees of freedom of the IV2xIV3
MSBC = SSBC/v7;  %mean square for the IV2xIV3

%procedure related to the IV1, IV2 and IV3 (between, between- and within- subject).
ABC = [];
for i = 1:a
    for j = 1:b
        for k = 1:c
            Xe = find((X(:,2)==i) & (X(:,3)==j) & (X(:,4)==k));
            eval(['AB' num2str(i) num2str(j) num2str(k) '=X(Xe,1);']);
            eval(['x =((sum(AB' num2str(i) num2str(j) num2str(k) ').^2)/length(AB' num2str(i) num2str(j) num2str(k) '));']);
            ABC = [ABC,x];
        end;
    end;
end;
SSABC = sum(ABC)+sum(A)+sum(B)+sum(C)-sum(AB)-sum(AC)-sum(BC)-CT;  %sum of squares of the IV1xIV2xIV3
v8 = v1*v2*v5;  %degrees of freedom of the IV1xIV2
MSABC = SSABC/v8;  %mean square for the IV1xIV2

%procedure related to the IV3-error.
EIV3 = [];
for k = 1:c
    for l = 1:s
        Xe = find((X(:,4)==k) & (X(:,5)==l));
        eval(['IV3S' num2str(k) num2str(l) '=X(Xe,1);']);
        eval(['x =((sum(IV3S' num2str(k) num2str(l) ').^2)/length(IV3S' num2str(k) num2str(l) '));']);
        EIV3 = [EIV3,x];
    end;
end;
SSEC = sum(EIV3)-sum(S)-sum(ABC)+sum(AB);  %sum of squares of the IV3-error
v9 = v4*v5;  %degrees of freedom of the IV3-error
MSEC = SSEC/v9;  %mean square for the IV3-error

%F-statistics calculation.
F4 = MSC/MSEC;
F5 = MSAC/MSEC;
F6 = MSBC/MSEC;
F7 = MSABC/MSEC;

%Probability associated to the F-statistics.
P4 = 1 - fcdf(F4,v5,v9);
P5 = 1 - fcdf(F5,v6,v9);
P6 = 1 - fcdf(F6,v7,v9);
P7 = 1 - fcdf(F7,v8,v9);

SSWS = SSC+SSAC+SSBC+SSABC+SSEC;
vWS = v5+v6+v7+v8+v9;

if P1 >= alpha;
    ds1 ='NS';
else
    ds1 =' S';
end;
if  P2 >= alpha;
    ds2 ='NS';
else
    ds2 =' S';
end;
if  P3 >= alpha;
    ds3 ='NS';
else
    ds3 =' S';
end;
if  P4 >= alpha;
    ds4 ='NS';
else
    ds4 =' S';
end;
if P5 >= alpha;
    ds5 ='NS';
else
    ds5 =' S';
end;
if  P6 >= alpha;
    ds6 ='NS';
else
    ds6 =' S';
end;
if  P7 >= alpha;
    ds7 ='NS';
else
    ds7 =' S';
end;

disp('Three-Way Analysis of Variance With Repeated Measures on One-Factor (Within -Subjects) Table.')
fprintf('-------------------------------------------------------------------------------------------------\n');
disp('SOV                           SS          df           MS             F        P      Conclusion');
fprintf('-------------------------------------------------------------------------------------------------\n');
fprintf('Between-Subjects       %11.3f%10i\n',SSBS,vBS);
fprintf('IV1                    %11.3f%10i%15.3f%14.3f%9.4f%9s\n',SSA,v1,MSA,F1,P1,ds1);
fprintf('IV2                    %11.3f%10i%15.3f%14.3f%9.4f%9s\n',SSB,v2,MSB,F2,P2,ds2);
fprintf('IV1xIV2                %11.3f%10i%15.3f%14.3f%9.4f%9s\n',SSAB,v3,MSAB,F3,P3,ds3);
fprintf('Error(IV1xIV2)         %11.3f%10i%15.3f\n\n',SSEAB,v4,MSEAB);
fprintf('Within-Subjects        %11.3f%10i\n',SSWS,vWS);
fprintf('IV3                    %11.3f%10i%15.3f%14.3f%9.4f%9s\n',SSC,v5,MSC,F4,P4,ds4);
fprintf('IV1xIV3                %11.3f%10i%15.3f%14.3f%9.4f%9s\n',SSAC,v6,MSAC,F5,P5,ds5);
fprintf('IV2xIV3                %11.3f%10i%15.3f%14.3f%9.4f%9s\n',SSBC,v7,MSBC,F6,P6,ds6);
fprintf('IV1xIV2xIV3            %11.3f%10i%15.3f%14.3f%9.4f%9s\n',SSABC,v8,MSABC,F7,P7,ds7);
fprintf('Error(IV3)             %11.3f%10i%15.3f\n',SSEC,v9,MSEC);
fprintf('-------------------------------------------------------------------------------------------------\n');
fprintf('Total                  %11.3f%10i\n',SSTO,v10);
fprintf('-------------------------------------------------------------------------------------------------\n');
fprintf('With a given significance level of: %.2f\n', alpha);
disp('The results are significant (S) or not significant (NS).');

return;