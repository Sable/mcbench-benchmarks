function [MAOV2] = MAOV2(X,alpha)
% MAOV2 Two-Way Multivariate Analysis of Variances test.
%Computes a two-way Multivariate Analysis of Variance for equal or unequal sample sizes.
%[Testing of the mean differences in several variables among several samples with two factors.
%It consider the matrices of sum-of-squares between (H) and within (E) for main effects and
%their interaction to compute, respectively, their Wilks'L (lambda) and according to the number
%of data it chooses to approximate to the Chi-square distribution (large samples: n >= 25) or 
%through several multiple F-approximations such as Rao, Pillai, Lawley-Hotelling and Roy tests
%(small samples: n < 25).]
%
%   Syntax: function [MAOV2] = MAOV2(X,alpha) 
%      
%     Inputs:
%          X - data matrix (Size of matrix must be n-by-(2+p); factor 1=column 1; factor 2=column 2, 
%              variables=column 3:p). 
%      alpha - significance (default = 0.05).
%     Outputs:
%            - A complete multivariate analysis of variance table for each factor and their
%              interaction.
%
%    Example: From the example 6.4 of Johnson and Wichern (1992, pp. 266-271), we are
%             interested to test a multivariate two-way analysis of variance of data 
%             (n = 20; p = 3) with a significance of 0.05.
%
%                                    Data
%                      --------------------------------
%                        Factor           Variable
%                      --------------------------------
%                       1      2      X1     X2     X3
%                      --------------------------------
%                       1      1     6.5    9.5    4.4
%                       1      1     6.2    9.9    6.4
%                       1      1     5.8    9.6    3.0
%                       1      1     6.5    9.6    4.1
%                       1      1     6.5    9.2    0.8
%                       1      2     6.9    9.1    5.7
%                       1      2     7.2   10.0    2.0
%                       1      2     6.9    9.9    3.9
%                       1      2     6.1    9.5    1.9
%                       1      2     6.3    9.4    5.7
%                       2      1     6.7    9.1    2.8
%                       2      1     6.6    9.3    4.1
%                       2      1     7.2    8.3    3.8
%                       2      1     7.1    8.4    1.6
%                       2      1     6.8    8.5    3.4
%                       2      2     7.1    9.2    8.4
%                       2      2     7.0    8.8    5.2
%                       2      2     7.2    9.7    6.9
%                       2      2     7.5   10.1    2.7
%                       2      2     7.6    9.2    1.9
%                      --------------------------------
%
%     Data matrix must be:
%        X=[1 1 6.5 9.5 4.4;1 1 6.2 9.9 6.4;1 1 5.8 9.6 3.0;1 1 6.5 9.6 4.1;1 1 6.5 9.2 0.8;
%        1 2 6.9 9.1 5.7;1 2 7.2 10.0 2.0;1 2 6.9 9.9 3.9;1 2 6.1 9.5 1.9;1 2 6.3 9.4 5.7;
%        2 1 6.7 9.1 2.8;2 1 6.6 9.3 4.1;2 1 7.2 8.3 3.8;2 1 7.1 8.4 1.6;2 1 6.8 8.5 3.4;
%        2 2 7.1 9.2 8.4;2 2 7.0 8.8 5.2;2 2 7.2 9.7 6.9;2 2 7.5 10.1 2.7;2 2 7.6 9.2 1.9];
%
%     Calling on Matlab the function: 
%             maov2(X)
%
%     Answer is:
%
%   It is considering as a small sample problem (n < 25).
%   Interaction will carried out before the tests for main effects.
% 
%   Multivariate Analysis of Variance Table for Interaction AB.
%   -------------------------------------------
%   No. data    Levels      Variables       L
%   -------------------------------------------
%      20          4            3        0.7771
%   -------------------------------------------
% 
%   ------------------------------------------------------------------------------
%   Test                 Statistic     df1     df2         F       P    Conclusion
%   ------------------------------------------------------------------------------
%   Rao                    0.777         3      14       1.34   0.3018      NS
%   Pillai                 0.223         3      14       1.34   0.3018      NS
%   Lawley-Hotelling       0.287         3      14       1.34   0.3018      NS
%   Roy                    0.287       3.0    14.0       1.34   0.3018      NS
%   ------------------------------------------------------------------------------
%   With a given significance of: 0.05
%   According to the P-value, the interaction effects could be significant (S) or
%   not significant (NS).
%  
%   If interaction effects exist, the factor effects do not have a clear interpretation.
%   So, from a practical standpoint, it is not advisable to proceed with the additional
%   multivariate tests. Instead, p univariate two-way analyses of variance (one for each
%   variable) should be conducted to see if the interaction appears in some responses but
%   not others. Those responses without interaction may be interpreted in terms of additive
%   factor 1 and factor 2, provided the latter effects exist.
%  
%   Do you want to proceed with the additional multivariate tests anyway? (y/n):y
% 
%   Multivariate Analysis of Variance Table for Factor A.
%   --------------------------------------------
%   No. data    Levels      Variables       L
%   --------------------------------------------
%      20          2            3        0.3819
%   --------------------------------------------
% 
%   ------------------------------------------------------------------------------
%   Test                 Statistic     df1     df2         F       P    Conclusion
%   ------------------------------------------------------------------------------
%   Rao                    0.382         3      16       8.63   0.0012       S
%   Pillai                 0.618         3      14       7.55   0.0030       S
%   Lawley-Hotelling       1.619         3      14       7.55   0.0030       S
%   Roy                    1.619       3.0    14.0       7.55   0.0030       S
%   ------------------------------------------------------------------------------
%   With a given significance of: 0.05
%   According to the P-value, the mean vectors of factor A could be significant (S) or
%   not significant (NS).
% 
%   Multivariate Analysis of Variance Table for Factor B.
%   --------------------------------------------
%   No. data    Levels      Variables       L
%   --------------------------------------------
%      20          2            3        0.5230
%   --------------------------------------------
% 
%   ------------------------------------------------------------------------------
%   Test                 Statistic     df1     df2         F       P    Conclusion
%   ------------------------------------------------------------------------------
%   Rao                    0.523         3      13       3.95   0.0332       S
%   Pillai                 0.477         3      14       4.26   0.0030       S
%   Lawley-Hotelling       0.912         3      14       4.26   0.0247       S
%   Roy                    0.912       3.0    14.0       4.26   0.0247       S
%   ------------------------------------------------------------------------------
%   With a given significance of: 0.05
%   According to the P-value, the mean vectors of factor B could be significant (S) or
%   not significant (NS).
%

%  Created by A. Trujillo-Ortiz and R. Hernandez-Walls
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.mx
%
%  October 17, 2003.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A. and R. Hernandez-Walls. (2003). MAOV2: Two-Factor Multivariate Anaysis of 
%    Variance Test. A MATLAB file. [WWW document]. URL http://www.mathworks.com/matlabcentral/
%    fileexchange/loadFile.do?objectId=4073&objectType=FILE
%
%  References:
% 
%  Boik, J. R. (2002). Lecture Notes: Statistics 537. Classical Multivariate Analysis.
%              Spring 2002. pp. 38-41. [WWW document]. URL http://math.montana.edu/~rjboik/
%              classes/537/notes_537.pdf
%  Johnson, D. E. (1998), Applied Multivariate Methods for Data Analysis.
%              New-York:Brooks Cole Publishing Co., an ITP Company. Chapter 11.
%  Johnson, R. A. and Wichern, D. W. (1992), Applied Multivariate Statistical Analysis.
%              3rd. ed. New-Jersey:Prentice Hall. pp. 266-271.
%

PA = [];PB = [];PAB = [];PPA = [];PPB = [];PPAB = [];PLHA = [];PLHB = [];
PLHAB = [];PRA = [];PRB = [];PRAB = [];

if nargin < 2,
   alpha = 0.05;
end; 

Y = X;

a = max(X(:,1));  %number of levels factor A
b = max(X(:,2));  %number of levels factor B

[r,c] = size(X);

X = X(:,3:c);
[n,p] = size(X);

if p > a*b*(n-1);
   fprintf('Warning: likelihood ratio procedures require the number of independent variables: %2i\n', p);
   fprintf('must be <= error degrees of freedom: %2i\n', a*b*(n-1));
   disp('So that error sum of squares matrix will be positive definite.');
   return;
end;   

dT=[];
for k=1:p
   eval(['dT  = [dT,(X(:,k) - mean(X(:,k)))];']);
end;
T=dT'*dT;  %total sum of squares

X = Y;
[r,c] = size(X);
f = r;
HA = [];HB = [];HAB = [];
M=mean(X(:,3:c))';

sumA = zeros(p,p);
sumB = zeros(p,p);
sumAB = zeros(p,p);

indice = X(:,1);  %sum of squares between factor A
for i = 1:a
   Xe = find(indice==i);
   eval(['A' num2str(i) '=X(Xe,3:c);']);
   eval(['mA' num2str(i) '=mean(X(Xe,3:c));']);
   eval(['sumA= sumA + length(A' num2str(i) ')*((mA' num2str(i) ')''-M)*((mA' num2str(i) ')''-M)'';']);
   HA = [sumA];
end;

indice = X(:,2);  %sum of squares between factor B
for j = 1:b
   Xe = find(indice==j);
   eval(['B' num2str(j) '=X(Xe,3:c);']);
   eval(['mB' num2str(j) '=mean(X(Xe,3:c));']);
   eval(['sumB= sumB + length(B' num2str(j) ')*((mB' num2str(j) ')''-M)*((mB' num2str(j) ')''-M)'';']);
   HB = [sumB];
end;

for i = 1:a  %sum of squares of interaction AB
   for j = 1:b
      Xe = find((X(:,1)==i)&(X(:,2)==j));
      eval(['AB' num2str(i)  num2str(j) '=X(Xe,3:c);']);
      eval(['mAB' num2str(i)  num2str(j) '=mean(X(Xe,3:c));']);
      eval(['sumAB= sumAB + length(AB' num2str(i)  num2str(j) ')*((mAB' num2str(i)  num2str(j) ')''-(mA' num2str(i) ')''-(mB' num2str(j) ')''+M)*((mAB' num2str(i)  num2str(j) ')''-(mA' num2str(i) ')''-(mB' num2str(j) ')''+M)'';']);
      HAB = [sumAB];
   end;
end;

H = HA+HB+HAB;  %sum of squares between factors A and B
E = T-H;  %within samples sum of squares
LWA = det(E)/det(HA+E);  %Wilks'lambda of factor A
LWB = det(E)/det(HB+E);  %Wilks'lambda of factor B
LWAB = det(E)/det(HAB+E);  %Wilks'lambda of interaction AB

if f >= 25;  %approximation to chi-square statistic
   disp('It is considering as a large sample problem (n >= 25).')  
   disp('Interaction will carried out before the tests for main effects.');   
   vAB = p*(a-1)*(b-1);
   X2AB = (-1)*(((f-(a*b))-(.5*(p+1-((a-1)*(b-1)))))*log(LWAB));
   PX2AB = 1-chi2cdf(X2AB,vAB);
   disp(' ')
   disp('Multivariate Analysis of Variance Table for Interaction AB.')
   fprintf('-----------------------------------------------------------------------------------\n');
   disp('No. data    Levels      Variables       L          Chi-sqr.         df          P')
   fprintf('-----------------------------------------------------------------------------------\n');
   fprintf('%5.i%11.i%13.i%14.4f%15.4f%12.i%13.4f\n',f,a*b,p,LWAB,X2AB,vAB,PX2AB);
   fprintf('-----------------------------------------------------------------------------------\n');
   fprintf('With a given significance of: %.2f\n', alpha);
   if PX2AB >= alpha;
      disp('The interaction effects results not significant.');
   else
      disp('The interaction effects results significant.');
   end;
   disp('  ');
   disp('If interaction effects exist, the factor effects do not have a clear interpretation.');
   disp('So, from a practical standpoint, it is not advisable to proceed with the additional');
   disp('multivariate tests. Instead, p univariate two-way analyses of variance (one for each');
   disp('variable) should be conducted to see if the interaction appears in some responses but');
   disp('not others. Those responses without interaction may be interpreted in terms of additive');
   disp('factor 1 and factor 2, provided the latter effects exist.');
   disp('  ');
   op = input('Do you want to proceed with the additional multivariate tests anyway? (y/n):','s');
   if op == 'y';
      
      vA = p*(a-1);
      X2A = (-1)*(((f-(a*b))-(.5*(p+1-(a-1))))*log(LWA));
      PX2A = 1-chi2cdf(X2A,vA);
      disp('Multivariate Analysis of Variance Table for Factor A.')
      fprintf('-----------------------------------------------------------------------------------\n');
      disp('No. data    Levels      Variables       L          Chi-sqr.         df          P')
      fprintf('-----------------------------------------------------------------------------------\n');
      fprintf('%5.i%11.i%13.i%14.4f%15.4f%12.i%13.4f\n',f,a,p,LWA,X2A,vA,PX2A);
      fprintf('-----------------------------------------------------------------------------------\n');
      fprintf('With a given significance of: %.2f\n', alpha);
      if PX2A >= alpha;
         disp('Mean vectors of factor A results not significant.');
      else
         disp('Mean vectors of factor A results significant.');
      end;
      
      vB = p*(b-1);
      X2B = (-1)*(((f-(a*b))-(.5*(p+1-(b-1))))*log(LWB));
      PX2B = 1-chi2cdf(X2B,vB);
      disp(' ')
      disp('Multivariate Analysis of Variance Table for Factor B.')
      fprintf('-----------------------------------------------------------------------------------\n');
      disp('No. data    Levels      Variables       L          Chi-sqr.         df          P')
      fprintf('-----------------------------------------------------------------------------------\n');
      fprintf('%5.i%11.i%13.i%14.4f%15.4f%12.i%13.4f\n',f,b,p,LWB,X2B,vB,PX2B);
      fprintf('-----------------------------------------------------------------------------------\n');
      fprintf('With a given significance of: %.2f\n', alpha);
      if PX2B >= alpha;
         disp('Mean vectors of factor B results not significant.');
      else
         disp('Mean vectors of factor B results significant.');
      end;
      
   else
      return;
   end;
   
else  
   %approximation to Wilk's lambda to Rao's F-statistic
   disp('It is considering as a small sample problem (n < 25).')
   disp('Interaction will carried out before the tests for main effects.');   
   %procedure for interaction AB
   if p == 2 | (a-1)*(b-1) == 2
      sAB = 2;
   else
      sAB = sqrt((p^2*((a-1)*(b-1)^2)-4)/(p^2+((a-1)*(b-1)^2)-5));
   end;
   
   v1AB = p*((a-1)*(b-1));
   v2AB = (sAB*((f-(a*b))-((p-((a-1)*(b-1))+1)/2)))-(((p*(a-1)*(b-1))-2)/2);
   vAB = LWAB^(1/sAB);
   FAB = ((1-vAB)/vAB)*(v2AB/v1AB);
   PAB = 1-fcdf(FAB,v1AB,v2AB);
   
   %Pillai's test (Trace test) for interaction AB
   VAB = trace(inv(HAB+E)*HAB);
   q =( a-1)*(b-1);
   s = min(p,q);
   v = f-(a*b);
   r = (v-((p+q+1)/2));
   m = (abs(p-q)-1)/2;
   n = (v-p-1)/2;
   FPAB = (((2*n)+s+1)/((2*m)+s+1))*(VAB/(s-VAB));
   v1PAB = s*((2*m)+s+1);
   v2PAB = s*((2*n)+s+1);
   PPAB = 1-fcdf(FPAB,v1PAB,v2PAB);
   
   %Lawley-Hotelling's trace test for interaction AB
   UAB = trace(inv(E)*HAB);
   FLHAB = (2*((s*n)+1)*UAB)/(s^2*((2*m)+s+1));
   v1LHAB = s*((2*m)+s+1);
   v2LHAB = 2*((s*n)+1);
   PLHAB = 1-fcdf(FLHAB,v1LHAB,v2LHAB);
   
   %Roy's Union_intersection test (Largest root test) for interaction AB
   RAB = max(eig(inv(E)*HAB));
   r = max(p,q);
   FRAB = RAB*((v-r+q)/r);
   v1RAB = r;
   v2RAB = v-r+q;
   % Because the numerator and denominator degrees of freedom could results a fraction,
   % the probability function associated to the F statistic is resolved by the Simpson's
   % 1/3 numerical integration method.
   x = linspace(.000001,FRAB,100001);
   DF = x(2)-x(1);
   y = ((v1RAB/v2RAB)^(.5*v1RAB)/(beta((.5*v1RAB),(.5*v2RAB))));
   y = y*(x.^((.5*v1RAB)-1)).*(((x.*(v1RAB/v2RAB))+1).^(-.5*(v1RAB+v2RAB)));
   N2 = length(x);
   PRAB = 1-(DF.*(y(1)+y(N2) + 4*sum(y(2:2:N2-1))+2*sum(y(3:2:N2-2)))/3.0);
   
   if PAB >= alpha;
      ds1AB ='NS';
   else
      ds1AB =' S';
   end;
   if  PPAB >= alpha;
      ds2AB ='NS';
   else
      ds2AB =' S';
   end;
   if  PLHAB >= alpha;
      ds3AB ='NS';
   else
      ds3AB =' S';
   end;
   if PRAB >= alpha;
      ds4AB ='NS';
   else
      ds4AB =' S';
   end;
   ;
   disp(' ')
   disp('Multivariate Analysis of Variance Table for Interaction AB.')
   fprintf('-------------------------------------------\n');
   disp('No. data    Levels      Variables       L')
   fprintf('-------------------------------------------\n');
   fprintf('%5.i%11.i%13.i%14.4f\n',f,a*b,p,LWAB);
   fprintf('-------------------------------------------\n');
   disp(' ')
   fprintf('------------------------------------------------------------------------------\n');
   disp('Test                 Statistic     df1     df2         F       P    Conclusion')
   fprintf('------------------------------------------------------------------------------\n');
   fprintf('Rao            %13.3f%10i%8i%11.2f%9.4f      %s\n',LWAB,v1AB,v2AB,FAB,PAB,ds1AB);
   fprintf('Pillai         %13.3f%10i%8i%11.2f%9.4f      %s\n',VAB,v1PAB,v2PAB,FPAB,PPAB,ds2AB);
   fprintf('Lawley-Hotelling      %6.3f%10i%8i%11.2f%9.4f      %s\n',UAB,v1LHAB,v2LHAB,FLHAB,PLHAB,ds3AB);
   fprintf('Roy            %13.3f%10.1f%8.1f%11.2f%9.4f      %s\n',RAB,v1RAB,v2RAB,FRAB,PRAB,ds4AB);
   fprintf('------------------------------------------------------------------------------\n');
   fprintf('With a given significance of:% 3.2f\n', alpha);
   disp('According to the P-value, the interaction effects could be significant (S) or'); 
   disp('not significant (NS).');
   if PAB >= alpha;
      ds1AB ='NS';
   else
      ds1AB =' S';
   end;
   disp('  ');
   disp('If interaction effects exist, the factor effects do not have a clear interpretation.');
   disp('So, from a practical standpoint, it is not advisable to proceed with the additional');
   disp('multivariate tests. Instead, p univariate two-way analyses of variance (one for each');
   disp('variable) should be conducted to see if the interaction appears in some responses but');
   disp('not others. Those responses without interaction may be interpreted in terms of additive');
   disp('factor 1 and factor 2, provided the latter effects exist.');
   disp('  ');
   op = input('Do you want to proceed with the additional multivariate tests anyway? (y/n):','s');
   if op == 'y';
      
      %procedure for factor A
      if p == 2 | (a-1) == 2
         sA = 2;
      else
         sA = sqrt((p^2*((a-1)^2)-4)/(p^2+((a-1)^2)-5));
      end;
      
      v1A = p*(a-1);
      v2A = (sA*((f-1)-((p+a)/2)))-(((p*(a-1))-2)/2);
      vA = LWA^(1/sA);
      FA = ((1-vA)/vA)*(v2A/v1A);
      PA = 1-fcdf(FA,v1A,v2A);
      
      %Pillai's test (Trace test) for factor A
      VA = trace(inv(HA+E)*HA);
      q = a-1;
      s = min(p,q);
      v = f-(a*b);
      m = (abs(p-q)-1)/2;
      n = (v-p-1)/2;
      FPA = (((2*n)+s+1)/((2*m)+s+1))*(VA/(s-VA));
      v1PA = s*((2*m)+s+1);
      v2PA = s*((2*n)+s+1);
      PPA = 1-fcdf(FPA,v1PA,v2PA);
      
      %Lawley-Hotelling's trace test for factor A
      UA = trace(inv(E)*HA);
      FLHA = (2*((s*n)+1)*UA)/(s^2*((2*m)+s+1));
      v1LHA = s*((2*m)+s+1);
      v2LHA = 2*((s*n)+1);
      PLHA = 1-fcdf(FLHA,v1LHA,v2LHA);
      
      %Roy's Union_intersection test (Largest root test) for factor A
      RA = max(eig(inv(E)*HA));
      r = max(p,q);
      FRA = RA*((v-r+q)/r);
      v1RA = r;
      v2RA = v-r+q;
      % Because the numerator and denominator degrees of freedom could results a fraction,
      % the probability function associated to the F statistic is resolved by the Simpson's
      % 1/3 numerical integration method.
      x = linspace(.000001,FRA,100001);
      DF = x(2)-x(1);
      y = ((v1RA/v2RA)^(.5*v1RA)/(beta((.5*v1RA),(.5*v2RA))));
      y = y*(x.^((.5*v1RA)-1)).*(((x.*(v1RA/v2RA))+1).^(-.5*(v1RA+v2RA)));
      N2 = length(x);
      PRA = 1-(DF.*(y(1)+y(N2) + 4*sum(y(2:2:N2-1))+2*sum(y(3:2:N2-2)))/3.0);
      
      if PA >= alpha;
         ds1A ='NS';
      else
         ds1A =' S';
      end;
      if  PPA >= alpha;
         ds2A ='NS';
      else
         ds2A =' S';
      end;
      if  PLHA >= alpha;
         ds3A ='NS';
      else
         ds3A =' S';
      end;
      if PRA >= alpha;
         ds4A ='NS';
      else
         ds4A =' S';
      end;
      ;
      disp(' ')
      disp('Multivariate Analysis of Variance Table for Factor A.')
      fprintf('--------------------------------------------\n');
      disp('No. data    Levels      Variables       L')
      fprintf('--------------------------------------------\n');
      fprintf('%5.i%11.i%13.i%14.4f\n',f,a,p,LWA);
      fprintf('--------------------------------------------\n');
      disp(' ')
      fprintf('------------------------------------------------------------------------------\n');
      disp('Test                 Statistic     df1     df2         F       P    Conclusion')
      fprintf('------------------------------------------------------------------------------\n');
      fprintf('Rao            %13.3f%10i%8i%11.2f%9.4f      %s\n',LWA,v1A,v2A,FA,PA,ds1A);
      fprintf('Pillai         %13.3f%10i%8i%11.2f%9.4f      %s\n',VA,v1PA,v2PA,FPA,PPA,ds2A);
      fprintf('Lawley-Hotelling      %6.3f%10i%8i%11.2f%9.4f      %s\n',UA,v1LHA,v2LHA,FLHA,PLHA,ds3A);
      fprintf('Roy            %13.3f%10.1f%8.1f%11.2f%9.4f      %s\n',RA,v1RA,v2RA,FRA,PRA,ds4A);
      fprintf('------------------------------------------------------------------------------\n');
      fprintf('With a given significance of:% 3.2f\n', alpha);
      disp('According to the P-value, the mean vectors of factor A could be significant (S) or'); 
      disp('not significant (NS).');
      
      %procedure for factor B
      if p == 2 | (b-1) == 1
         sB = 1;
      else
         sB = sqrt((p^2*((b-1)^2)-4)/(p^2+((b-1)^2)-5));
      end; 
      
      v1B = p*(b-1);
      v2B = (sB*((f-(a*b))-((p+b)/2)))-(((p*(b-1))-2)/2);
      vB = LWB^(1/sB);
      FB = ((1-vB)/vB)*(v2B/v1B);
      PB = 1-fcdf(FB,v1B,v2B);
      
      %Pillai's test (Trace test) for factor B
      VB = trace(inv(HB+E)*HB);
      q = b-1;
      s = min(p,q);
      v = f-(a*b);
      m = (abs(p-q)-1)/2;
      n = (v-p-1)/2;
      FPB = (((2*n)+s+1)/((2*m)+s+1))*(VB/(s-VB));
      v1PB = s*((2*m)+s+1);
      v2PB = s*((2*n)+s+1);
      PPB = 1-fcdf(FPA,v1PA,v2PA);
      
      %Lawley-Hotelling's trace test for factor B
      UB = trace(inv(E)*HB);
      FLHB = (2*((s*n)+1)*UB)/(s^2*((2*m)+s+1));
      v1LHB = s*((2*m)+s+1);
      v2LHB = 2*((s*n)+1);
      PLHB = 1-fcdf(FLHB,v1LHB,v2LHB);
      
      %Roy's Union_intersection test (Largest root test) for factor B
      RB = max(eig(inv(E)*HB));
      r = max(p,q);
      FRB = RB*((v-r+q)/r);
      v1RB = r;
      v2RB = v-r+q;
      % Because the numerator and denominator degrees of freedom could results a fraction,
      % the probability function associated to the F statistic is resolved by the Simpson's
      % 1/3 numerical integration method.
      x = linspace(.000001,FRB,100001);
      DF = x(2)-x(1);
      y = ((v1RB/v2RB)^(.5*v1RB)/(beta((.5*v1RB),(.5*v2RB))));
      y = y*(x.^((.5*v1RB)-1)).*(((x.*(v1RB/v2RB))+1).^(-.5*(v1RB+v2RB)));
      N2 = length(x);
      PRB = 1-(DF.*(y(1)+y(N2) + 4*sum(y(2:2:N2-1))+2*sum(y(3:2:N2-2)))/3.0);
      
      if PB >= alpha;
         ds1B ='NS';
      else
         ds1B =' S';
      end;
      if  PPB >= alpha;
         ds2B ='NS';
      else
         ds2B =' S';
      end;
      if  PLHB >= alpha;
         ds3B ='NS';
      else
         ds3B =' S';
      end;
      if PRB >= alpha;
         ds4B ='NS';
      else
         ds4B =' S';
      end;
      ;
      disp(' ')
      disp('Multivariate Analysis of Variance Table for Factor B.')
      fprintf('--------------------------------------------\n');
      disp('No. data    Levels      Variables       L')
      fprintf('--------------------------------------------\n');
      fprintf('%5.i%11.i%13.i%14.4f\n',f,b,p,LWB);
      fprintf('--------------------------------------------\n');
      disp(' ')
      fprintf('------------------------------------------------------------------------------\n');
      disp('Test                 Statistic     df1     df2         F       P    Conclusion')
      fprintf('------------------------------------------------------------------------------\n');
      fprintf('Rao            %13.3f%10i%8i%11.2f%9.4f      %s\n',LWB,v1B,v2B,FB,PB,ds1B);
      fprintf('Pillai         %13.3f%10i%8i%11.2f%9.4f      %s\n',VB,v1PB,v2PB,FPB,PPB,ds2B);
      fprintf('Lawley-Hotelling      %6.3f%10i%8i%11.2f%9.4f      %s\n',UB,v1LHB,v2LHB,FLHB,PLHB,ds3B);
      fprintf('Roy            %13.3f%10.1f%8.1f%11.2f%9.4f      %s\n',RB,v1RB,v2RB,FRB,PRB,ds4B);
      fprintf('------------------------------------------------------------------------------\n');
      fprintf('With a given significance of:% 3.2f\n', alpha);
      disp('According to the P-value, the mean vectors of factor B could be significant (S) or'); 
      disp('not significant (NS).');
      
   else
      return;
   end;
end;