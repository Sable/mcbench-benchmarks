function [RMAOV1MS] = RMAOV1MS(X,alpha)
%RMAOV1MS Repeated measures single-factor analysis of variance multiple samples
% test. 
% This m-file deals with repeated measurements at t time points obtained from
% s groups of subjects or multiple samples. With or without same size. The
% simplest model is:
%
%           x_hij = m + g_h +t_j + (gt)_hj + p_i(h) + e_hij
%
% where: x_hij = response at time j from the ith subject in group h; m = 
%        overall mean; g_h = fixed effect of group h; t_j = fixed effect of
%        time j; (gt)_hj = fixed effect for the interaction of the hth group
%        with the jth time; p_i(h) = random effects for the ith subject in
%        the hth group, and e_hij = independent random error terms.
%
% For we are interested test for differences among groups, test differences
% among time points, and test the significance of the group x time interaction.
% The first test requires the assumption that the within-group covariance
% matrices are equal. The two last-ones tests require this same assumption
% and that the sphericity condition is satisfied. In general, these assumtions
% are required for all tests of within-subjects effects (repeated measures).
%  
% Syntax: RMAOV1MS(X,alpha) 
%      
% Inputs:
%     X - data matrix (Size of matrix must be n-by-4;dependent variable=
%         column 1;group=column 2;independent variable=column 3;subject=
%         column 4). 
% alpha - significance level (default = 0.05).
%
% Outputs:
%       - Complete Analysis of Variance Table.
%
% Example: From the example 5.4.2 of Charles S. Davis (2002). from an experiment
%          comparing dissolution times of pills. We use the logarithms of the
%          times, in seconds, for each pill to reach fractions remaining of
%          0.9,0.7,0.5,0.3,0.25, and 0.10. The four groups correspond to
%          different storage conditions. Under the assumption thet the 
%          logarithms of the times are normally distributed, repeated measures
%          ANOVA can be used to test for effects due to group, fraction
%          remaining, and interaction effect between group and fraction
%          remaining. Tha data are shown on the below table.
%
%          -----------------------------------------------------------
%                                        Fraction remainig
%                           ------------------------------------------
%          Group    Tablet    0.90   0.70   0.50   0.30   0.25   0.10
%          -----------------------------------------------------------
%            1         1       2.56  2.77   2.94   3.14   3.18   3.33
%                      2       2.64  2.89   3.09   3.26   3.33   3.47
%                      3       2.94  3.18   3.33   3.50   3.50   3.66
%                      4       2.56  2.83   3.04   3.22   3.26   3.37
%                      5       2.64  2.77   2.94   3.14   3.22   3.30
%                      6       2.56  2.77   2.94   3.14   3.18   3.26
%            2         1       2.56  2.83   3.07   3.26   3.33   3.51
%                      2       2.44  2.74   3.02   3.20   3.28   3.44
%                      3       2.34  2.67   2.91   3.16   3.22   3.39
%                      4       2.41  2.71   2.94   3.16   3.21   3.36
%            3         1       2.46  2.83   3.09   3.32   3.37   3.54
%                      2       2.60  2.93   3.21   3.40   3.46   3.62
%                      3       2.48  2.84   3.12   3.35   3.41   3.58
%                      4       2.49  2.82   3.05   3.29   3.37   3.52
%            4         1       2.40  2.67   2.94   3.20   3.26   3.47
%                      2       2.64  2.94   3.18   3.40   3.45   3.66
%                      3       2.40  2.64   2.86   3.09   3.16   3.38
%          -----------------------------------------------------------
%                                       
%     Data matrix must be:
% X=[2.56 1 1 1;2.77 1 1 2;2.94 1 1 3;3.14 1 1 4;3.18 1 1 5;3.33 1 1 6;2.64 1 2 1;2.89 1 2 2;3.09 1 2 3;3.26 1 2 4;3.33 1 2 5;3.47 1 2 6;
% 2.94 1 3 1;3.18 1 3 2;3.33 1 3 3;3.50 1 3 4;3.50 1 3 5;3.66 1 3 6;2.56 1 4 1;2.83 1 4 2;3.04 1 4 3;3.22 1 4 4;3.26 1 4 5;3.37 1 4 6;
% 2.64 1 5 1;2.77 1 5 2;2.94 1 5 3;3.14 1 5 4;3.22 1 5 5;3.30 1 5 6;2.56 1 6 1;2.77 1 6 2;2.94 1 6 3;3.14 1 6 4;3.18 1 6 5;3.26 1 6 6;
% 2.56 2 1 1;2.83 2 1 2;3.07 2 1 3;3.26 2 1 4;3.33 2 1 5;3.51 2 1 6;2.44 2 2 1;2.74 2 2 2;3.02 2 2 3;3.20 2 2 4;3.28 2 2 5;3.44 2 2 6;
% 2.34 2 3 1;2.67 2 3 2;2.91 2 3 3;3.16 2 3 4;3.22 2 3 5;3.39 2 3 6;2.41 2 4 1;2.71 2 4 2;2.94 2 4 3;3.16 2 4 4;3.21 2 4 5;3.36 2 4 6;
% 2.46 3 1 1;2.83 3 1 2;3.09 3 1 3;3.32 3 1 4;3.37 3 1 5;3.54 3 1 6;2.60 3 2 1;2.93 3 2 2;3.21 3 2 3;3.40 3 2 4;3.46 3 2 5;3.62 3 2 6;
% 2.48 3 3 1;2.84 3 3 2;3.12 3 3 3;3.35 3 3 4;3.41 3 3 5;3.58 3 3 6;2.49 3 4 1;2.82 3 4 2;3.05 3 4 3;3.29 3 4 4;3.37 3 4 5;3.52 3 4 6;
% 2.40 4 1 1;2.67 4 1 2;2.94 4 1 3;3.20 4 1 4;3.26 4 1 5;3.47 4 1 6;2.64 4 2 1;2.94 4 2 2;3.18 4 2 3;3.40 4 2 4;3.45 4 2 5;3.66 4 2 6;
% 2.40 4 3 1;2.64 4 3 2;2.86 4 3 3;3.09 4 3 4;3.16 4 3 5;3.38 4 3 6];
%
% Calling on Matlab the function: 
%             RMAOV1MS(X)
%
% Answer is:
%
% The number of groups are: 4
% The maximum number of subjects in a group are: 6
% The minimum number of subjects in a group are: 3
% The number of IV levels are: 6
%
% ANOVA table for repeated measures single-factor multiple samples.
% ------------------------------------------------------------------------------
% SOV                        SS          df          MS            F        P       
% ------------------------------------------------------------------------------
% Groups                   0.2038         3        0.0679         0.87   0.4798
% Subjts(Gps.)             1.0108        13        0.0778
% IV                      10.0745         5        2.0149      3198.78   0.0000
% Group x IV               0.2045        15        0.0136        21.64   0.0000
% Residual                 0.0409        65        0.0006
% ------------------------------------------------------------------------------
% Total                   11.5344       101
% ------------------------------------------------------------------------------
% If the P results are smaller than 0.05
% the corresponding Ho's tested result statistically significant. Otherwise,
% are not significative.
%
% Created by A. Trujillo-Ortiz, R. Hernandez-Walls, K. Barba-Rojo and 
%            A. Castro-Perez
%            Facultad de Ciencias Marinas
%            Universidad Autonoma de Baja California
%            Apdo. Postal 453
%            Ensenada, Baja California
%            Mexico.
%            atrujo@uabc.mx
%
% Copyright.December 13, 2006.
%
% To cite this file, this would be an appropriate format:
% Trujillo-Ortiz, A., R. Hernandez-Walls, K. Barba-Rojo and A. Castro-Perez. (2006).
%   RMAOV1MS:Repeated measures single-factor analysis of variance multiple samples test.
%   A MATLAB file. [WWW document]. URL http://www.mathworks.com/matlabcentral/
%   fileexchange/loadFile.do?objectId=13380
%
% Reference:
%    Davis, S. Ch. (2002), Statistical Methods for the Analysis of Repeated
%             Measurements. Springer-Verlag:New York. Chapter 5.
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

a = max(X(:,2)); %Number of groups.
b = max(X(:,3)); %Maximum number of subjects in a group.
t = max(X(:,4)); %Number of levels of independent variable.
     
indice = X(:,2);
for i = 1:a
   Xe = find(indice==i);
   eval(['G' num2str(i) ' = X(Xe,1);']);
end
indice = X(:,4);
for k = 1:t
    Xe = find(indice==k);
    eval(['IV' num2str(k) '=X(Xe,1);']);
end

C = (sum(X(:,1)))^2/length(X(:,1));  %Correction term.
SSTO = sum(X(:,1).^2)-C;  %Total sum of squares.
dfTO = length(X(:,1))-1;  %Total degrees of freedom.

for i = 1:a
   for j = 1:b
      Xe = find((X(:,2)==i) & (X(:,3)==j));
      eval(['T' num2str(i) num2str(j) ' = X(Xe,1);']);
   end
end

for i = 1:a
    for k = 1:t
        Xe = find((X(:,2)==i) & (X(:,4)==k));
        eval(['GI' num2str(i) num2str(k) '=X(Xe,1);']);
     end
end
 
%Procedure related to the subjects in groups.
NSG = [];
for i = 1:a
   for j = 1:b
   eval(['n' num2str(i) num2str(j) ' = length(T' num2str(i) num2str(j) ');'])
   eval(['x =  n' num2str(i) num2str(j) ';'])
   NSG = [NSG,x];  
   end
end

%Due it is an unequal sample sizes design, some subgroups arithmetic operations 
%could been not-a-number (like 0.0/0.0). So it is necessary to make the estimations
%ignoring NaNs.
warning off;
SG = [];
for i = 1:a
   for j = 1:b
   eval(['x = ((sum(T' num2str(i) num2str(j) ').^2)/length(T' num2str(i) num2str(j) '));'])
   SG = [SG,x];
   nans = isnan(SG);
   r = find(nans);
   SG(r) = zeros(size(r));
   end
end
warning on;
SSSG = sum(SG)-C;
dfSG = (a*b)-1;

%Procedure related to the groups.
G = [];
for i = 1:a
   eval(['x = ((sum(G' num2str(i) ').^2)/length(G' num2str(i) '));'])
   G = [G,x];
end
SSG = sum(G)-C;
dfG = a-1;
MSG = SSG/dfG;

%Procedure related to the IV (independent variable).    
IV = [];
for k = 1:t
    eval(['x =((sum(IV' num2str(k) ').^2)/length(IV' num2str(k) '));']);
    IV = [IV,x];
 end
SSIV = sum(IV)-C;  %sum of squares for the IV
dfIV = t-1;  %degrees of freedom for the IV
MSIV = SSIV/dfIV;  %mean square for the IV

%Procedure related to the interaction group-independent variable.
GI = [];
for i = 1:a
    for k = 1:t
        eval(['x =((sum(GI' num2str(i) num2str(k) ').^2)/length(GI' num2str(i) num2str(k) '));']);
        GI = [GI,x];
     end
 end
SSGI = sum(GI)-sum(G)-sum(IV)+C;  %sum of squares of the Group x IV
dfGI = dfG*dfIV;  %degrees of freedom of the Group x IV
MSGI = SSGI/dfGI;  %mean square for the Group x IV

%Procedure for estimation of sample size for unequal sample sizes.
no1 = []; no2 = [];  
for i = 1:a
    for j = 1:b
        eval(['x = length(T' num2str(i) num2str(j) ');']);
        no1 = [no1,x];
        eval(['x = length(T' num2str(i) num2str(j) ').^2;']);
        no2 = [no2,x];
    end
end

%Procedure related to the within subgroups (error).
SSE = SSTO-SSSG;
nneg = length(find((no1-1)<0));
dfE = sum(no1-1)+nneg;
MSE = SSE/dfE;

%Procedure related to the among subgroups within groups.
SSSGG = SSTO-SSG-SSE;
dfSGG = dfTO-dfG-dfE;
MSSGG = SSSGG/dfSGG;

%Procedure related to the residual.
SSR = SSTO-SSG-SSSGG-SSIV-SSGI; 
dfR = dfTO-dfG-dfSGG-dfIV-dfGI;
MSR = SSR/dfR;

fprintf('The number of groups are:%2i\n', a);
fprintf('The maximum number of subjects in a group are:%2i\n', b);
c = min(full(sum(spones(reshape(no2,b,a))))); %Minimum number of subjects in a group.
fprintf('The minimum number of subjects in a group are:%2i\n', c);
fprintf('The number of IV levels are:%2i\n\n', t);
FG = MSG/MSSGG;
FIV = MSIV/MSR;
FGI = MSGI/MSR;
PrG = 1 - fcdf(FG,dfG,dfSGG);  %Probability associated to the groups F statistic.
PrIV = 1 - fcdf(FIV,dfIV,dfR);  %Probability associated to the IV F statistic.
PrGI = 1 - fcdf(FGI,dfGI,dfR); %Probability associated to the interaction group-IV F statistic.
disp('ANOVA table for repeated measures single-factor multiple samples.')
fprintf('------------------------------------------------------------------------------\n');
disp('SOV                        SS          df          MS            F        P       ')
fprintf('------------------------------------------------------------------------------\n');
fprintf('Groups       %18.4f%10i%14.4f%13.2f%9.4f\n',SSG,dfG,MSG,FG,PrG);
fprintf('Subjts(Gps.)%19.4f%10i%14.4f\n',SSSGG,dfSGG,MSSGG);
fprintf('IV    %25.4f%10i%14.4f%13.2f%9.4f\n',SSIV,dfIV,MSIV,FIV,PrIV);
fprintf('Group x IV %20.4f%10i%14.4f%13.2f%9.4f\n',SSGI,dfGI,MSGI,FGI,PrGI);
fprintf('Residual %22.4f%10i%14.4f\n',SSR,dfR,MSR);
fprintf('------------------------------------------------------------------------------\n');
fprintf('Total %25.4f%10i\n',SSTO,dfTO);
fprintf('------------------------------------------------------------------------------\n');
fprintf('If the P results are smaller than% 3.2f\n', alpha );
disp('the corresponding Ho''s tested result statistically significant. Otherwise,');
disp('are not significative.');
disp('     ')

return,