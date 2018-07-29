% GETMSWPFEAT Gets the Multiscale Wavelet Packet feature extraction.
% feat = getmswpfeatV00(x,winsize,wininc,SF)
% ------------------------------------------------------------------
% The signals in x are divided into multiple windows of size
% "winsize" and the windows are spaced "wininc" apart.
% Inputs
% ------
%    x: 		columns of signals
%    winsize:	window size (length of x)
%    wininc:	spacing of the windows (winsize)
%    SF:        sampling frequency
% Outputs
% -------
%    feat:     WPT features (compete tree without node selection)

% Example
% -------
% feat = getmswpfeatV00(rand(1024,1),256,32,256)
% Assuming here rand(1024,1) (this can be any one dimensional signal, 
% for example EEG or EMG) is a one dimensional signal sampled at 256
% for 4 seconds only. Utilizing a window size of 256 at 32 increments
% features are extracted from the wavelet packet tree.
% I assumed 7 decomposition levels (J=7) below in the code.
% For a full tree at 7 levels you should get 
% Level-0= 1 features
% Level-1= 2 features
% Level-2= 4 features
% Level-3= 8 features
% Level-4= 16 features
% Level-5= 32 features
% Level-6= 64 features
% Level-7= 128 features
% ---------------------
% Total = 255 features
% and the result from the example above is feat is of size 25 x 255

% (Kindly cite either of the following papers if you use this code)
% References:
% [1] R. N. Khushaba, A. Al-Jumaily, and A. Al-Ani, “Novel Feature Extraction Method based on Fuzzy Entropy and Wavelet Packet Transform for Myoelectric Control”, 7th International Symposium on Communications and Information Technologies ISCIT2007, Sydney, Australia, pp. 352 – 357.
% [2] R. N. Khushaba, S. Kodagoa, S. Lal, and G. Dissanayake, “Driver Drowsiness Classification Using Fuzzy Wavelet Packet Based Feature Extraction Algorithm”, IEEE Transaction on Biomedical Engineering, vol. 58, no. 1, pp. 121-131, 2011.
% 
% Multiscale Wavelet Packet feature extraction code by Dr. Rami Khushaba
% Research Fellow - Faculty of Engineering and IT
% University of Technology, Sydney.
% Email: Rami.Khushaba@uts.edu.au
% URL: www.rami-khushaba.com (Matlab Code Section)
% Last modified 06/10/2011

function feat = getmswpfeatV00(x,winsize,wininc,SF)

if nargin < 4
    if nargin < 3
        if nargin < 2
            winsize = size(x,1);
        end
        wininc = winsize;
    end
    error('Please provide the sampling frequency of this signal')
end

datawin = ones(winsize,1);
datasize = size(x,1);
Nsignals = size(x,2);
numwin = floor((datasize - winsize)/wininc)+1;

% allocate memory
feat = zeros(winsize,numwin);

st = 1;
en = winsize;

for i = 1:numwin
    curwin = x(st:en,:).*repmat(datawin,1,Nsignals);
    feat(1:winsize,i) = detrend(curwin);
    
    st = st + wininc;
    en = en + wininc;
end
J=7;% Number of decomposition levels which can also be set using J=wmaxlev(winsize,'Sym5');
                                                               % or J=(log(SF/2)/log(2))-1;
D = mswpd('col',feat,'Sym8',J);
Temp = D{1,1};
[nSmp]=size(Temp,2);
clear Temp
feat = zeros(nSmp,2^J+1);
[nL,nF]=size(D);
index =1;
for i=1:nL
    for j=1:nF
        if ~isempty(D{i,j})
            feat(1:nSmp,index) = log(mean(D{i,j}.*D{i,j}))';
            index = index +1;
        end
    end
end
x = sum(feat,1);
x = (x~=0);
feat = feat(:,x);
%% You can comment this section
JJ = J;
for i=1:J-1
    T = (2^i):(2^i)+(2^i)-1;
    feat(:,T) = feat(:,T)./log(JJ);
    JJ=JJ-1;
end
