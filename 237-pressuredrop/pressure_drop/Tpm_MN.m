function MNTPM = Tpm_MN(P,X)
% TPM_MN  Martinelli-Nelson two-phase multiplier
% TPM_MN(P,X) Returns the Martinelli-Nelson two-phase 
% multipier for a steam-water system 
%  Called function: NONE
%  Required Inputs are: P - pressure (kPa), X - quality (fraction)
% ---------------------------------------------------------------
% The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

format long g;  % set the format of the calculations

% Set the constants
A1J=[2.544832 -7.88962 15.57587 -17.3409 10.40984 -3.20449 0.424848 -0.0108];
A2J=[-0.51768 1.95502 -0.96886 -4.61201 8.491034 -5.95831 1.898918 -0.22868];
A3J=[0.10194 -0.37234 -0.19026 2.265484 -3.49254 2.329909 -0.72535 0.08617];
A4J=[-0.00806 0.026161 0.060289 -0.32427 0.465539 -0.30333 0.09338 -0.01102];

%  CONVERSION FROM KPA TO PSI
PPSI=P/6.895;

V=PPSI/1000;
W=log(100*X+1);

AA1=0;
for J=1:8
 AA1=AA1+A1J(J)*V^(J-1);
end   

AA2=0;
for J=1:8
 AA2=AA2+A2J(J)*V^(J-1);
end

AA3=0;
for J=1:8
 AA3=AA3+A3J(J)*V^(J-1);
end

AA4=0;
for J=1:8
 AA4=AA4+A4J(J)*V^(J-1);
end

M=AA4*W^4+AA3*W^3+AA2*W^2+AA1*W^1;

% THE MARTINELLI-NELSON TWO-PHASE MULTIPLIER IS
MNTPM=exp(M);

return