function [latgsqr] = latgsqr(X,a)
%LATGSQR Analysis of variance by a latin or graeco-latin square design with
%  or without replicates. 
%
%   Syntax: function [latgsqr] = latgsqr(X,a) 
%      
%     Inputs:
%          X - data matrix. 
%          a - significance level (default = 0.05).
%     Output:
%          design size.
%          number of columns.
%          number of rows.
%          number of treatments.
%          number of replicates (in case of).
%          number of greeks (in case of).
%          analysis of variance table.
%          P - Probability that null Ho: is true.
%
%    Example 1 (latin square 3rd order): From the excercise 13.16 of Mendenhall
%         (1979) for a latin square design 3x3 without replicates we are 
%         interested to test any difference among its rows,
%         columns and treatments with a significance level = 0.05.
%                                       
%                      ----------------------------              
%                                C o l u m n s
%                      ----------------------------
%                       Rows    1      2      3
%                      ----------------------------
%                        1     12(B)   7(A)  17(C)
%                        2     10(C)   7(B)   4(A)
%                        3      2(A)   8(C)  12(B)
%                      ----------------------------
%
%             Total data matrix must be:
%              X=[12 1 1 2;10 1 2 3;2 1 3 1;7 2 1 1;7 2 2 2;8 2 3 3;17 3 1 3;4 3 2 1;
%              12 3 3 2];
%
%     Calling on Matlab the function: 
%             latgsqr(X)
%       Immediately it display:
%             -Design size is: 3
%       Then it asks:
%             -Latin square design (1) or Graeco-latin square design (2):
%             For this example you must to put it after the colon, 1
%       Also it asks:
%             -Without replicates (1) or with replicates (2):
%             That for this example you must to put it after the colon, 1
%
%       Answer is:
%          Number of columns are: 3
%          Number of rows are: 3
%          Number of treatments are: 3
%     
%          --------------------------------------------------------------
%          SOV             SS         df         MS         F        P
%          --------------------------------------------------------------
%          Rows         46.889         2      23.444     11.105   0.0826
%          Columns      22.889         2      11.444      5.421   0.1557
%          Treat.       91.556         2      45.778     21.684   0.0441
%          Error         4.222         2       2.111
%          Total       165.556         8
%          --------------------------------------------------------------
%
%    Example 2 (graeco-latin square 5th order): We are considering an
%         hypothetic graeco-latin square design 5x5 with one replicate. 
%         We thank Alex Karandreas (Department of Acoustics Aalborg 
%         University, Denmark) for encourage us to include this kind of
%         example. The data are:
%                  ---------------------------------------------
%                                    C o l u m n s
%                  ---------------------------------------------
%                  Rows    1       2       3       4       5
%                  ---------------------------------------------
%                   1   12/A(a)  6/B(c) 15/C(e)  9/D(b)  11/E(d)
%                   2    7/B(b)  8/D(d) 10/E(c)  8/C(a)  10/A(e)
%                   3    6/C(c) 12/A(a) 11/D(d)  9/E(e)   8/B(b)
%                   4    5/D(d)  9/E(e)  8/A(b) 10/B(c)  13/C(a)
%                   5   11/E(e) 10/C(b)  9/B(a) 11/A(d)   9/D(c)
%                  ---------------------------------------------
%                  where, a=alpha;b=beta;c=gamma;d=delta;e=eta
% 
%                  Replicate
%                  ---------------------------------------------
%                                    C o l u m n s
%                  ---------------------------------------------
%                  Rows    1       2       3       4       5
%                  ---------------------------------------------
%                   1    8/A(a)  9/B(c) 10/C(e) 12/D(b)  10/E(d)
%                   2   14/B(b) 10/D(d)  8/E(c) 14/C(a)  11/A(e)
%                   3    9/C(c)  8/A(a) 13/D(d) 11/E(e)   9/B(b)
%                   4    7/D(d) 12/E(e) 10/A(b) 15/B(c)   8/C(a)
%                   5    9/E(e)  8/C(b) 13/B(a)  7/A(d)   6/D(c)
%                  ---------------------------------------------
%
%    Total data matrix must be:
%    X=[12 1 1 1 1 1;7 1 2 2 2 1;6 1 3 3 3 1;5 1 4 4 4 1;11 1 5 5 5 1;6 2 1 2 3 1;
%    8 2 2 4 4 1;12 2 3 1 1 1;9 2 4 5 5 1;10 2 5 3 2 1;15 3 1 3 5 1;10 3 2 5 3 1;
%    11 3 3 4 4 1;8 3 4 1 2 1;9 3 5 2 1 1;9 4 1 4 4 1;8 4 2 3 1 1;9 4 3 5 5 1;
%    10 4 4 2 3 1;11 4 5 1 4 1;11 5 1 5 4 1;10 5 2 1 5 1;8 5 3 2 2 1;13 5 4 3 1 1;
%    9 5 5 4 3 1;8 1 1 1 1 2;14 1 2 2 2 2;9 1 3 3 3 2;7 1 4 4 4 2;9 1 5 5 5 2;
%    9 2 1 2 3 2;10 2 2 4 4 2;8 2 3 1 1 2;12 2 4 5 5 2;8 2 5 3 2 2;10 3 1 3 5 2;
%    8 3 2 5 3 2;13 3 3 4 4 2;10 3 4 1 2 2;13 3 5 2 1 2;12 4 1 4 4 2;14 4 2 3 1 2;
%    11 4 3 5 5 2;15 4 4 2 3 2;7 4 5 1 4 2;10 5 1 5 4 2;11 5 2 1 5 2;9 5 3 2 2 2;
%    8 5 4 3 1 2;6 5 5 4 3 2];
%
%     Calling on Matlab the function: 
%             latgsqr(X)
%       Immediately it display:
%             -Design size is: 5
%       Then it asks:
%             -Latin square design (1) or Graeco-latin square design (2):
%             For this example you must to put it after the colon, 2
%       Also it asks:
%             -Without replicates (1) or with replicates (2):
%             That for this example you must to put it after the colon, 2
%
%       Answer is:
%          Number of columns are: 5
%          Number of rows are: 5
%          Number of treatments are: 5
%          Number of replicates are: 2
%       --------------------------------------------------------------
%       SOV             SS         df         MS         F        P
%       --------------------------------------------------------------
%       Rep.          3.920         1       3.920      0.625   0.4351
%       Rows          4.920         4       1.230      0.196   0.9387
%       Columns      28.920         4       7.230      1.152   0.3502
%       Treat.        8.120         4       2.030      0.323   0.8601
%       Greek        26.420         4       6.605      1.052   0.3959
%       Error       200.820        32       6.276
%       Total       273.120        49
%       --------------------------------------------------------------
%     
%    The columns arrangement of data matrix (X) for the design must be:
%
%        |-No replicates: 1(data) 2(column) 3(row) 4(treatment)
% |-Latin|
% |      |-Replicates:    1(data) 2(column) 3(row) 4(treatment) 5(replicate)
% |
% |             |-No replicates: 1(data) 2(column) 3(row) 4(treatment) 5(greek)
% |-Graeco-Latin|
%               |-Replicates:    1(data) 2(column) 3(row) 4(treatment) 5(greek) 6(replicate)
%
%  ANY GRAECO-LATIN SQUARE DESIGN MUST BE OF AT LEAST 4x4, IF NOT WILL APPEARS A WARNING.
%
%  Created by A. Trujillo-Ortiz and R. Hernandez-Walls
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.mx
%
%  December 24, 2002.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A. and R. Hernandez-Walls. (2002). latgsqr: Analysis of variance by
%    a latin or graeco-latin square design with or without replicates. A MATLAB file.
%    [WWW document]. URL http://www.mathworks.com/matlabcentral/fileexchange/
%    loadFile.do?objectId=2881
%
%  References:
%  Mendenhall, W. (1979), Introduction to Probability and Statistics.
%              5th. ed. Wadsworth Pub. Co.
%  Steel, R. G. and Torrie, J. H. (1980), Principles and Procedures of
%              Statistics. 2nd. ed. New-York:McGraw-Hill. pp. 221-231.
%

if nargin < 2, 
    a = 0.05; 
end 

if (a <= 0 | a >= 1)
   fprintf('Warning: significance level must be between 0 and 1\n');
   return
end

if nargin < 1, 
   error('Requires at least one input argument.'); 
end 

t=max(X(:,4));
r=t;
fprintf('Design size is:%2i\n\n', t)
c=t;
indice=X(:,2);
for i=1:c
Xe=find(indice==i);
eval(['C' num2str(i) '=X(Xe,1);']);
end
f=t;
indice=X(:,3);
for j=1:f
Xe=find(indice==j);
eval(['F' num2str(j) '=X(Xe,1);']);
end
indice=X(:,4);
for k=1:t
Xe=find(indice==k);
eval(['T' num2str(k) '=X(Xe,1);']);
end
TC=(sum(X(:,1)))^2/length(X(:,1)); %correction term.
SSTO=sum(X(:,1).^2)-TC; %total sum of squares.
dfTO=length(X(:,1))-1; %total degrees of freedom.
   
fprintf('Number of columns are:%2i\n\n', c)  %columns procedure.
C=[];
for i=1:c
eval(['x =((sum(C' num2str(i) ').^2)/length(C' num2str(i) '));'])
C=[C,x];
end
SSC=sum(C)-TC;
dfC=c-1;
MSC=SSC/dfC;
v1=dfC;

fprintf('Number of rows are:%2i\n\n', f)  %rows procedure.
F=[];
for j=1:f
eval(['x =((sum(F' num2str(j) ').^2)/length(F' num2str(j) '));'])
F=[F,x];
end
SSF=sum(F)-TC;
dfF=f-1;
MSF=SSF/dfF;
v2=dfF;

fprintf('Number of treatments are:%2i\n\n', t)  %treatments procedure.
T=[];
for k=1:t
eval(['x =((sum(T' num2str(k) ').^2)/length(T' num2str(k) '));'])
T=[T,x];
end
SST=sum(T)-TC;
dfT=t-1;
MST=SST/dfT;
v3=dfT;

SSE=SSTO-SSF-SSC-SST;  %error procedure.
dfE=(t-1)*(t-2); 
MSE=SSE/dfE;
v4=dfE;

des=input('Latin square design (1) or Graeco-latin square design (2):');
if (des==1);
   rep=input('Without replicates (1) or with replicates (2):');
   if (rep==1);
   Ff=MSF/MSE;
   Fc=MSC/MSE;
   Ft=MST/MSE;
   PrF = 1 - fcdf(Ff,v2,v4);  %probability that null Ho: for rows is true.
   PrC = 1 - fcdf(Fc,v1,v4);  %probability that null Ho: for columns is true.
   PrT = 1 - fcdf(Ft,v3,v4);  %probability that null Ho: for treatments is true.
fprintf('--------------------------------------------------------------\n');
disp('SOV             SS         df         MS         F        P')
fprintf('--------------------------------------------------------------\n');
fprintf('Rows    %11.3f%10i%12.3f%11.3f%9.4f\n\n',SSF,dfF,MSF,Ff,PrF);
fprintf('Columns %11.3f%10i%12.3f%11.3f%9.4f\n\n',SSC,dfC,MSC,Fc,PrC);
fprintf('Treat.  %11.3f%10i%12.3f%11.3f%9.4f\n\n',SST,dfT,MST,Ft,PrT);
fprintf('Error%14.3f%10i%12.3f\n\n',SSE,dfE,MSE);
fprintf('Total%14.3f%10i\n\n',SSTO,dfTO);
fprintf('--------------------------------------------------------------\n');
disp('     ')

   else
   
p=max(X(:,5));
disp('     ')
fprintf('Number of replicates are:%2i\n\n', p)

indice=X(:,5);
for l=1:p
Xe=find(indice==l);
eval(['R' num2str(l) '=X(Xe,1);']);
end
   
R=[];  %replicates procedure.
for l=1:p
eval(['x =((sum(R' num2str(l) ').^2)/length(R' num2str(l) '));'])
R=[R,x];
end
SSR=sum(R)-TC;
dfR=p-1;
MSR=SSR/dfR;
v4=dfR;

SSE=SSTO-SSR-SSC-SSF-SST;  %error procedure.
dfE=(t-1)*((t*p)+p-3);  
MSE=SSE/dfE;
v5=dfE;

   FR=MSR/MSE;
   FF=MSF/MSE;
   FC=MSC/MSE;
   FT=MST/MSE;
   PrR = 1 - fcdf(FR,v4,v5);  %probability that null Ho: for replicates is true.
   PrF = 1 - fcdf(FF,v2,v5);  %probability that null Ho: for rows is true.
   PrC = 1 - fcdf(FC,v1,v5);  %probability that null Ho: for columns is true.
   PrT = 1 - fcdf(FT,v3,v5);  %probability that null Ho: for treatments is true.
fprintf('--------------------------------------------------------------\n');
disp('SOV             SS         df         MS         F        P')
fprintf('--------------------------------------------------------------\n');
fprintf('Rep.    %11.3f%10i%12.3f%11.3f%9.4f\n\n',SSR,dfR,MSR,FR,PrR);
fprintf('Rows    %11.3f%10i%12.3f%11.3f%9.4f\n\n',SSF,dfF,MSF,FF,PrF);
fprintf('Columns %11.3f%10i%12.3f%11.3f%9.4f\n\n',SSC,dfC,MSC,FC,PrC);
fprintf('Treat.  %11.3f%10i%12.3f%11.3f%9.4f\n\n',SST,dfT,MST,FT,PrT);
fprintf('Error%14.3f%10i%12.3f\n\n',SSE,dfE,MSE);
fprintf('Total%14.3f%10i\n\n',SSTO,dfTO);
fprintf('--------------------------------------------------------------\n');
   
   end
else
g=max(X(:,5));
if g == 3,
   error('WARNING: Any graeco-latin square design must be of at least 4x4.');
end
rep=input('Without replicates (1) or with replicates (2):');

   if (rep==1);
   
indice=X(:,5);
for l=1:g
Xe=find(indice==l);
eval(['G' num2str(l) '=X(Xe,1);']);
end
   
G=[];  %greek procedure.
for l=1:g
eval(['x =((sum(G' num2str(l) ').^2)/length(G' num2str(l) '));'])
G=[G,x];
end
SSG=sum(G)-TC;
dfG=g-1;
MSG=SSG/dfG;
v4=dfG;

SSE=SSTO-SSC-SSF-SST-SSG;  %error procedure.
dfE=(t-1)*(t-3);  
MSE=SSE/dfE;
v5=dfE;

   FF=MSF/MSE;
   FC=MSC/MSE;
   FT=MST/MSE;
   FG=MSG/MSE;
   PrF = 1 - fcdf(FF,v2,v5);  %probability that null Ho: for rows is true.
   PrC = 1 - fcdf(FC,v1,v5);  %probability that null Ho: for columns is true.
   PrT = 1 - fcdf(FT,v3,v5);  %probability that null Ho: for treatments is true.
   PrG = 1 - fcdf(FG,v4,v5);  %probability that null Ho: for greek is true.
fprintf('--------------------------------------------------------------\n');
disp('SOV             SS         df         MS         F        P')
fprintf('--------------------------------------------------------------\n');
fprintf('Rows    %11.3f%10i%12.3f%11.3f%9.4f\n\n',SSF,dfF,MSF,FF,PrF);
fprintf('Columns %11.3f%10i%12.3f%11.3f%9.4f\n\n',SSC,dfC,MSC,FC,PrC);
fprintf('Treat.  %11.3f%10i%12.3f%11.3f%9.4f\n\n',SST,dfT,MST,FT,PrT);
fprintf('Greek   %11.3f%10i%12.3f%11.3f%9.4f\n\n',SSG,dfG,MSG,FG,PrG);
fprintf('Error%14.3f%10i%12.3f\n\n',SSE,dfE,MSE);
fprintf('Total%14.3f%10i\n\n',SSTO,dfTO);
fprintf('--------------------------------------------------------------\n');
   
   else
   
p=max(X(:,6));
disp('     ')
fprintf('Number of replicates are:%2i\n\n', p)

g=max(X(:,5));
indice=X(:,5);
for l=1:g
Xe=find(indice==l);
eval(['G' num2str(l) '=X(Xe,1);']);
end
   
G=[];  %greek procedure.
for l=1:g
eval(['x =((sum(G' num2str(l) ').^2)/length(G' num2str(l) '));'])
G=[G,x];
end
SSG=sum(G)-TC;
dfG=g-1;
MSG=SSG/dfG;
v4=dfG;

indice=X(:,6);
for l=1:p
Xe=find(indice==l);
eval(['R' num2str(l) '=X(Xe,1);']);
end
   
R=[];  %replicates procedure.
for l=1:p
eval(['x =((sum(R' num2str(l) ').^2)/length(R' num2str(l) '));'])
R=[R,x];
end
SSR=sum(R)-TC;
dfR=p-1;
MSR=SSR/dfR;
v5=dfR;

SSE=SSTO-SSR-SSC-SSF-SST-SSG;  %error procedure.
dfE=(t-1)*((t*p)+p-4);  
MSE=SSE/dfE;
v6=dfE;

   FR=MSR/MSE;
   FF=MSF/MSE;
   FC=MSC/MSE;
   FT=MST/MSE;
   FG=MSG/MSE;
   PrR = 1 - fcdf(FR,v5,v6);  %probability that null Ho: for replicates is true.
   PrF = 1 - fcdf(FF,v2,v6);  %probability that null Ho: for rows is true.
   PrC = 1 - fcdf(FC,v1,v6);  %probability that null Ho: for columns is true.
   PrT = 1 - fcdf(FT,v3,v6);  %probability that null Ho: for treatments is true.
   PrG = 1 - fcdf(FG,v4,v6);  %probability that null Ho: for greek is true.
fprintf('--------------------------------------------------------------\n');
disp('SOV             SS         df         MS         F        P')
fprintf('--------------------------------------------------------------\n');
fprintf('Rep.    %11.3f%10i%12.3f%11.3f%9.4f\n\n',SSR,dfR,MSR,FR,PrR);
fprintf('Rows    %11.3f%10i%12.3f%11.3f%9.4f\n\n',SSF,dfF,MSF,FF,PrF);
fprintf('Columns %11.3f%10i%12.3f%11.3f%9.4f\n\n',SSC,dfC,MSC,FC,PrC);
fprintf('Treat.  %11.3f%10i%12.3f%11.3f%9.4f\n\n',SST,dfT,MST,FT,PrT);
fprintf('Greek   %11.3f%10i%12.3f%11.3f%9.4f\n\n',SSG,dfG,MSG,FG,PrG);
fprintf('Error%14.3f%10i%12.3f\n\n',SSE,dfE,MSE);
fprintf('Total%14.3f%10i\n\n',SSTO,dfTO);
fprintf('--------------------------------------------------------------\n');

   end
end