% evaluate N for lowpass filters
% N_estimate.m

% deltap: passband ripple
% deltas: stopband ripple
% fsc: input sampling rate (Hz)
    deltap=0.0001;
    deltas=0.0001;
    fsc=[6000,6667,8000,10000,16000,20000];
    L=length(fsc);
    
% loop on all choices for fsc
    for index=1:L;
        fs=fsc(index);
        
% tband: normalized transition bandwidth; (Fs-Fp)/fs
        tband=100/fs;
    
% compute estimate of N
        dinf=Dinfinity(deltap,deltas);
        f_k=fK(deltap,deltas);
    
        N=(dinf-f_k*tband^2)/tband+1;
    fprintf('deltap:%6.2f, deltas:%6.2f, fs:%6.2f, tband:%6.2f, N:%6.0f \n',...
        deltap,deltas,fs,tband,N);
    end