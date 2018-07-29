function cufd22(D,alpha)
% CUFD22 Testing for Curvature of a 2^2 Factorial Design Analysis.
%  This m-file is used in experiments where there is uncertain about the
%  assumption of linearity over the region of exploration, and when the
%  experimenter decides to conduct a 2^2 factorial design with a single
%  or several replicates of each factorial run, augmented with some center
%  points. A formal analysis of variance is running in order to see if
%  there is evidence of curvature in the response over the region of
%  exploration. The result can gives indication of some quadratic effects
%  (second-order model) or not (first-order model).
%
%  The formal curvature sum of squares in the analysis of variance is computed
%  as follows,
%
%    SSU = nf*nc*(mean of factorial points - mean of center points)^2/(nf+nc)
%
%  where nf is the number of points in the factorial portion and nc the number
%  of points at the center.
%  For the mean square (MSU) SSU must divide by 1 degrees of freedom.
%
%  The mean of squares error is calculated from the center points as follows,
%
%           SSE = Sum_nc(y_center points - mean of center ponts)^2
%
%  So,
%
%                             MSE = SSE/(nc-1)
%
%  Next figure illustrates the four-factor level or treatment combinations
%  and some center points on a 2^2 factorial design.
%
%                           b                 ab
%                       2   .------------------.
%                           |                  |
%                           |                  |
%                           |                  |
%      Level Factor B       |        . (nc)    |
%                           |                  |
%                           |                  |
%                           |                  |
%                       1   .------------------.
%                          (1)                 a
%
%                           1                  2
%                              Level Factor A
%
%
%  Syntax: cufd22(D,alpha) 
%      
%  Inputs:
%       D - matrix data (=[X Y]) (last column must be the Y-dependent variable).
%           (X-independent variable entry for the 2^2 factorial design).
%   alpha - significance-value (default = 0.05).
%
%  Outputs:
%       A complete analysis of variance is summarized on a table.
%
%  From the example 3.4 of Myers and Montgomery (2002, p.130), a chemical engineer is
%  studing the yield of a process. There are two variables of interest as reaction
%  time (A: 1=30, 2=40, 0=35 min) and reaction temperature (B: 1=150, 2=160, 0=155 
%  C degrees). Due that the engineer has uncertain about the assumption of linearity,
%  decides to conduct a 2^2 design with a single replicate on each factorial run and
%  with 5 center points. The data are as follow,
%
%                                     -------------
%          Factor-level combination       Yield 
%               A         B
%          ----------------------------------------
%               1         1               39.3       
%               1         2               40.9    
%               2         1               40.0    
%               2         2               41.5
%               0         0               40.3
%               0         0               40.5
%               0         0               40.7
%               0         0               40.2
%               0         0               40.6
%          ----------------------------------------
%
%  Data matrix must be:
%  D=[1 1 39.3;1 2 40.9;2 1 40;2 2 41.5;0 0 40.3;0 0 40.5;0 0 40.7;
%    0 0 40.2;0 0 40.6];
%
%  Calling on Matlab the function: 
%             cufd22(D)
%
%  Answer is:
%
%  Analysis of Variance of the 2^2 Factorial Design for the Curvature Test.
%  ----------------------------------------------------------------------------------------------
%   SOV             SS             df           MS               F             P      Conclusion
%  ----------------------------------------------------------------------------------------------
%  A                 2.4025         1            2.4025       55.8721        0.0017        S
%  B                 0.4225         1            0.4225        9.8256        0.0350        S
%  AB                0.0025         1            0.0025        0.0581        0.8213       NS
%  Curvature         0.0027         1            0.0027        0.0633        0.8137       NS
%  Error             0.1720         4            0.0430
%  ----------------------------------------------------------------------------------------------
%  Total             3.0022         8
%  ----------------------------------------------------------------------------------------------
%  Number of replicates on each factor-level are: 1
%  With a given significance level of: 0.05
%  The results are significant (S) and/or not significant (NS).
%
%  Created by A. Trujillo-Ortiz, R. Hernandez-Walls and F.A. Trujillo-Perez
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.mx
%  Copyright (C) December 26, 2005.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A., R. Hernandez-Walls, F.A. Trujillo-Perez. (2005). CUFD22:2^2 Testing for Curvature
%  of a 2^2 Factorial Design Analysis. A MATLAB file. [WWW document]. URL http://www.mathworks.com/
%  matlabcentral/fileexchange/loadFile.do?objectId=9461
%
%  References:
%  Myers, R. H. and Montgomery, D. C. (2002), Response Surface Methodology:Process and Product
%          Optimization Using Designed Experiments. 2nd. Ed. NY: John Wiley & Sons, Inc.
%

if nargin < 2,
    alpha = 0.05; %(default)
end; 

if (alpha <= 0 | alpha >= 1),
    disp('  ');
    fprintf('Warning: significance level must be between 0 and 1\n');
    return;
end;

if (length(find(D(:,1)==1))~=length(find(D(:,1)==2)))|(length(find(D(:,2)==1))~=length(find(D(:,2)==2))),
    disp('  ');
    disp('''Warning: Some of the factor-level combination(s) has(have) different number of replicates.''');
    disp('Please, check it.');
    return;
end;

if size(D,2)-1 ~= 2,
    disp('  ');
    disp('''Warning: The number of factors must be two.''');
    disp('Please, check it.');
    return;
end;    

N = size(D,1); %total number of observations

n = length(find(D(:,1)==1))/2; %number of replicates

nc = length(find(D(:,1)==0)); %number of central points

nf = N-nc; %number of factorial points

Y = D(:,end);

O = sum(Y(1:n)); %factor-level combination 1 (low level A-low level B)
a = sum(Y(n+1:2*n)); %factor-level combination 2 (high level A-low level B)
b = sum(Y((2*n)+1:3*n)); %factor-level combination 3 (low level A-high level B)
ab = sum(Y((3*n)+1)); %factor-level combination 4 (high level A-high level B)

CA = ab+a-b-O; %contrast of the total effect of A
CB = ab+b-a-O; %contrast of the total effect of B
CAB = ab+O-a-b; %contrast of the total effect of AB

A = (1/(2*n))*CA; %average effect of A
B = (1/(2*n))*CB; %average effect of B
AB = (1/(2*n))*CAB; %average effect of AB

SSA = CA^2/(n*4); %sum of squares of A
SSB = CB^2/(n*4); %sum of squares of B
SSAB = CAB^2/(n*4); %sum of squares of AB
SSTo = sum(Y.^2)-(sum(Y)^2/N); %total sum of squares
SSU = (nf*nc)*(sum(Y(1:nf)/nf)-(sum(Y((4*n)+1:end))/nc))^2/N; %curvature sum of squares (formal)
SSE = SSTo-SSA-SSB-SSAB-SSU; %error sum of squares
%SSE = sum(((Y((4*n)+1:end))-repmat((sum(Y((4*n)+1:end))/nc),nc,1)).^2); %error sum of squares (formal)
%SSU = SSTo-SSA-SSB-SSAB-SSE; %curvature sum of squares

dfA = max(D(:,1)-1); %degrees of freedom of A
dfB = max(D(:,2)-1); %degrees of freedom of B
dfAB = dfA*dfB; %degrees of freedom of AB
dfTo = N-1; %total degrees of freedom
dfU = 1; %curvature degrees of freedom (formal)
dfE = dfTo-dfA-dfB-dfAB-dfU; %error degrees of freedom
%dfE = nc-1; %error degrees of freedom (formal)
%dfU = dfTo-dfA-dfB-dfAB-dfE; %curvature degrees of freedom

MSA = SSA/dfA; %mean square of A
MSB = SSB/dfB; %mean square of B
MSAB = SSAB/dfAB; %mean square of AB
MSE = SSE/dfE; %error mean square
MSU = SSU/dfU; %curvature mean square

FA = MSA/MSE;
PA = 1 - fcdf(FA,dfA,dfE);
FB = MSB/MSE;
PB = 1 - fcdf(FB,dfB,dfE);
FAB = MSAB/MSE;
PAB = 1 - fcdf(FAB,dfAB,dfE);
FU = MSU/MSE;
PU = 1 - fcdf(FU,dfU,dfE);

if PA >= alpha;
    dsA ='NS';
else
    dsA =' S';
end;
if  PB >= alpha;
    dsB ='NS';
else
    dsB =' S';
end;
if  PAB >= alpha;
    dsAB ='NS';
else
    dsAB =' S';
end;
if  PU >= alpha;
    dsU ='NS';
else
    dsU =' S';
end;

disp('  ')
disp('Analysis of Variance of the 2^2 Factorial Design for the Curvature Test.')
fprintf('----------------------------------------------------------------------------------------------\n');
disp(' SOV             SS             df           MS               F             P      Conclusion');
fprintf('----------------------------------------------------------------------------------------------\n');
fprintf('A            %11.4f%10i%18.4f%14.4f%14.4f%9s\n',SSA,dfA,MSA,FA,PA,dsA);
fprintf('B            %11.4f%10i%18.4f%14.4f%14.4f%9s\n',SSB,dfB,MSB,FB,PB,dsB);
fprintf('AB           %11.4f%10i%18.4f%14.4f%14.4f%9s\n',SSAB,dfAB,MSAB,FAB,PAB,dsAB);
fprintf('Curvature    %11.4f%10i%18.4f%14.4f%14.4f%9s\n',SSU,dfU,MSU,FU,PU,dsU);
fprintf('Error        %11.4f%10i%18.4f\n',SSE,dfE,MSE);
fprintf('----------------------------------------------------------------------------------------------\n');
fprintf('Total        %11.4f%10i\n',SSTo,dfTo);
fprintf('----------------------------------------------------------------------------------------------\n');
fprintf('Number of replicates on each factor-level are: %i\n', n);
fprintf('With a given significance level of: %.2f\n', alpha);
disp('The results are significant (S) and/or not significant (NS).');

return;
