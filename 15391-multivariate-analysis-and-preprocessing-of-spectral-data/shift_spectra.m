function [x_sh, y_sh]=shift_spectra(spectra, X,C);
% function [x_sh, y_sh]=shift_spectra(spectra, X,C);
%   Function to shift spectra with a 10x better accuracy than original data:
%       -if variable have a step in x-axis 0.1 than the spectra are interpolated
%        to having step of 0.01, the spectra are shifted and then converted back
%        to original number of points
%   This prepares data for multivariate analysis which is sensitive to
%   shift in data 
%   Preferred over shift_spectra_or.m function
%
% spectra - matrix of spectra [nxm]
% X-variable (wavelength, mass, etc.)[n x 1]
% C - value at which a maximum of peak  is desired
% created by K.Artyushkova
% kartyush@unm.edu
%

%% converts spectra and X variable into 10X more channels than original
% data
[m,n]=size(spectra);
step=X(1)-X(2);
stepN=step/10*-1;
x = X(1):stepN:(X(m)+stepN); 
x=x';
for i=1:n;
y(:,i)=spline(X,spectra(:,i),x);
end

%% finds the maximum for each spectra - its position and shift in number
% of points (S) from the most high value of maximum through the set of
% spectra
for i=1:n
    [k,r(i)]=max(y(:,i));
    xx(i)=x(r(i));
end
[q,s]=max(xx);
for i=1:n
    S(i)=xx(i)-xx(s);
end
stepN=stepN*-1;
S=double(single(1/stepN*abs(S)));
N=max(S);

%% combines all spectra into matrix yy. Now all spectra have the maximum at the 
% same position of the variable
[mm,nn]=size(y);
for i=1:n
    Ss=S(i);
    yy(:,i)=y((Ss+1):(mm-(N-Ss)),i);
end

%% shifts X-axis to have a maximum at the desired value of C
X_x=x(1:(mm-(N-1)));
I = size(X_x);
shift=double(single((C-q)));
stepN=stepN*-1;
X_xx=(X_x(1)+shift):stepN:(X_x(I(1))+shift);
X_xx=X_xx';

%% converts data back to original number of points in X
mmm=round(I(1)/10);
for i=1:1:(mmm-1)
    yyy(i,:)=yy(i*10,:);
    X_xxx(i)=X_xx(i*10);
end

y_sh=yyy;
x_sh=X_xxx';
reverplot(x_sh, y_sh)
