function [Wtest] = Wtest(X,alpha)
%Welch's test for homogeneity of variances.
%(Welch's test also can be used as an alternative analysis of variance when samples 
%variances are unequal.)
%
%   Syntax: function [Wtest] = Wtest(X,alpha) 
%      
%     Inputs:
%          X - data matrix (Size of matrix must be n-by-2; data=column 1, sample=column 2). 
%       alpha - significance level (default = 0.05).
%     Outputs:
%          - Sample variances vector.
%          - Whether or not the homoscedasticity was met.
%
%    Example: From the example 10.13 of Zar (1999, p. 202-203), to test the Welch's
%             homoscedasticity of data with a significance level = 0.05.
%
%                                 Diet
%                   ---------------------------------
%                       1       2       3       4
%                   ---------------------------------
%                     60.8    68.7   102.6    87.9
%                     57.0    67.7   102.1    84.2
%                     65.0    74.0   100.2    83.1
%                     58.6    66.3    96.5    85.7
%                     61.7    69.8            90.3
%                   ---------------------------------
%                                       
%           Data matrix must be:
%            X=[60.8 1;57.0 1;65.0 1;58.6 1;61.7 1;68.7 2;67.7 2;74.0 2;66.3 2;69.8 2;
%            102.6 3;102.1 3;100.2 3;96.5 3;87.9 4;84.2 4;83.1 4;85.7 4;90.3 4];
%
%     Calling on Matlab the function: 
%             Wtest(X)
%
%       Answer is:
%
% The number of samples are: 4
%
% ----------------------------
% Sample    Size      Variance
% ----------------------------
%   1        5         9.3920
%   2        5         8.5650
%   3        4         7.6567
%   4        5         8.3880
% ----------------------------
%   
% Welch's Test for Equality of Variances F=144.4846, df1= 3, df2= 8.1749
% Probability associated to the F statistic = 0.0000
% The associated probability for the F test is smaller than 0.05
% So, the assumption of homoscedasticity was not met.     
%

%  Created by A. Trujillo-Ortiz and R. Hernandez-Walls
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.mx
%
%  April 30, 2003.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A. and R. Hernandez-Walls. (2003). Wtest: Welch's test for homogeneity 
%    of variances. A MATLAB file. [WWW document]. URL http://www.mathworks.com/matlabcentral/
%    fileexchange/loadFile.do?objectId=3438&objectType=FILE
%
%  References:
% 
%  Welch, B. L. (1951), On the comparision of several mean values: An alternative approach.
%           Biometrika, 38: 330-336. 
%  Zar, J. H. (1999), Biostatistical Analysis (2nd ed.).
%           NJ: Prentice-Hall, Englewood Cliffs. p. 185, 187-188, 202-203. 
%

if nargin < 2,
   alpha = 0.05;
end 

k=max(X(:,2));
fprintf('The number of samples are:%2i\n\n', k);

%Statistics.
n=[];s2=[];m=[];
indice=X(:,2);
for i=1:k
   Xe=find(indice==i);
   eval(['X' num2str(i) '=X(Xe,1);']);
   eval(['n' num2str(i) '=length(X' num2str(i) ') ;']);
   eval(['s2' num2str(i) '=(std(X' num2str(i) ').^2) ;']);
   eval(['m' num2str(i) '=mean(X' num2str(i) ');']);
   eval(['xn= n' num2str(i) ';']);
   eval(['xs2= s2' num2str(i) ';']);
   eval(['xm= m' num2str(i) ';'])
   n=[n;xn];s2=[s2;xs2];m=[m;xm];
end

fprintf('-----------------------------\n');
disp(' Sample    Size      Variance')
fprintf('-----------------------------\n');
for i=1:k
   fprintf('   %d       %2i         %.4f\n',i,n(i),s2(i))
end
fprintf('-----------------------------\n');
disp(' ')

%Welch's Procedure.
ws=[];
for i=1:k
   eval(['w' num2str(i) '=n' num2str(i) '/s2' num2str(i) ';']);
   eval(['x= w' num2str(i) ';']);
   ws=[ws;x];
end

wps=[];
for i=1:k
   eval(['wp' num2str(i) '=w' num2str(i) '*m' num2str(i) ';']);
   eval(['x= wp' num2str(i) ';']);
   wps=[wps;x];
end

A=sum(ws);
D=sum(wps);

H=D/A;

b=[];
for i=1:k
   eval(['b' num2str(i) '=((1-(w' num2str(i) '/A)).^2)/(n' num2str(i) '-1);']);
   eval(['x=b' num2str(i) ';']);
   b=[b;x];
end

pw=[];
for i=1:k
   eval(['pws' num2str(i) '=(w' num2str(i) '*((m' num2str(i) '-H).^2)/(k-1));']);
   eval(['x=pws' num2str(i) ';']);
   pw=[pw;x];
end

E=sum(pw);
O=sum(b);

G=(1+2*(k-2)*O/(k^2-1));

F=E/G;  %Welch's F-statistic.
v1=(k-1);  %numerator degrees of freedom.
v2=(k^2-1)/(3*O);  %denominator degrees of freedom.
df1=v1;df2=v2;

% Because the denominator degrees of freedom are corrected and could results 
% a fraction, the probability function associated to the F statistic is resolved 
% by the Simpson's 1/3 numerical integration method.
x=linspace(.000001,F,100001);
DF=x(2)-x(1);
y=((v1/v2)^(.5*v1)/(beta((.5*v1),(.5*v2))));
y=y*(x.^((.5*v1)-1)).*(((x.*(v1/v2))+1).^(-.5*(v1+v2)));
N=length(x);
P=1-(DF.*(y(1)+y(N) + 4*sum(y(2:2:N-1))+2*sum(y(3:2:N-2)))/3.0);

fprintf('Welch''s Test for Equality of Variances F=%3.4f, df1=%2i, df2=%7.4f\n', F,df1,df2);
fprintf('Probability associated to the F statistic = %3.4f\n', P);

if P >= alpha;
  fprintf('The associated probability for the F test is equal or larger than% 3.2f\n', alpha);
  fprintf('So, the assumption of homoscedasticity was met.\n');
else
  fprintf('The associated probability for the F test is smaller than% 3.2f\n', alpha);
  fprintf('So, the assumption of homoscedasticity was not met.\n');
end