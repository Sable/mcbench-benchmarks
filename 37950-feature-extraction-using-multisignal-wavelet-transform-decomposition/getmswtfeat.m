% GETMSWTFEAT Gets the Multiscale Wavelet Transform features, these
% include: Energy, Variance, Standard Deviation, and Waveform Length
% feat = getmswtfeat(x,winsize,wininc,SF)
% ------------------------------------------------------------------
% The signals in x are divided into multiple windows of size
% "winsize" and the windows are spaced "wininc" apart.
% Inputs
% ------
%    x: 		columns of signals
%    winsize:	window size (length of x)
%    wininc:	spacing of the windows (winsize)
%    SF:        sampling frequency (Not used in the current implementation, but I left you some options down there)
% Outputs
% -------
%    feat:     WT features organized as [Energy, Variance, Waveform Length, Entropy]

% Example
% -------
% feat = getmswtfeat(rand(1024,1),128,32,32)
% Assuming here rand(1024,1) (this can be any one dimensional signal,
% for example EEG or EMG) is a one dimensional signal sampled at 32
% for 32 seconds only. Utilizing a window size of 128 at 32 increments,
% features are extracted from the wavelet tree.
% I assumed 10 decomposition levels (J=10) below in the code.
% For a full tree at 10 levels you should get 11 features
% as we have decided to extract 4 types of features then we get 11 x 4 =44
% features.
% =========================================================================
% Multiscale Wavelet Transform feature extraction code by Dr. Rami Khushaba
% Research Fellow - Faculty of Engineering and IT
% University of Technology, Sydney.
% Email: Rami.Khushaba@uts.edu.au
% URL: www.rami-khushaba.com (Matlab Code Section)
% last modified 29/08/2012
% last modified 09/02/2013

function feat = getmswtfeat(x,winsize,wininc,SF)

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

%% Chop the signal according to a sliding window approach
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
%% ---------------- Various options for J -----------------------
% Note I put SF above in the inputs because you can use SF to determine the
% best decompisition level J, however for simplicity here I put it J=10;
J=10;% Number of decomposition levels which can also be set using
% or J=wmaxlev(winsize,'Sym5');
% or J=(log(SF/2)/log(2))-1;
%% Multisignal one-dimensional wavelet transform decomposition
dec = mdwtdec('col',feat,J,'db4');
% Proceed with Multisignal 1-D decomposition energy distribution

if isequal(dec.dirDec,'c')
    dim = 1;
end
[cfs,longs] = wdec2cl(dec,'all');
level = length(longs)-2;

if dim==1
    cfs = cfs';
    longs = longs';
end
numOfSIGs  = size(cfs,1);
num_CFS_TOT = size(cfs,2);
absCFS   = abs(cfs);
absCFS0   = (cfs);
cfs_POW2 = absCFS.^2;
Energy  = sum(cfs_POW2,2);
percentENER = 0*ones(size(cfs_POW2));
notZER = (Energy>0);
percentENER(notZER,:) = 100*cfs_POW2(notZER,:)./Energy(notZER,ones(1,num_CFS_TOT));

%% or try this version below and tell us which  one is the best on your data
% percentENER(notZER,:) = cfs_POW2(notZER,:);

%% Pre-define and allocate memory
tab_ENER = zeros(numOfSIGs,level+1);
tab_VAR = zeros(numOfSIGs,level+1);
% tab_STD = zeros(numOfSIGs,level+1);
tab_WL = zeros(numOfSIGs,level+1);
tab_entropy = zeros(numOfSIGs,level+1);


%% Feature extraction section
st = 1;
for k=1:level+1
    nbCFS = longs(k);
    en  = st+nbCFS-1;
    tab_ENER(:,k) = mean(percentENER(:,st:en),2);%.*sum(abs(diff(absCFS0(:,st:en)')'),2); % energy per waveform length
    tab_VAR(:,k) = var(percentENER(:,st:en),0,2); % variance of coefficients
    %     tab_STD(:,k) = std(percentENER(:,st:en),[],2); % standard deviation of coefficients
    tab_WL(:,k) = sum(abs(diff(percentENER(:,st:en)').^2))'; % waveform length
    percentENER(:,st:en) = percentENER(:,st:en)./repmat(sum(percentENER(:,st:en),2),1,size(percentENER(:,st:en),2));
    tab_entropy(:,k) = -sum(percentENER(:,st:en).*log(percentENER(:,st:en)),2)./size(percentENER(:,st:en),2);
    st = en + 1;
end
feat =([log1p([tab_ENER tab_VAR  tab_WL]) tab_entropy]);