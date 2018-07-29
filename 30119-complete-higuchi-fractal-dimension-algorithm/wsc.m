function [varargout]=wsc(N,lamda,M,H)
% Fucntion to generate Weierstrauss Cosine (WSC) fucntion for verification HFD
% algorithm
% INPUT: N - No. of samples of output WSC time series;
%        lamda > 1
%        0 < H < 1 e.g., H=[0.1:0.1:0.9]
% OUTPUT: xwsc - WSC series; FDth - theoritical FD

if ~exist('N','var')||isempty(N),
    N=1000;
end;
if ~exist('lamda','var')||isempty(lamda),
    lamda=5;
end;
if ~exist('M','var')||isempty(M),
    M=26;
end;
if ~exist('H','var')||isempty(H),
    H=0.1;
end;

if lamda<1,
    error('lamda must be greater than 1.');
end;
if H<0||H>1,
    error('H must be between 0 and 1.');
end;

t=linspace(0,1,N);
xwsc=zeros(1,N);
for i=1:N,
    xwsc(1,i)=sum((lamda.^-((0:M)*H)).*(cos(2*pi*(lamda.^((0:M)))*t(i))));
end;
FDth=2-H;

% t=linspace(0,1,N);
% for i=1:N,
%     xwsci=0;
%     for j=0:M,
%         xwsci=xwsci+(lamda^((-1)*j*H))*cos(2*pi*(lamda^j)*t(i));
%     end;
%     xwsc(1,i)=xwsci;
% end;
% FDth=2-H;

if nargout~=0,
    varargout={xwsc,FDth,H,lamda,M};
end;
disp(['Theoretical value of FD of time series: ',num2str(FDth)]);
disp(['Theoretical value of H of time series: ',num2str(H)]);

% Reference:
% 1. T. Higuchi (1998), Approach to an irregular time series on the basis of the fractal theory, Physica D, 277-283
% 2. C E Polychronaki et al (2010), Comparison of fractal dimension
% estimation algorithms for epileptic seizure onset detection, J. Neural Eng. 7 (2010) 046007 (18pp)
% 3. Rosana Esteller et al (2001), A Comparison of Waveform Fractal
% Dimension Algorithms, IEEE Trans. on Circuits and Systems
% Copyright(!!!): V Salai Selvam, Tamil Nadu, India email:
% vsalaiselvam@yahoo.com