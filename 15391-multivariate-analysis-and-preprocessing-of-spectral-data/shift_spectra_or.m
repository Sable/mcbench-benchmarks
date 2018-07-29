function [x_sh, y_sh]=shift_spectra_or(spectra, X,C);
% function [x_sh, y_sh]=shift_spectra_or(spectra, X,C);
% function to shift spectra with original accuracy (delta X)
% spectra - matrix of spectra [nxm]
% X-variable (wavelength, mass, etc.) [nx1]
% C - value at which a maximum of peak  is desired
%
% created by K.Artyushkova
% kartyush@unm.edu
%

%%
[m,n]=size(spectra);
step=X(1)-X(2);

%% finds the maximum for each spectra - its position and shift in number
% of points (S) from the most high value of maximum through the set of
% spectra
for i=1:n
    [k,r(i)]=max(spectra(:,i));
    x(i)=X(r(i));
end

[q,s]=max(x);

for i=1:n
    S(i)=x(i)-x(s);
end

S=double(single(1/step*abs(S)));
N=max(S);

%% combines all spectra into matrix yy. Now all spectra have the maximum at the 
% same position of the variable
[mm,nn]=size(spectra);
for i=1:n
    Ss=S(i);
    yy(:,i)=spectra((Ss+1):(mm-(N-Ss)),i);
end

%% shifts X-axis to have a maximum at the desired value of C
X_x=X(1:(mm-N));
I = size(X_x);
shift=double(single((C-q)));
step=step*-1;
X_xx=(X_x(1)+shift):step:(X_x(I(1))+shift);
X_xx=X_xx';
[n,m]=size(X_xx);
[p,q]=size(yy);

if n==p
    y_sh=yy;
    x_sh=X_xx';
else
    y_sh=yy;
    X_xxx=X_xx(1):step:(X_xx(I(1)-1)+step);
    x_sh=X_xxx';
end

%% plots the output
reverplot(x_sh, y_sh)