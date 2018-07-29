function [G_D2,MSE]=GenerateGD2Table(numiter,N,alphaNT,G_D2init,Range_prior,Range_post)
%function [G_D2,MSE]=GenerateGD2Table(numiter,N,alphaNT,Range_prior,Range_post);
% Generates gain table for MMSE noise power estimation. The recursive
% nature of the estimation problem is taken into account by an iterative
% scheme. For more details see:
%
% J.S. Erkelens and R. Heusdens, "Tracking of nonstationary noise based on
% data-driven recursive noise power estimation", IEEE Trans. Audio,
% Speech & Lang. Proc., vol. 16, no. 6, pp. 1112-1123, 2008.
%
% J.S. Erkelens and R. Heusdens, "Fast noise tracking based on recursive
% smoothing of MMSE noise power estimates", ICASSP 2008, pp. 4873-4876.
%
% INPUT VARIABLES:
% numiter : number of optimization iterations.
% N : frame length.
% alphaNT : smoothing parameter in prior SNR parameter for noise tracking.
% Range_prior : range of the prior SNR parameter, e.g, [-19 40] (as used
% in the papers) means that the prior SNR is quantized between -19 dB and
% 40 dB in steps of 1 dB.
% Range_post: range of the posterior SNR. In the papers [-30 40] is used,
% meaning that the gain table G_D2 has dimensions 60-by-71.
% G_D2init : Initial gain table for MMSE estimation of noise power. May be
% found with the basic data-driven method. Simply initializing with
% ones(60,71) should also work (for Range_prior=[-19 40] and
% Range_post=[-30 40]).
%
% OUTPUT VARIABLES:
% G_D2 : gain table for MMSE estimation of noise power.
% MSE : normalized mean-square error per iteration (NOTE: since we are
% initializing with the noisy powers, this MSE may INCREASE with each
% iteration.
% If we apply the gain functions to the training data RECURSIVELY, however,
% the mse decreases with each iteration step. Both MSEs (on the traindata
% and when applied recursively) do converge to the same end value. See the
% 2nd paper mentioned above for a more thorough explanation and
% illustration.
%
% Copyright 2008: Delft University of Technology, Information and
% Communication Theory Group. The software is free for non-commercial use.
% This program comes WITHOUT ANY WARRANTY.
%
% Last modified: 17-3-2008.

global NoiseSpectrum
load NoiseSpectrum

Gd2new=G_D2init;
% Intialize MSE
MSE=zeros(1,numiter);
% SNRs (dB scale) 
SNRs=[-12.5:5:27.5];
% Directory with training data
DIR='C:/data/Timit_TBW/Matrices/';
% List of training data files
fid=fopen('C:/data/Timit_TBW/trainlist.txt','r');
% read the first filename
s=fgetl(fid);
for k1=1:numiter
    % Initialize statistics needed to compute the optimal gain values
    sumD2R2=zeros(Range_prior(2)-Range_prior(1)+1,Range_post(2)-Range_post(1)+1);
    sumR4=sumD2R2;sumD4=sumD2R2;
    while s~=-1 % while not EOF
        % Use 2 Timit directories for training
        if strcmpi(s(16:18),'dr4') | strcmpi(s(16:18),'dr5')
            % Strip some path info and convert to lowercase
            s=lower(s(16:end-3));
            % Some difference between Windows and Linux
            I=find(s=='\');s(I)='/';
            % Collect statistics for all SNRs
            for snrnr=1:length(SNRs)
                % strip path info, retain file name
                filestr=s(11:end-1);
                % directory name for arrays of frame numbers with
                % sufficient speech energy.
                dirstr=[DIR s(1:10)];
                % load indices of frames with sufficient speech energy.
                % Only those are used for optimization of the gain.
                eval(['load ' dirstr filestr '_IsufE'])
                % directory name for the data at current SNR
                dirstr=[DIR s(1:10) 'Snr' num2str(snrnr) '/'];
                % load noise powers (needed to compute the statistics
                % for gain optimization).
                iterstr='Init';matstrD='Dmatrix';
                filestrD=[dirstr filestr '_' matstrD 'Snr' num2str(snrnr) iterstr];
                eval(['load ' filestrD ' ' matstrD])
                % "Dclean" means the "true" noise powers. The final
                % estimates will of course not be "clean" but contaminated
                % by some speech power.
                Dclean=Dmatrix;
                % Load noisy amplitudes (Rmatrix)
                filestrR=[dirstr filestr '_Rmatrix' 'Snr' num2str(snrnr) 'Init'];
                eval(['load ' filestrR ' Rmatrix'])
                % Load estimates from the previous iteration (Dmatrix) ...
                iterstr='Iter';
                filestrD=[dirstr filestr '_' matstrD 'Snr' num2str(snrnr) iterstr];
                eval(['load ' filestrD ' ' matstrD])
                % ... but initialize with 'Rmatrix', i.e., noisy amplitudes
                % in the first iteration.
                if k1==1,Dmatrix=Rmatrix;end
                % Collect statistics and calculate new data
                [sumd4,sumd2r2,sumr4,Dmatrix]=collectdata(N,alphaNT,IsufE,Dclean,Dmatrix,Rmatrix,Gd2new,Range_prior,Range_post,SNRs(snrnr));
                sumD2R2=sumD2R2+sumd2r2;sumR4=sumR4+sumr4;sumD4=sumD4+sumd4;
                % Save updated Dmatrix
                iterstr='Iter';
                filestrD=[dirstr filestr '_' matstrD 'Snr' num2str(snrnr) iterstr];
                eval(['save ' filestrD ' ' matstrD])
            end % for snrnr=1:length(SNRs)
        end % strcmpi(s(16:18),'dr4') | strcmpi(s(16:18),'dr5')
        % read the next file name
        s=fgetl(fid);
    end % while s~=-1
    % Update gain function and calculate MSE
    sumR41=sumR4;
    sumR41(sumR41==0)=1;% avoid dividing by 0
    Gd2new=sumD2R2./sumR41;
    % Calculate MSE
    MSEd=sumD4-2*Gd2new.*sumD2R2+(Gd2new.^2).*sumR4;
    % Normalize
    MSEd=sum(sum(MSEd))/sum(sum(sumD4));
    MSE(k1)=MSEd;
    % Save some stuff
    alphap=0.1;alphad=0.85;T=4;% These values are used below in the function collectdata
    eval(['save ' DIR2 'GainTable_iteration' num2str(k1) ' Gd2new MSE alphaNT alphad alphap N T']);
    % display number of iterations to go and MSE
    disp(numiter-k1),disp(MSEd)
    % Go through all the data again in the next iteration
    frewind(fid);s=fgetl(fid);
end % for k1=1:numiter
fclose(fid);
G_D2=Gd2new;

function [sumd4,sumd2r2,sumr4,Dnew]=collectdata(N,alphaNT,IsufE,Dclean,Dmatrix,Rmatrix,Gd2new,Range_prior,Range_post,dBsnr)
global NoiseSpectrum
% Initialization of statistics for computing the gain table
sumd2r2=zeros(Range_prior(2)-Range_prior(1)+1,Range_post(2)-Range_post(1)+1);
sumr4=sumd2r2;
sumd4=sumd2r2;
alpha2=0.85*ones(1,N/2+1)';
alphap=0.1;alphad=alpha2(1);
T=4;
% Frequency bins used to collect the statistics from
freqbins=10:110;
% speech presence probability
Pspi=zeros(1,N/2+1)';Pspii=Pspi;
% speech presence index
Isp=zeros(1,N/2+1)';
% minimum value prior SNR
ksi_min=10^(-1.9);% -19 dB
% Initialization of noise variance for iteration i and i+1 (denoted by ii)
labda_di=NoiseSpectrum/(10^(dBsnr/10));%True noise variance.
% Appropriate when the speech is normalized as in GenerateTraindata.m
% Note that statistics are collected for bins in the passband only.
labda_dii=labda_di;
S=size(Dmatrix);
Dnew=zeros(S);Dnew(:,1)=Dmatrix(:,1);
% frame length
N=2*S(1)-2;
S=S(2);
% length of a column of the gain matrix
Gsize=size(Gd2new);Gsize=Gsize(1);
for m=2:S
    R=Rmatrix(:,m);D=Dclean(:,m);
    % Update prior SNR (priorNT) and posterior SNR (postSNR) using data
    % from the last iteration
    postSNR=R.^2./labda_di;
    B0=Rmatrix(:,m-1).^2;
    priorNT=max(alphaNT*B0./labda_di+(1-alphaNT)*postSNR,ksi_min);
    dBprior=10*log10(priorNT);
    dBpost=10*log10(postSNR+eps);
    % Indices in gain table
    Iprior=min(max(round(dBprior),Range_prior(1)),Range_prior(2))-Range_prior(1)+1;
    Ipost=min(max(round(dBpost),Range_post(1)),Range_post(2))-Range_post(1)+1;
    % Update labda_di
    D20=Dmatrix(:,m).^2;
    Mpost=freqsmooth(postSNR,1);Isp=(Mpost>T);
    Pspi=alphap.*Pspi+(1-alphap).*Isp;
    alpha2i=alphad+(1-alphad).*Pspi;
    labda_di=alpha2i.*labda_di+(1-alpha2i).*D20;
    % Calculate new estimated noise powers
    D2=GainR2(Gd2new,Iprior,Ipost,R,N);
    Dnew(:,m)=sqrt(D2);
    % Calculate new priorNT en postSNR
    postSNR=R.^2./labda_dii;
    priorNT=max(alphaNT*B0./labda_dii+(1-alphaNT)*postSNR,ksi_min);
    dBprior=10*log10(priorNT);
    dBpost=10*log10(postSNR+eps);
    Iprior=min(max(round(dBprior),Range_prior(1)),Range_prior(2))-Range_prior(1)+1;
    Ipost=min(max(round(dBpost),Range_post(1)),Range_post(2))-Range_post(1)+1;
    % Collect data from bins 10 t/m 110 (because telephone bandwidth speech
    % is limited to about 300-3400 Hz) for frames with sufficient speech
    % energy.
    if ~isempty(intersect(m,IsufE))
        %CHECK FOR MULTIPLE ELEMENTS
        index2=Iprior(freqbins)+Gsize*(Ipost(freqbins)-1);
        if length(unique(index2))==length(index2)       
            sumd4(index2)=sumd4(index2)+D(freqbins).^4;
            sumr4(index2)=sumr4(index2)+R(freqbins).^4;
            sumd2r2(index2)=sumd2r2(index2)+(R(freqbins).*D(freqbins)).^2;
        else
            for k1=1:length(freqbins)
                index2=Iprior(freqbins(k1))+Gsize*(Ipost(freqbins(k1))-1);
                sumd4(index2)=sumd4(index2)+D(freqbins(k1)).^4;
                sumr4(index2)=sumr4(index2)+R(freqbins(k1)).^4;
                sumd2r2(index2)=sumd2r2(index2)+(R(freqbins(k1)).*D(freqbins(k1))).^2;
            end
        end
    end
    % Update labda_d with new estimate of D^2
    D20=Dnew(:,m).^2;
    Mpost=freqsmooth(postSNR,1);Isp=(Mpost>T);
    Pspii=alphap.*Pspii+(1-alphap).*Isp;
    alpha2ii=alphad+(1-alphad).*Pspii;
    labda_dii=alpha2ii.*labda_dii+(1-alpha2ii).*D20;
end

function Amplitude2=GainR2(Gmatrix,Iprior,Ipost,R,N)
L=size(Gmatrix);L=L(1);
index=1:N/2+1;index2=Iprior(index)+L*(Ipost(index)-1);
Amplitude2=Gmatrix(index2).*(R.^2);

function mx=freqsmooth(x,w)
L=length(x);mx=zeros(size(x));
for k=1:L
    i1=max(k-w,1);i2=min(k+w,L);
    mx(k)=sum(x(i1:i2))/(i2-i1+1);
end
