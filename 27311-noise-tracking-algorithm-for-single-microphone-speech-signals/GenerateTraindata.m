function GenerateTraindata
% Generates training data for GenerateGD2Table.m
warning('off','all')
% Telephone bandwidth filter
[B,A]=potsband(8000);
% SNRs (dB scale) 
SNRs=[-12.5:5:27.5];
% Create |cos|-window
% framelength
N=256;
t=0:N-1;
H=cos(t*pi/N).^2;
H=circshift(H,[0 N/2]);H=sqrt(H);
% Directory to save training data into
DIR='C:/data/Timit_TBW/Matrices/';
if ~exist(DIR,'dir'),mkdir(DIR);end
fid=fopen('C:/data/Timit_TBW/trainlist.txt','r');
s=fgetl(fid);
N=256;
    while s~=-1
        % Use 2 timit-train directories 
        if strcmpi(s(16:18),'dr4') | strcmpi(s(16:18),'dr5')
        % Read the next signal
        s=lower(s(16:end-3));
        I=find(s=='\');s(I)='/';
        % load speech file
        eval(['load -mat C:/data/Timit_TBW/train/' s 'mat']);
        Clean=speech_signal(:)';% Assume it is in the variable speech_signal
        clear speech_signal
        % Normalize to variance of 1 (silence frames are not considered)
        Clean=normalize(Clean,40);varC=1;
        % Collect the indices of frames with sufficient energy. Only those
        % are used for gain optimization.
        IsufE=SufficientEnergy(Clean,H,40);
        M=length(Clean);
        for snrnr=1:length(SNRs)
            % Data is written to separate directories for each SNR
            dirstr=[DIR s(1:9) '/Snr' num2str(snrnr)];
            if ~exist(dirstr,'dir'),mkdir(dirstr),end
            dBsnr=SNRs(snrnr);
            % current snr
            cursnr=10^(dBsnr/10);
            % add noise (telephone bandwidth)
            Noise=randn(1,M+100);%100 extra to let intial conditions decay
            % Limit to telephone bandwidth
            Noise=filter(B,A,Noise);Noise=Noise(101:end);
            noisevar=var(Noise);
            % scale to desired SNR
            Noise=Noise*sqrt(varC/noisevar/cursnr);
            Noisy=Clean+Noise;
            % Generare DFT-amplitude matrices
            Rmatrix=createDFTAmatrix(Noisy,H);
            Dmatrix=createDFTAmatrix(Noise,H);
            % save IsufE
            filestr=upper(s(11:end-1));
            dirstr=[DIR s(1:10)];
            eval(['save ' dirstr filestr '_IsufE IsufE'])
            % Save DFT matrices as initialization data
            dirstr=[dirstr 'Snr' num2str(snrnr) '/'];
            eval(['save ' dirstr filestr '_Rmatrix' 'Snr' num2str(snrnr) 'Init Rmatrix dBsnr'])
            eval(['save ' dirstr filestr '_Dmatrix' 'Snr' num2str(snrnr) 'Init Dmatrix dBsnr'])
        end
        end
        s=fgetl(fid);
    end 
fclose(fid);


function Signal=normalize(Signal,threshold)
% Normalize to variance=1.
% Frames with energy more than threshold (dB) below the energy
% of the max. frame energy are not taken into account.
Nx=length(Signal);
Signal=Signal-mean(Signal);
N=256;
M=floor(Nx/N);
E=zeros(1,M);
for k=1:M
    index=(k-1)*N+1:k*N;
    temp=Signal(index);
    E(k)=sum(temp.^2)+eps;%+eps in the unlikely case that energy=0
end
Emax=max(E);
IsufE=find(10*log10(E/Emax)>-threshold);
varC=sum(E(IsufE))/length(IsufE)/N;
% normalize
Signal=Signal/sqrt(varC);

function IsufE=SufficientEnergy(Signal,window,threshold)
% Frames with energy more than threshold (dB) below the energy
% of the max. frame energy are not taken into account.
% IsufE contains the indices of the other, desired, frames.
Nx=length(Signal);
N=length(window);
M=floor(2*Nx/N-1);
E=zeros(1,M);
for k=1:M
    index=(k-1)*N/2+1:(k+1)*N/2;
    temp=Signal(index).*window;
    E(k)=sum(temp.^2)+eps;%+eps in the unlikely case that energy=0.
end
Emax=max(E);
IsufE=find(10*log10(E/Emax)>-threshold);
