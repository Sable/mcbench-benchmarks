function varargout = dtmfdet(x,fs,varargin)
% DTMFDET   DTMF Tone Detection Using Goertzel Algorithm.
%
%  Y = DTMFDET(X,FS) returns the DTMF coded sequence
%  in present vector X. The sound sample frequency
%  is given by FS.
%
%  Y = DTMFDET(X,FS,'strong') uses a more robust algorithm
%  to detect two equall DTMF signals in a sequence. Some times
%  not using this strong and longer method can result in
%  only one DTMF signal detected, instead of the two.
%

LIM = .7; % Limit for detecting tone (if the intensity of the freq from goertzel is less the LIM* the max intensity, the tone wont be detected)
T = ['1' '2' '3' 'A' '4' '5' '6' 'B' '7' '8' '9' 'C' '*' '0' '#' 'D'];
FL = [697 770 852 941];
FH = [1209 1336 1477 1633];
OL = .0; % Overlapping block in goertzel.

pl = 0; % Plotting flag

for i = 1 : length(varargin)
    if strcmp(varargin{i},'strong')
        OL = .4;
    elseif strcmp(varargin{i},'plot')
        pl = 1;
    else
        error('Unknown parameter.')
    end
end

time = 0.02;
N = time*fs;

ADV = max(round((1-OL)*N),1);
YL = zeros(4,floor(length(x)/ADV));
YH = YL;

for i = 1 : 4
    YL(i,:) = goertzel(x,fs,FL(i),N,'mag','overlap',OL);
    YH(i,:) = goertzel(x,fs,FH(i),N,'mag','overlap',OL);
end

[a,a] = sort(YL,1);
[b,b] = sort(YH,1);

YL(YL<LIM*max(YL(:))) = 0;
YH(YH<LIM*max(YH(:))) = 0;

[l1,l2] = max(YL);
[h1,h2] = max(YH);

r = T((l2-1)*4+h2);
r(l1==0) = '-';
r(h1==0) = '-';

if pl == 1
    plot(YL')
    figure(gcf+1)
    plot(YH')
end

ct = 1;
for i = 2 : length(r)
    if r(i)~='-' & r(i)~=r(i-1)
        y(ct) = r(i);
        ct = ct+1;
    end
end


varargout{1} = y;
