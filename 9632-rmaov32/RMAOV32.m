function [RMAOV32] = RMAOV32(X,alpha)
% RMAOV32 Three-way Analysis of Variance With Repeated Measures on Two Factors Test.
%   This is a three-factor analysis of variance design in which there are repeated measures
%   on two of the factors. In repeated measures designs, the same participants are used
%   in all conditions. This is like an extreme matching. This allows for reduction of error
%   variance due to subject factors. Fewer participants can be used in an repeated measures
%   design. Repeated measures designs make it easier to see an effect of the independent 
%   variable on the dependent variable (if there is such an effect).
%   With only one RM factor there is only one error term that involves an interaction with the
%   subject factor, and that error term is found easily by subtraction. However, with two RM
%   factors the subject factor interacts with each RM factor separately, and with the interaction
%   of the two of them, yielding three different error terms. The extraction of these extra error
%   terms requires the collapsing of more intermediate tables, and the calculation of more 
%   intermediate SS terms.
%   For each RM factor the appropriate error term is based on the interaction of the subject
%   factor with that RM factor. The more that subjects move in parallel from one level of the RM
%   factor to another, the smaller the error term. The error term for each RM factor is based on
%   averaging over the other factor. However, the third RM error term, the error term for the
%   interaction of the two RM factors, is based on the three-way interaction of the subject factor
%   and the two RM factors, with no averaging of scores. To the extent that each subject exhibits
%   the same twoway interaction for the RM factors, this error term will be small.
%   The SS components are divided up for this design in a way that is best illustrated in a SS tree,
%   as shown:
%
%                                            / 
%                                 /         | SSA 
%                                | SSB-S   < 
%                                |          | [SSEA]
%                                |           \         
%                                |
%                                |
%                                |           /         /
%                                |          |         | SSB
%                                |          |         |
%                                |          |  SSAB  <  SSAxB
%                                |          |         |
%                                |          |         | [SSEAB]
%                                |          |          \
%                        SSTO   <           | 
%                                |          |          / 
%                                |          |         | SSC
%                                |          |         |
%                                | SSW-S   <   SSAC  <  SSAxC
%                                |          |         |
%                                |          |         | [SSEAC]
%                                |          |          \
%                                |          |
%                                |          |          / 
%                                |          |         | SSBC 
%                                |          |         |
%                                |          |  SSBC  <  SSABC
%                                |          |         |
%                                |          |         | [SSEBC]
%                                 \          \         \         
%                    
%   Syntax: function [RMAOV32] = RMAOV32(X,alpha) 
%      
%     Inputs:
%          X - data matrix (Size of matrix must be n-by-5;dependent variable=column 1;
%              independent variable 1=column 2;independent variable 2 (within-subjects)=column 3;
%              independent variable 3 (within-subjects)=column 4; subject=column 5 [Be careful
%              how the code for the subjects are entered.]) 
%      alpha - significance level (default = 0.05).
%    Outputs:
%            - Complete Analysis of Variance Table.
%
%    Example: From the example of Howell (2002, p. 502-508). Investigating the degree to which a tone,
%             which had previously been paired with shock, would suppress the rate of an ongoing bar-
%             pressing response in rats. For the experiment there were using three groups of rats 
%             (conditioned), four cycles (within-subjects factor) and two phases (within-subjects factor).
%             Table data are bar-pressing response per minute. We use a significance level = 0.05.
%
%                              G1                                 G2                                  G3
%             --------------------------------------------------------------------------------------------------------------------
%                C1       C2       C3       C4       C1       C2       C3       C4       C1       C2       C3       C4
%             --------------------------------------------------------------------------------------------------------------------
%    Subject   P1   P2  P1   P2  P1   P2  P1   P2  P1   P2  P1   P2  P1   P2  P1   P2  P1   P2  P1   P2  P1   P2  P1   P2
%    -----------------------------------------------------------------------------------------------------------------------------
%       1       1   28  22   48  22   50  14   48   1    6  16    8   9   14  11   33  33   43  40   52  39   52  38   48 
%       2      21   21  16   40  15   39  11   56  37   59  28   36  34   32  26   37   4   35   9   42   4   46  23   51        
%       3      15   17  13   35  22   45   1   43  18   43  38   50  39   15  29   18  32   39  38   47  24   44  16   40
%       4      30   34  55   54  37   57  57   68   1    2   9    8   6    5   5   15  17   34  21   41  27   50  13   40     
%       5      11   23  12   33  10   50   8   53  44   25  28   42  47   46  33   35  44   52  37   48  33   53  33   43      
%       6      16   11  18   34  11   40   5   40  15   14  22   32  16   23  32   26  12   16   9   39   9   59  13   45   
%       7       7   26  29   40  25   50  14   56   0    3   7   17   6    9  10   15  18   42   3   62  45   49  60   57
%       8       0   22  23   45  18   38  15   50  26   15  31   32  28   22  16   15  13   29  14   44   9   50  15   48
%    -----------------------------------------------------------------------------------------------------------------------------
%                                       
%     Data matrix must be:
%     X=[1 1 1 1 1;28 1 1 2 1;22 1 2 1 1;48 1 2 2 1;22 1 3 1 1;50 1 3 2 1;14 1 4 1 1;48 1 4 2 1;21 1 1 1 2;21 1 1 2 2;16 1 2 1 2;
%     40 1 2 2 2;15 1 3 1 2;39 1 3 2 2;11 1 4 1 2;56 1 4 2 2;15 1 1 1 3;17 1 1 2 3;13 1 2 1 3;35 1 2 2 3;22 1 3 1 3;45 1 3 2 3;1 1 4 1 3;
%     43 1 4 2 3;30 1 1 1 4;34 1 1 2 4;55 1 2 1 4;54 1 2 2 4;37 1 3 1 4;57 1 3 2 4;57 1 4 1 4;68 1 4 2 4;11 1 1 1 5;23 1 1 2 5;12 1 2 1 5;
%     33 1 2 2 5;10 1 3 1 5;50 1 3 2 5;8 1 4 1 5;53 1 4 2 5;16 1 1 1 6;11 1 1 2 6;18 1 2 1 6;34 1 2 2 6;11 1 3 1 6;40 1 3 2 6;5 1 4 1 6;
%     40 1 4 2 6;7 1 1 1 7;26 1 1 2 7;29 1 2 1 7;40 1 2 2 7;25 1 3 1 7;50 1 3 2 7;14 1 4 1 7;56 1 4 2 7;0 1 1 1 8;22 1 1 2 8;23 1 2 1 8;
%     45 1 2 2 8;18 1 3 1 8;38 1 3 2 8;15 1 4 1 8;50 1 4 2 8;1 2 1 1 1;6 2 1 2 1;16 2 2 1 1;8 2 2 2 1;9 2 3 1 1;14 2 3 2 1;11 2 4 1 1;
%     33 2 4 2 1;37 2 1 1 2;59 2 1 2 2;28 2 2 1 2;36 2 2 2 2;34 2 3 1 2;32 2 3 2 2;26 2 4 1 2;37 2 4 2 2;18 2 1 1 3;43 2 1 2 3;38 2 2 1 3;
%     50 2 2 2 3;39 2 3 1 3;15 2 3 2 3;29 2 4 1 3;18 2 4 2 3;1 2 1 1 4;2 2 1 2 4;9 2 2 1 4;8 2 2 2 4;6 2 3 1 4;5 2 3 2 4;5 2 4 1 4;15 2 4 2 4;
%     44 2 1 1 5;25 2 1 2 5;28 2 2 1 5;42 2 2 2 5;47 2 3 1 5;46 2 3 2 5;33 2 4 1 5;35 2 4 2 5;15 2 1 1 6;14 2 1 2 6;22 2 2 1 6;32 2 2 2 6;
%     16 2 3 1 6;23 2 3 2 6;32 2 4 1 6;26 2 4 2 6;0 2 1 1 7;3 2 1 2 7;7 2 2 1 7;17 2 2 2 7;6 2 3 1 7;9 2 3 2 7;10 2 4 1 7;15 2 4 2 7;
%     26 2 1 1 8;15 2 1 2 8;31 2 2 1 8;32 2 2 2 8;28 2 3 1 8;22 2 3 2 8;16 2 4 1 8;15 2 4 2 8;33 3 1 1 1;43 3 1 2 1;40 3 2 1 1;52 3 2 2 1;
%     39 3 3 1 1;52 3 3 2 1;38 3 4 1 1;48 3 4 2 1;4 3 1 1 2;35 3 1 2 2;9 3 2 1 2;42 3 2 2 2;4 3 3 1 2;46 3 3 2 2;23 3 4 1 2;51 3 4 2 2;
%     32 3 1 1 3;39 3 1 2 3;38 3 2 1 3;47 3 2 2 3;24 3 3 1 3;44 3 3 2 3;16 3 4 1 3;40 3 4 2 3;17 3 1 1 4;34 3 1 2 4;21 3 2 1 4;41 3 2 2 4;
%     27 3 3 1 4;50 3 3 2 4;13 3 4 1 4;40 3 4 2 4;44 3 1 1 5;52 3 1 2 5;37 3 2 1 5;48 3 2 2 5;33 3 3 1 5;53 3 3 2 5;33 3 4 1 5;43 3 4 2 5;
%     12 3 1 1 6;16 3 1 2 6;9 3 2 1 6;39 3 2 2 6;9 3 3 1 6;59 3 3 2 6;13 3 4 1 6;45 3 4 2 6;18 3 1 1 7;42 3 1 2 7;3 3 2 1 7;62 3 2 2 7;
%     45 3 3 1 7;49 3 3 2 7;60 3 4 1 7;57 3 4 2 7;13 3 1 1 8;29 3 1 2 8;14 3 2 1 8;44 3 2 2 8;9 3 3 1 8;50 3 3 2 8;15 3 4 1 8;48 3 4 2 8];
%
%     Calling on Matlab the function: 
%             RMAOV32(X)
%
%     Answer is:
%
%    The number of IV1 levels are: 3
%    The number of IV2 levels are: 4
%    The number of IV3 levels are: 2
%    The number of subjects are:   24
%
%    Three-Way Analysis of Variance With Repeated Measures on Two Factors (Within -Subjects) Table.
%    -------------------------------------------------------------------------------------------------
%    SOV                           SS          df           MS             F        P      Conclusion
%    -------------------------------------------------------------------------------------------------
%    Between-Subjects         20340.120        23
%    IV1                       4616.760         2       2308.380         3.083   0.0670       NS
%    Error(IV1)               15723.359        21        748.731
%
%    Within-Subjects          32059.875       168
%    IV2                       2726.974         3        908.991        12.027   0.0000        S
%    IV1xIV2                   1047.073         6        174.512         2.309   0.0445        S
%    Error(IV1xIV2)            4761.328        63         75.577
%
%    IV3                      11703.130         1      11703.130       129.855   0.0000        S
%    IV1xIV3                   4054.385         2       2027.193        22.493   0.0000        S
%    Error(IV1xIV3)            1892.609        21         90.124
%
%    IV2xIV3                    741.516         3        247.172         4.035   0.0109        S
%    IV1xIV2xIV3               1273.781         6        212.297         3.466   0.0051        S
%    Error(IV2-IV3)            3859.078        63         61.255
%    -------------------------------------------------------------------------------------------------
%    Total                    52399.995       191
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
%    Trujillo-Ortiz, A., R. Hernandez-Walls and F.A. Trujillo-Perez. (2006). RMAOV32: Three-way 
%      Analysis of Variance With Repeated Measures on Two Factors Test. A MATLAB file. [WWW document].
%      URL http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=9632
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

CT = (sum(X(:,1)))^2/length(X(:,1));  %correction term
SSTO = sum(X(:,1).^2)-CT;  %total sum of squares
v12 = length(X(:,1))-1;  %total degrees of freedom
   
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
%procedure related to the IV1 (independent variable 1 [between-subjects]).
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

%procedure related to the IV1-error.
EIV1 = [];
for i = 1:a
    for l = 1:s
        Xe = find((X(:,2)==i) & (X(:,5)==l));
        eval(['IV1S' num2str(i) num2str(l) '=X(Xe,1);']);
        eval(['x =((sum(IV1S' num2str(i) num2str(l) ').^2)/length(IV1S' num2str(i) num2str(l) '));']);
        EIV1 = [EIV1,x];
    end;
end;
SSEA = sum(EIV1)-sum(A);  %sum of squares of the IV1-error
v2 = a*(s-1);  %degrees of freedom of the IV1-error
MSEA = SSEA/v2;  %mean square for the IV1-error

%F-statistics calculation.
F1 = MSA/MSEA;

%Probability associated to the F-statistics.
P1 = 1 - fcdf(F1,v1,v2);    

SSBS = SSA+SSEA;
vBS = v1+v2;

ss = vBS+1;
fprintf('The number of subjects are:   %2i\n\n', ss);

%--Procedure Related to the Within-Subjects--
%procedure related to the IV2 (independent variable 2 [within-subject]).
B = [];
indice = X(:,3);
for j = 1:b
    Xe = find(indice==j);
    eval(['B' num2str(j) '=X(Xe,1);']);
    eval(['x =((sum(B' num2str(j) ').^2)/length(B' num2str(j) '));']);
    B =[B,x];
end;
SSB = sum(B)-CT;  %sum of squares for the IV2
v3 = b-1;  %degrees of freedom for the IV2
MSB = SSB/v3;  %mean square for the IV2

%procedure related to the IV1 and IV2 (between- and within- subject).
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
v4 = v1*v3;  %degrees of freedom of the IV1xIV2
MSAB = SSAB/v4;  %mean square for the IV1xIV2

%procedure related to the IV2-error.
EIV2 = [];
for i = 1:a
    for j = 1:b
        for l = 1:s
            Xe = find((X(:,2)==i) & (X(:,3)==j) & (X(:,5)==l));
            eval(['IV2S' num2str(i) num2str(j) num2str(l) '=X(Xe,1);']);
            eval(['x =((sum(IV2S' num2str(i) num2str(j) num2str(l) ').^2)/length(IV2S' num2str(i) num2str(j) num2str(l) '));']);
            EIV2 = [EIV2,x];
        end;
    end;
end;
SSEB = sum(EIV2)-sum(AB)-sum(EIV1)+sum(A);
v5= v2*v3;  %degrees of freedom of the IV1-IV2-error
MSEB = SSEB/v5;  %mean square for the IV1-IV2-error

%F-statistics calculation
F2 = MSB/MSEB;
F3 = MSAB/MSEB;

%Probability associated to the F-statistics.
P2 = 1 - fcdf(F2,v3,v5);   
P3 = 1 - fcdf(F3,v4,v5);

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
v6 = c-1;  %degrees of freedom for the IV2
MSC = SSC/v6;  %mean square for the IV2

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
v7 = v1*v6;  %degrees of freedom of the IV1xIV3
MSAC = SSAC/v7;  %mean square for the IV1xIV3

%procedure related to the IV2-error.
EIV3 = [];
for i = 1:a
    for k = 1:c
        for l = 1:s
            Xe = find((X(:,2)==i) & (X(:,4)==k) & (X(:,5)==l));
            eval(['IV3S' num2str(i) num2str(k) num2str(l) '=X(Xe,1);']);
            eval(['x =((sum(IV3S' num2str(i) num2str(k) num2str(l) ').^2)/length(IV3S' num2str(i) num2str(k) num2str(l) '));']);
            EIV3 = [EIV3,x];
        end;
    end;
end;
SSEC = sum(EIV3)-sum(AC)-sum(EIV1)+sum(A);
v8= v2*v6;  %degrees of freedom of the IV1-IV2-error
MSEC = SSEC/v8;  %mean square for the IV1-IV2-error

%F-statistics calculation
F4 = MSC/MSEC;
F5 = MSAC/MSEC;

%Probability associated to the F-statistics.
P4 = 1 - fcdf(F4,v6,v8);   
P5 = 1 - fcdf(F5,v7,v8);

%procedure related to the IV2 and IV3 (within- and within- subject).
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
v9 = v3*v6;  %degrees of freedom of the IV2xIV3
MSBC = SSBC/v9;  %mean square for the IV2xIV3

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
v10 = v1*v3*v6;  %degrees of freedom of the IV1xIV2
MSABC = SSABC/v10;  %mean square for the IV1xIV2

%procedure related to the IV2-IV3-error.
EIV23 = [];
for i = 1:a
    for j = 1:b
        for k = 1:c
            for l = 1:s
                Xe = find((X(:,2)==i) &(X(:,3)==j) & (X(:,4)==k) & (X(:,5)==l));
                eval(['IV23S' num2str(i) num2str(j) num2str(k) num2str(l) '=X(Xe,1);']);
                eval(['x =((sum(IV23S' num2str(i) num2str(j) num2str(k) num2str(l) ').^2)/length(IV23S' num2str(i) num2str(j) num2str(k) num2str(l) '));']);
                EIV23 = [EIV23,x];
            end;
        end;
    end;
end;
SSEBC = sum(EIV23)-sum(ABC)-sum(EIV3)+sum(AC)-sum(EIV2)+sum(AB)+sum(EIV1)-sum(A);  %sum of squares of the IV2-IV3-error
v11 = v2*v3*v6;  %degrees of freedom of the IV2-IV3-error
MSEBC = SSEBC/v11;  %mean square for the IV2-IV3-error

%F-statistics calculation
F6 = MSBC/MSEBC;
F7 = MSABC/MSEBC;

%Probability associated to the F-statistics.
P6 = 1 - fcdf(F6,v9,v11);
P7 = 1 - fcdf(F7,v10,v11);

SSWS = SSB+SSAB+SSEB+SSC+SSAC+SSEC+SSBC+SSABC+SSEBC;
vWS = v3+v4+v5+v6+v7+v8+v9+v10+v11;

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

disp('Three-Way Analysis of Variance With Repeated Measures on Two Factors (Within -Subjects) Table.')
fprintf('-------------------------------------------------------------------------------------------------\n');
disp('SOV                           SS          df           MS             F        P      Conclusion');
fprintf('-------------------------------------------------------------------------------------------------\n');
fprintf('Between-Subjects       %11.3f%10i\n',SSBS,vBS);
fprintf('IV1                    %11.3f%10i%15.3f%14.3f%9.4f%9s\n',SSA,v1,MSA,F1,P1,ds1);
fprintf('Error(IV1)             %11.3f%10i%15.3f\n\n',SSEA,v2,MSEA);
fprintf('Within-Subjects        %11.3f%10i\n',SSWS,vWS);
fprintf('IV2                    %11.3f%10i%15.3f%14.3f%9.4f%9s\n',SSB,v3,MSB,F2,P2,ds2);
fprintf('IV1xIV2                %11.3f%10i%15.3f%14.3f%9.4f%9s\n',SSAB,v4,MSAB,F3,P3,ds3);
fprintf('Error(IV1xIV2)         %11.3f%10i%15.3f\n\n',SSEB,v5,MSEB);
fprintf('IV3                    %11.3f%10i%15.3f%14.3f%9.4f%9s\n',SSC,v6,MSC,F4,P4,ds4);
fprintf('IV1xIV3                %11.3f%10i%15.3f%14.3f%9.4f%9s\n',SSAC,v7,MSAC,F5,P5,ds5);
fprintf('Error(IV1xIV3)         %11.3f%10i%15.3f\n\n',SSEC,v8,MSEC);
fprintf('IV2xIV3                %11.3f%10i%15.3f%14.3f%9.4f%9s\n',SSBC,v9,MSBC,F6,P6,ds6);
fprintf('IV1xIV2xIV3            %11.3f%10i%15.3f%14.3f%9.4f%9s\n',SSABC,v10,MSABC,F7,P7,ds7);
fprintf('Error(IV2-IV3)         %11.3f%10i%15.3f\n',SSEBC,v11,MSEBC);
fprintf('-------------------------------------------------------------------------------------------------\n');
fprintf('Total                  %11.3f%10i\n',SSTO,v12);
fprintf('-------------------------------------------------------------------------------------------------\n');
fprintf('With a given significance level of: %.2f\n', alpha);
disp('The results are significant (S) or not significant (NS).');

return;