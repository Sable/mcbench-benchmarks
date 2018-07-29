function [X_sh, sp_sh]=shift_spectra_diff(spectra, X);
% function [X_sh, sp_sh]=shift_spectra_diff(spectra, X);
% shifts all spectra onto different position of maximums and combines the data into one
% matrix
% spectra - matrix of spectra [nxm]
% X-variable (wavelength, mass, etc.) [nx1]
%
% created by K.Artyushkova
% kartyush@unm.edu
%

[I,J] = size(X);
[m,n]=size(spectra);

%% creates new set of X variable vectors by shifting them to a new maximum
% value
for i=1:n
    [k,r(i)]=max(spectra(:,i));
     x(i)=X(r(i));
    shift=inputdlg('Which binding energy to use for calibration?');  
    shift=str2double(shift);
    a(i)=shift-x(i);
    S=double(single(10*abs(a(i))));
    X_x=(X(1)+a(i)):-0.1:(X(I(1))+a(i));
    X_t=X_x';
    X_sh(:,i)=X_t;
end

%% finds the maximum for each spectra - its position and shift from the
% maximum throught all spectra
for i=1:n
    [k,r(i)]=max(spectra(:,i));
    x(i)=X_sh(r(i),i);
end
[q,s]=max(x);
for i=1:n
    S(i)=x(i)-x(s);
end
S=double(single(10*abs(S)));
N=max(S);

%% shifts both X and spectra into correct position
[mm,nn]=size(spectra);
for i=1:nn
    Ss=S(i);
    yy(:,i)=spectra((Ss+1):(mm-(N-Ss)),i);
    X_yy(:,i)=X_sh((Ss+1):(mm-(N-Ss)),i);
end

%% find common min and max for all X's and creates a single X- variable
for i=1:n
    m(i)=min(X_yy(:,i));
    M(i)=max(X_yy(:,i));
end
m=max(m);
M=min(M);
X_new=[M:-0.1:m];
[I,J]=size(X_new);
X1=X_new(1);
XN=X_new(J);

%% crops each X-variable and spectrum to match the common X_new and
% combines into one data matrix
for i=1:n
    Xy=X_yy(:,i);
    Imin = match(X1,Xy);
    Imax = match(XN,Xy);
    X_sh2(:,i)=X_sh(Imin:Imax,i);
    sp_sh(:,i)=yy(Imin:Imax,i);
end

X_sh=X_sh2(:,1);

reverplot(X_sh, sp_sh)
