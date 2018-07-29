function [AOV1] = AOV1(X,mt,alpha)
%Single-Factor Analysis of Variances Test.
%(Computes the Analysis of Variance Model I or Model II for equal or unequal sample sizes.)
%
%   Syntax: function [AOV1] = AOV1(X,mt,alpha) 
%      
%     Inputs:
%          X - data matrix (Size of matrix must be n-by-2; data=column 1, sample=column 2). 
%         mt - model type [Model I (fixed-effects) = 1; Model II (random-effects) = 2] 
%      alpha - significance level (default = 0.05).
%     Outputs:
%          - Sample means vector.
%          - Complete Analysis of Variance table.
%                               |- homogeneity among sample means was met (for Model I).
%                               |
%          - Whether or not the |
%                               |
%                               |- homogeneity among variances was met (for Model II).
%
%    Example: From the example on Box 9.1 of Sokal and Rohlf (1981, pp.210-216), to test the
%             homogeneity among the means (Model II) of data with a significance level = 0.05.
%
%                                 Sample
%                   ---------------------------------
%                       1       2       3       4
%                   ---------------------------------
%                      380     350     354     376
%                      376     356     360     344   
%                      360     358     362     342
%                      368     376     352     372
%                      372     338     366     374
%                      366     342     372     360
%                      374     366     362        
%                      382     350     344        
%                              344     342
%                              364     358
%                                      351
%                                      348
%                                      348
%                   ---------------------------------
%                                       
%           Data matrix must be:
%            X=[380 1;376 1;360 1;368 1;372 1;366 1;374 1;382 1;350 2;356 2;358 2;376 2;
%            338 2;342 2;366 2;350 2;344 2;364 2;354 3;360 3;362 3;352 3;366 3;372 3;362 3;
%            344 3;342 3;358 3;351 3;348 3;348 3;376 4;344 4;342 4;372 4;374 4;360 4];
%
%     Calling on Matlab the function: 
%             AOV1(X,2)
%
%       Answer is:
%
% The number of samples are: 4
%
% Analysis of Variance Model II Table.
% ----------------------------------------------------------------------------------------
% SOV             SS         df         MS         F        P       Var.comp.    % Contr.
% ----------------------------------------------------------------------------------------
% Sample     1807.727         3     602.576      5.263   0.0044       54.178      32.12
% Error      3778.003        33     114.485                          114.485      67.88
% Total      5585.730        36
% ----------------------------------------------------------------------------------------
% The associated probability for the F test is smaller than 0.05
% So, the assumption that the added variance and the random variance component are equal was not met.
%

%  Created by A. Trujillo-Ortiz and R. Hernandez-Walls
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.mx
%
%  April 11, 2003.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A. and R. Hernandez-Walls. (2003). AOV1: Single-factor Analysis of variance test
%    A MATLAB file. [WWW document]. URL http://www.mathworks.com/matlabcentral/fileexchange/
%    loadFile.do?objectId=3313&objectType=file
%
%  References:
% 
%  Sokal, R. R. and Rohlf, F. J. (1981), Biometry. 2nd. ed. 
%              New-York:W. H. Freeman & Co. pp. 210-216.
%  Zar, J. H. (1999), Biostatistical Analysis (2nd ed.).
%           NJ: Prentice-Hall, Englewood Cliffs. p. 178-186. 
%

if nargin < 3,
   alpha = 0.05;
end 

k=max(X(:,2));
fprintf('The number of samples are:%2i\n\n', k);

%Analysis of Variance Procedure.
m=[];n=[];nn=[];A=[];
indice=X(:,2);
for i=1:k
   Xe=find(indice==i);
   eval(['X' num2str(i) '=X(Xe,1);']);
   eval(['m' num2str(i) '=mean(X' num2str(i) ');'])
   eval(['n' num2str(i) '=length(X' num2str(i) ') ;'])
   eval(['nn' num2str(i) '=(length(X' num2str(i) ').^2);'])
   eval(['xm= m' num2str(i) ';'])
   eval(['xn= n' num2str(i) ';'])
   eval(['xnn= nn' num2str(i) ';'])
   eval(['x =(sum(X' num2str(i) ').^2)/(n' num2str(i) ');']);
   m=[m;xm];n=[n;xn];nn=[nn,xnn];A=[A,x];
end

C=(sum(X(:,1)))^2/length(X(:,1)); %correction term.
SST=sum(X(:,1).^2)-C; %total sum of squares.
dfT=length(X(:,1))-1; %total degrees of freedom.

SSA=sum(A)-C; %sample sum of squares.
v1=k-1; %sample degrees of freedom.
SSE=SST-SSA; %error sum of squares.
v2=dfT-v1; %error degrees of freedom.
MSA=SSA/v1; %sample mean squares.
MSE=SSE/v2; %error mean squares.
F=MSA/MSE; %F-statistic.

P = 1 - fcdf(F,v1,v2);  %probability associated to the F-statistic.   

if mt == 1;
   disp(' Sample    Size      Means')
   for i=1:k
      fprintf('   %d       %2i       %2.3f\n',i,n(i),m(i))
   end
   disp(' ')
   disp('Analysis of Variance Model I Table.')
   fprintf('--------------------------------------------------------------\n');
   disp('SOV             SS         df         MS         F        P')
   fprintf('--------------------------------------------------------------\n');
   fprintf('Treat.  %11.3f%10i%12.3f%11.3f%9.4f\n\n',SSA,v1,MSA,F,P);
   fprintf('Error%14.3f%10i%12.3f\n\n',SSE,v2,MSE);
   fprintf('Total%14.3f%10i\n\n',SST,dfT);
   fprintf('--------------------------------------------------------------\n');
   
   if P >= alpha;
      fprintf('The associated probability for the F test is equal or larger than% 3.2f\n', alpha);
      fprintf('So, the assumption of sample means are equal was met.\n');
   else
      fprintf('The associated probability for the F test is smaller than% 3.2f\n', alpha);
      fprintf('So, the assumption of sample means are equal was not met.\n');
   end
else mt==2;
   no=(1/v1)*(sum(n)-(sum(nn)/sum(n)));
   s2A=(MSA-MSE)/no;
   pcs2A=(s2A/(MSE+s2A))*100;
   pcs2=100-pcs2A;
   if (MSA-MSE)> 0;
      s2A = s2A;
   else
      s2A = 0;
   end
   disp(' ')
   disp('Analysis of Variance Model II Table.')
   fprintf('----------------------------------------------------------------------------------------\n');
   disp('SOV             SS         df         MS         F        P       Var.comp.    % Contr.')
   fprintf('----------------------------------------------------------------------------------------\n');
   fprintf('Sample  %11.3f%10i%12.3f%11.3f%9.4f%13.3f%11.2f\n\n',SSA,v1,MSA,F,P,s2A,pcs2A);
   fprintf('Error%14.3f%10i%12.3f%33.3f%11.2f\n\n',SSE,v2,MSE,MSE,pcs2);
   fprintf('Total%14.3f%10i\n\n',SST,dfT);
   fprintf('----------------------------------------------------------------------------------------\n');
   
   if P >= alpha;
      fprintf('The associated probability for the F test is equal or larger than% 3.2f\n', alpha);
      fprintf('So, the assumption that the added variance and the random variance component are equal was met.\n');
   else
      fprintf('The associated probability for the F test is smaller than% 3.2f\n', alpha);
      fprintf('So, the assumption that the added variance and the random variance component are equal was not met.\n');
   end
end


   
   